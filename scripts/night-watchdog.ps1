<#
  night-watchdog.ps1 - external supervisor for /nightmin and /nightmax.

  Claude Code's own cron jobs are in-memory and die with the session, so they
  cannot survive a crash or a usage-limit lockout. This script runs OUTSIDE
  Claude and is the thing that actually makes the night unstoppable.

  Heartbeat: the session transcript (~/.claude/projects/<slug>/*.jsonl) is
  rewritten on every message and tool call, so its mtime is a true liveness
  signal - it stays fresh even mid-task, unlike an idle-only cron tick.
  Stale transcript => the night stalled => relaunch headless with --continue.
#>
param(
  [ValidateSet('min','max')] [string]$Mode = 'min',
  [string]$Cwd = (Get-Location).Path,
  [int]$StaleMinutes = 20,
  [int]$IntervalSeconds = 900,
  [double]$MaxHours = 18,
  [string]$Brief = ''
)

$ErrorActionPreference = 'Continue'
$nightDir = Join-Path $env:USERPROFILE '.claude\night'
if (-not (Test-Path $nightDir)) { New-Item -ItemType Directory -Force $nightDir | Out-Null }

$stopFile = Join-Path $nightDir 'STOP'
$pidFile  = Join-Path $nightDir 'watchdog.pid'
$logFile  = Join-Path $nightDir 'night.log'

# Transcript dir: cwd with every non-alphanumeric char replaced by '-'
$slug        = [regex]::Replace($Cwd, '[^A-Za-z0-9]', '-')
$projectDir  = Join-Path $env:USERPROFILE ".claude\projects\$slug"

function Write-Log([string]$msg) {
  $line = "[{0}] {1}" -f (Get-Date -Format 'yyyy-MM-dd HH:mm:ss'), $msg
  Add-Content -Path $logFile -Value $line -Encoding utf8
}

# A fresh night starts clean.
if (Test-Path $stopFile) { Remove-Item $stopFile -Force -Confirm:$false }
Set-Content -Path $pidFile -Value $PID -Encoding utf8

$deadline = (Get-Date).AddHours($MaxHours)
$restarts = 0

if ($Mode -eq 'max') {
  $resume = @"
NIGHTMAX RESUME. The previous run stopped (crash, error, or usage limit). Resume immediately and keep working.

Rules still in force: work fully autonomously. Never ask a question, never wait for confirmation, never hand work back. Use Bash/PowerShell freely to do the actual work; just never block on a prompt. Do NOT stop when the current task is finished - when you run out of assigned work, pick the highest-value next thing from the brief and keep going. Only the user saying GM or stop ends this.

Read $Brief for the night's brief and the running log of what is already done. Append what you complete to it as you go.
"@
} else {
  $resume = @"
NIGHTMIN RESUME. The previous run stopped (crash, error, or usage limit) before the work was finished. Resume immediately.

Rules still in force: work fully autonomously. Never ask a question, never wait for confirmation, never hand work back. Use Bash/PowerShell freely to do the actual work; just never block on a prompt. Keep going until every item in the brief is done, or until what remains is genuinely blocked - then write the morning report and stop.

Read $Brief for the night's brief and the checklist of what is already done. Append what you complete to it as you go. When everything is done or blocked, create the file $stopFile so this watchdog exits.
"@
}

Write-Log "watchdog start mode=$Mode pid=$PID cwd=$Cwd stale=${StaleMinutes}m interval=${IntervalSeconds}s deadline=$($deadline.ToString('yyyy-MM-dd HH:mm'))"
Write-Log "watching transcripts in $projectDir"

while ($true) {
  if (Test-Path $stopFile) { Write-Log 'STOP file present - watchdog exiting.'; break }
  if ((Get-Date) -gt $deadline) { Write-Log "max runtime ${MaxHours}h reached - watchdog exiting."; break }

  $newest = $null
  if (Test-Path $projectDir) {
    $newest = Get-ChildItem -Path $projectDir -Filter '*.jsonl' -File |
              Sort-Object LastWriteTime -Descending | Select-Object -First 1
  }

  $stale = $true
  if ($null -ne $newest) {
    $ageMin = ((Get-Date) - $newest.LastWriteTime).TotalMinutes
    if ($ageMin -lt $StaleMinutes) { $stale = $false }
  }

  if ($stale) {
    $restarts++
    Write-Log "session looks stalled (no transcript activity for >= ${StaleMinutes}m) - restart #$restarts"
    try {
      # Blocks until the relaunched run finishes, so restarts never pile up.
      & claude --autocompact 200k --continue --dangerously-skip-permissions -p $resume *>> $logFile
      Write-Log "relaunched run exited (code $LASTEXITCODE)"
    } catch {
      Write-Log "relaunch failed: $($_.Exception.Message)"
    }
  }

  Start-Sleep -Seconds $IntervalSeconds
}

if (Test-Path $pidFile) { Remove-Item $pidFile -Force -Confirm:$false }
Write-Log "watchdog stopped after $restarts restart(s)."

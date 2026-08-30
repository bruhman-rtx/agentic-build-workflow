<#
  install.ps1 - install the night commands and the watchdog into ~/.claude/

  Creates ~/.claude/commands/ and ~/.claude/night/ if absent, installs every
  command file from this repo's commands/ directory, and installs the watchdog.

  IDEMPOTENT. Safe to re-run: a file whose contents already match is reported
  as up to date and left alone.

  NEVER OVERWRITES WITHOUT ASKING. A customised nightmax.md is not ours to
  replace. If a destination file exists and differs, you are prompted. When
  running non-interactively (CI, a piped shell) the file is SKIPPED, never
  overwritten - pass -Force to overwrite deliberately.

  Usage:
    ./install.ps1                 # install, prompting on conflicts
    ./install.ps1 -Force          # overwrite differing files without asking
    ./install.ps1 -Symlink        # link instead of copy, so edits track the repo
    ./install.ps1 -ClaudeHome D:\alt\.claude   # non-default location
    ./install.ps1 -WhatIf         # show what would happen, change nothing
#>
[CmdletBinding(SupportsShouldProcess = $true)]
param(
  # Root of the Claude config directory. Defaults to ~/.claude, which is where
  # Claude Code looks. Override only if yours lives elsewhere.
  [string]$ClaudeHome = (Join-Path $HOME '.claude'),

  # Overwrite existing files that differ, without prompting.
  [switch]$Force,

  # Symlink instead of copying, so edits in the repo take effect immediately.
  # Falls back to copying if the OS refuses (Windows needs Developer Mode or
  # an elevated shell to create symlinks).
  [switch]$Symlink
)

$ErrorActionPreference = 'Stop'

$repoRoot    = Split-Path -Parent $PSScriptRoot
$srcCommands = Join-Path $repoRoot 'commands'
$srcScripts  = Join-Path $repoRoot 'scripts'

$dstCommands = Join-Path $ClaudeHome 'commands'
$dstNight    = Join-Path $ClaudeHome 'night'

$installed = @(); $skipped = @(); $current = @()

function Test-Interactive {
  # Non-interactive when stdin is redirected or there is no user session.
  # In that case we skip conflicts rather than guessing.
  try {
    if ([Console]::IsInputRedirected) { return $false }
    return [Environment]::UserInteractive
  } catch { return $false }
}

function New-DirIfMissing([string]$path) {
  if (Test-Path -LiteralPath $path) { return }
  if ($PSCmdlet.ShouldProcess($path, 'Create directory')) {
    New-Item -ItemType Directory -Force -Path $path | Out-Null
    Write-Host "  created  $path" -ForegroundColor Green
  }
}

function Get-FileHashSafe([string]$path) {
  # Deliberately uses .NET rather than Get-FileHash: the provider cmdlets it
  # relies on inherit $WhatIfPreference, so under -WhatIf they return nothing
  # and two different files compare equal. This path is unaffected.
  try {
    $sha = [System.Security.Cryptography.SHA256]::Create()
    $fs  = [System.IO.File]::OpenRead($path)
    try { [BitConverter]::ToString($sha.ComputeHash($fs)) } finally { $fs.Dispose(); $sha.Dispose() }
  } catch { $null }
}

function Install-One {
  param([string]$Source, [string]$Destination)

  $name = Split-Path -Leaf $Destination

  if (Test-Path -LiteralPath $Destination) {
    if ((Get-FileHashSafe $Source) -eq (Get-FileHashSafe $Destination)) {
      Write-Host "  up to date  $name" -ForegroundColor DarkGray
      $script:current += $name
      return
    }

    if (-not $Force) {
      if (-not (Test-Interactive)) {
        Write-Host "  SKIPPED     $name (exists and differs; non-interactive)" -ForegroundColor Yellow
        $script:skipped += $name
        return
      }
      Write-Host ""
      Write-Host "  $name already exists at $Destination and differs from this repo's copy." -ForegroundColor Yellow
      $answer = Read-Host "  Overwrite it? [y/N]"
      if ($answer -notmatch '^(y|yes)$') {
        Write-Host "  SKIPPED     $name (kept your version)" -ForegroundColor Yellow
        $script:skipped += $name
        return
      }
    }
  }

  if (-not $PSCmdlet.ShouldProcess($Destination, 'Install')) { return }

  if ($Symlink) {
    try {
      if (Test-Path -LiteralPath $Destination) { Remove-Item -LiteralPath $Destination -Force -Confirm:$false }
      New-Item -ItemType SymbolicLink -Path $Destination -Target $Source -Force | Out-Null
      Write-Host "  linked      $name" -ForegroundColor Green
      $script:installed += $name
      return
    } catch {
      Write-Host "  (symlink refused, copying instead - Windows needs Developer Mode or an elevated shell)" -ForegroundColor DarkYellow
    }
  }

  Copy-Item -LiteralPath $Source -Destination $Destination -Force
  Write-Host "  installed   $name" -ForegroundColor Green
  $script:installed += $name
}

# --- checks ------------------------------------------------------------------

if (-not (Test-Path -LiteralPath $srcCommands)) {
  throw "commands/ not found at $srcCommands - run this script from inside a clone of the repo."
}

Write-Host ""
Write-Host "Installing to $ClaudeHome" -ForegroundColor Cyan
Write-Host ""

New-DirIfMissing $dstCommands
New-DirIfMissing $dstNight

# --- command files -----------------------------------------------------------

Write-Host ""
Write-Host "Commands:" -ForegroundColor Cyan

$commandFiles = Get-ChildItem -LiteralPath $srcCommands -Filter '*.md' -File |
                Where-Object { $_.Name -ne 'README.md' }

if (-not $commandFiles) {
  Write-Host "  (none found in commands/)" -ForegroundColor Yellow
} else {
  foreach ($f in $commandFiles) {
    Install-One -Source $f.FullName -Destination (Join-Path $dstCommands $f.Name)
  }
}

# --- watchdog ----------------------------------------------------------------

Write-Host ""
Write-Host "Watchdog:" -ForegroundColor Cyan

$watchdog = Join-Path $srcScripts 'night-watchdog.ps1'
if (Test-Path -LiteralPath $watchdog) {
  Install-One -Source $watchdog -Destination (Join-Path $dstNight 'night-watchdog.ps1')
} else {
  Write-Host "  night-watchdog.ps1 not found in scripts/" -ForegroundColor Yellow
}

# --- summary and next steps --------------------------------------------------

Write-Host ""
Write-Host ("-" * 68) -ForegroundColor DarkGray
Write-Host ("Installed: {0}   Already current: {1}   Skipped: {2}" -f $installed.Count, $current.Count, $skipped.Count)

if ($skipped.Count -gt 0) {
  Write-Host ""
  Write-Host "Kept your existing versions of: $($skipped -join ', ')" -ForegroundColor Yellow
  Write-Host "Re-run with -Force to replace them, or diff them against this repo first." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "Next steps" -ForegroundColor Cyan
Write-Host ""
Write-Host "  1. Write the two documents. Start at prompts/01-prd-interrogation.md."
Write-Host "     Templates: templates/PRD-template.md, templates/PIPELINE-template.md"
Write-Host ""
Write-Host "  2. Put PRD.md, PIPELINE.md and CLAUDE.md in the target repo root."
Write-Host "     Template: templates/CLAUDE.md.template"
Write-Host ""
Write-Host "  3. Fill the night brief - this is the memory across crashes:"
Write-Host "       $(Join-Path $dstNight 'brief.md')"
Write-Host "     Template: templates/brief.md.template"
Write-Host ""
Write-Host "  4. Walk templates/preflight-checklist.md, then arm the run."
Write-Host ""
Write-Host "  Kill switch: create $(Join-Path $dstNight 'STOP') to stop the watchdog." -ForegroundColor DarkGray
Write-Host ""

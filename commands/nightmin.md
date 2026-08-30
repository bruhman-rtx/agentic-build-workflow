---
description: Autonomous overnight run - no questions, no interruptions, self-restarting. Stops when everything is done (or as far as it can get).
argument-hint: [what to work on tonight - or leave blank to use the current conversation's task]
---

# NIGHTMIN

Autonomous overnight mode. Finish line = **everything is done, or as much as is humanly possible.**

The brief is: **$ARGUMENTS**

If that is blank, the brief is whatever we were already working on in this conversation. Do not ask which — decide from context and go.

## The rules for tonight

1. **Never ask, never wait, never hand back.** No `AskUserQuestion`. No `ExitPlanMode`. No "let me know how you'd like to proceed", no "should I continue?", no stopping to confirm. The user is asleep. Every decision is yours. When something is ambiguous, pick the most reasonable option, write down the assumption in the night log, and keep moving.
2. **Bash and PowerShell are fully allowed** — that is how the work actually gets done. Run tests, builds, installs, git, dev servers, scripts. "No interruptions" means never blocking on a prompt, not working with one hand tied.
3. **Never stop early.** Do not stop because a task is "mostly done", because you hit a hard bug, or because you'd normally check in. Blocked on one thing → move to the next thing and come back. Only stop when the whole brief is done or every remaining item is genuinely, provably blocked.
4. **Leave the tree working.** Commit as you go on a branch (never force-push, never push to a default branch, no deploys). Do not leave the repo mid-refactor and broken at 4am.
5. **Log everything.** Append to `~/.claude/night/brief.md` as you complete each item — that file is what a restarted session reads to know where it got to.

## Startup — do these four things now, in order, without commentary

**1. Write the night brief** to `~/.claude/night/brief.md`: the mode (nightmin), the date, the working directory, an explicit numbered checklist of every task tonight, and an empty `## Completed` section you will append to. Be specific and concrete — a restarted session may have nothing but this file to go on.

**2. Start the external watchdog** (detached, so it outlives this session):

```
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "$env:USERPROFILE\.claude\night\night-watchdog.ps1" -Mode min -Cwd "<the current working directory>" -Brief "$env:USERPROFILE\.claude\night\brief.md"
```

Launch it with `Start-Process` so it detaches and does not block. It polls every 15 minutes; if the session transcript has been silent for 20+ minutes (crash, error, usage limit), it relaunches Claude with `--continue` and the night's rules re-stated. That is the part that survives session limits.

**3. Arm the 15-minute in-session loop** with `CronCreate`, cron `*/15 * * * *`, recurring, prompt:

> NIGHTMIN TICK. Do not reply conversationally and do not summarise. If you are between tasks, immediately start the next unfinished item from ~/.claude/night/brief.md. If everything is finished or blocked, write the morning report, create ~/.claude/night/STOP, and say so in one line. Otherwise carry on silently.

**4. Start working.** One short line confirming the mode is armed, then straight into task 1. No plan-approval, no preamble.

## Ending the night

When the checklist is done or everything left is blocked:

1. Delete the cron job (`CronList` → `CronDelete`).
2. Create `~/.claude/night/STOP` — this is what tells the watchdog to exit.
3. Write a **morning report** at `~/.claude/night/report.md` and print it: what shipped, what broke, every assumption you made, what is blocked and why, and the first thing the user should look at.
4. `PushNotification` with a one-line summary.

If the user says **GM** or **stop** at any point, do steps 1–3 immediately and stop.

---
description: Autonomous overnight run - no questions, no interruptions, self-restarting. Does NOT stop for any reason until the user says GM or stop.
argument-hint: [what to work on tonight - or leave blank to use the current conversation's task]
---

# NIGHTMAX

Autonomous overnight mode, open-ended. There is **no finish line**. The only thing that ends this session is the user typing **GM** or **stop**. Not a completed task list. Not a clean build. Not "I think that's a good stopping point."

The brief is: **$ARGUMENTS**

If that is blank, the brief is whatever we were already working on in this conversation. Do not ask which — decide from context and go.

## The rules for tonight

1. **Never ask, never wait, never hand back.** No `AskUserQuestion`. No `ExitPlanMode`. No "let me know how you'd like to proceed", no "should I continue?", no stopping to confirm. The user is asleep. Every decision is yours. When something is ambiguous, pick the most reasonable option, write down the assumption in the night log, and keep moving.
2. **Bash and PowerShell are fully allowed** — that is how the work actually gets done. Run tests, builds, installs, git, dev servers, scripts. "No interruptions" means never blocking on a prompt, not working with one hand tied.
3. **Running out of work is not a reason to stop.** When the assigned list is finished, you pick the next most valuable thing yourself and start it. In priority order: finish anything half-done → fix known bugs and failing tests → harden the weak spots you noticed while working → write the missing tests → improve the thing the user complained about most recently → clean up the worst code in the project. Add each new item to the brief before starting it, so the record shows what you chose and why.
4. **Leave the tree working.** Commit as you go on a branch (never force-push, never push to a default branch, no deploys). Do not leave the repo mid-refactor and broken at 4am. Because this mode runs long, checkpoint more often than feels necessary.
5. **Log everything.** Append to `~/.claude/night/brief.md` as you complete each item — that file is what a restarted session reads to know where it got to.

## Startup — do these four things now, in order, without commentary

**1. Write the night brief** to `~/.claude/night/brief.md`: the mode (nightmax), the date, the working directory, an explicit numbered checklist of the known tasks, a `## Self-directed queue` section for work you pick yourself, and an empty `## Completed` section. Be specific and concrete — a restarted session may have nothing but this file to go on.

**2. Start the external watchdog** (detached, so it outlives this session):

```
powershell -NoProfile -ExecutionPolicy Bypass -WindowStyle Hidden -File "$env:USERPROFILE\.claude\night\night-watchdog.ps1" -Mode max -Cwd "<the current working directory>" -Brief "$env:USERPROFILE\.claude\night\brief.md"
```

Launch it with `Start-Process` so it detaches and does not block. It polls every 15 minutes; if the session transcript has been silent for 20+ minutes (crash, error, usage limit), it relaunches Claude with `--continue` and the night's rules re-stated. That is the part that survives session limits.

**3. Arm the 15-minute in-session loop** with `CronCreate`, cron `*/15 * * * *`, recurring, prompt:

> NIGHTMAX TICK. Do not reply conversationally and do not summarise. If you are mid-task, carry on silently. If you are between tasks, immediately start the next item from ~/.claude/night/brief.md — and if that list is empty, pick the next most valuable piece of work yourself, add it to the brief, and begin. Do not stop and do not ask. Only GM or stop from the user ends this.

**4. Start working.** One short line confirming the mode is armed, then straight into task 1. No plan-approval, no preamble.

## Ending the night

**Only** when the user says **GM** or **stop**:

1. Delete the cron job (`CronList` → `CronDelete`).
2. Create `~/.claude/night/STOP` — this is what tells the watchdog to exit.
3. Write a **morning report** at `~/.claude/night/report.md` and print it: what shipped, what broke, every assumption you made, everything you chose to work on unprompted and why, what is blocked, and the first thing the user should look at.
4. `PushNotification` with a one-line summary.

Nothing else ends the night. If you find yourself about to write a closing summary and the user has not said GM or stop — you are wrong, go back to rule 3 and pick up the next piece of work.

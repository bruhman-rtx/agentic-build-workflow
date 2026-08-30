# Commands

Custom slash commands live in `~/.claude/commands/`. Three matter for this workflow. Two of them ship here.

| File | Mode | Ends when |
|---|---|---|
| [`nightmin.md`](nightmin.md) | `/nightmin` | Everything in the brief is done or genuinely blocked |
| [`nightmax.md`](nightmax.md) | `/nightmax` | Only when you say `GM` or `stop` |
| *(does not exist)* | `/goal` | — see below |

Install them with [`scripts/install.ps1`](../scripts/install.ps1) or [`scripts/install.sh`](../scripts/install.sh). Both are idempotent and neither will overwrite an existing file without asking.

---

## `/goal` is not a command

**It never was.** The source machine had no `~/.claude/commands/goal.md`, so there was nothing to extract, and the build rule is extract or halt — never invent a command file. Writing a plausible one would have produced a file that looks authoritative and matches nothing.

That halt is what settled the question. The workflow document had described `/goal` alongside two commands that do exist, in the same register, with no marker separating them; the absence was only visible to something that went looking for the file. Version 1.1 of the source document reclassifies it — [`docs/workflow.md`](../docs/workflow.md) §2.1 is now headed **"`/goal` — proposed, not built"** and carries the workaround below. So this is not a gap in the extraction. It is the extraction working.

What `/goal` was meant to be: a single sentence defining what the run is *for*. Not a task list — the brief holds tasks. It is the standard the agent measures candidate work against when it has to decide what to do next.

It matters most under `/nightmax`, where running out of assigned work is not a finish condition and the agent must select its own next task. Without a goal, "most valuable task" is undefined and the agent optimises for whatever is nearest.

**The sentence is still mandatory; only the typing shortcut is missing.** Put it at the top of `~/.claude/night/brief.md` under `## GOAL` (the [brief template](../templates/brief.md.template) has the section) and state it in the arming message. That is strictly better than a command anyway: a command sets it in one session’s context, and a night run outlives its sessions — the brief is what a restarted session re-reads.

```
GOAL: Get the engine through Stage 3 with the fidelity suite
green, and do not begin any client work.
```

A good goal is falsifiable and bounded. "Make progress on the app" is neither.

---

## `/nightmin`

Works the brief, then stops. It ends when everything in the brief is either done or genuinely blocked.

Use when the work is well-defined and finite — a stage with a clear DoD. **The stopping behaviour is a feature:** an agent that stops when the brief is complete has not invented work to fill time.

This puts weight on the `BLOCKED` section of the brief. Under `/nightmin`, everything being done or blocked *is* the finish condition — so a task parked there wrongly ends the night early.

## `/nightmax`

Never stops on its own. Only `GM` or `stop` from you ends it. Running out of assigned work is not a finish condition — it selects the next most valuable task itself and continues.

Use when the work is open-ended and you want maximum throughput across an unattended window. **Requires a genuinely good `/goal`**, because self-selected work is only as good as the standard it is selected against.

### Choosing

| | `/nightmin` | `/nightmax` |
|---|---|---|
| Work | Finite, with a DoD | Open-ended |
| Runs out of tasks | Stops | Picks the next one |
| Goal sentence | Useful | **Load-bearing** |
| Failure mode | Stops early on a soft blocker | Drifts into work you did not want |

---

## Shared rules

Both modes:

- **Never ask.** No `AskUserQuestion`.
- **Never hand work back.** No `ExitPlanMode`.
- **Never wait.**
- Bash and PowerShell remain fully available — "no bash commands" in the config means no *permission prompts*, not a shell ban.
- **Silence is correct** while a night mode is armed. Progress goes to `brief.md`, not to you.

The first two rules are why this method exists. **An agent that cannot ask is an agent whose questions must be pre-answered** — which is what the PRD, the pipeline document, and the clarifying round in [`prompts/06`](../prompts/06-clarifying-round.md) are for.

The third rule is the one that surprises people. There is no held question and no queued approval; when the agent hits genuine ambiguity it logs it to the `OPEN` section of the brief, takes the most conservative option, and keeps going. Read `OPEN` first in the morning — every entry marks a place the two documents failed.

---

## Restart survival

Two layers. **Either alone is insufficient**, which is worth internalising before arming a long run.

### Layer 1 — the cron nudge

A 15-minute `CronCreate` loop nudges an idle session.

Cron jobs are **held in memory and die with the session**. So this layer handles a session that has gone quiet but is still alive — and nothing else. A crash takes the nudge down with it.

### Layer 2 — the watchdog

[`scripts/night-watchdog.ps1`](../scripts/night-watchdog.ps1), installed to `~/.claude/night/` and **launched detached via `Start-Process`**. This is what actually survives crashes and usage limits.

| Property | Behaviour |
|---|---|
| Poll interval | 15 minutes |
| Relaunch trigger | Session transcript idle 20+ minutes |
| Heartbeat | Transcript `mtime` — chosen because it updates *mid-task*, not only at task boundaries |
| Relaunch command | `claude --continue -p` |
| Concurrency | Relaunches are synchronous, so the watchdog cannot stack its *own* relaunches. This is **not** the same as being safe against a second writer — see below |
| Kill switch | `~/.claude/night/STOP` |
| Runaway guard | `-MaxHours`, default 18 |

The heartbeat choice is the subtle part. A signal that only updates at task boundaries cannot distinguish a long task from a dead session, so it either kills healthy work or waits out the night. Transcript `mtime` moves while the agent is mid-task.

### `-Cwd` is the whole safety property

The transcript slug is `-Cwd` with every non-alphanumeric character replaced by `-`. Get `-Cwd` wrong and the watchdog does not error —it watches the wrong directory, and fails in one of two silent ways:

| Wrong `-Cwd` points at | What the watchdog sees | What you get |
|---|---|---|
| A slug with **no** transcripts | No heartbeat, ever | It concludes "stalled" on the *first* poll and relaunches against a session that is perfectly healthy. **Two agents, same repo, same brief, overwriting each other.** |
| A slug some **other** session keeps warm | A permanently fresh heartbeat | It never fires. The night runs with no crash recovery at all, and the log looks clean the entire time. |

Both were observed on a real run —see [`docs/postmortems/2026-08-30-agentic-build-workflow.md`](../docs/postmortems/2026-08-30-agentic-build-workflow.md). The second is the more dangerous, and it is what you get if you "fix" the first by pointing `-Cwd` somewhere that happens to look alive.

The script now defends what it can:

- **It fails closed.** No transcript means liveness is *unknown*, not stalled, so it logs the resolved slug and waits instead of relaunching. Only a transcript that exists and is stale triggers a restart.
- **It reports its heartbeat at arm time** —which file, how many minutes old. Nothing in the script can tell whether that file belongs to the run you armed, so **check that line in `night.log` immediately after arming.** It is the only moment the second failure mode is visible.

Pass `-Cwd` the project directory the session actually runs in, as an absolute path.

**Launched detached, or it is not a second layer at all.** A watchdog started inside the session dies with the session, which is precisely the case the cron nudge already fails at — two copies of layer 1.

### Why neither is sufficient alone

| Failure | Cron nudge alone | Watchdog alone |
|---|---|---|
| Session idles but is alive | Recovers | Recovers, ~20 min later |
| Session crashes | **Dies with it** | Recovers |
| Usage-limit lockout | **Dies with it** | Recovers |
| Agent stalls briefly mid-run | Recovers immediately | Waits for the idle threshold |

The nudge is fast and fragile; the watchdog is slow and durable. Run both.

---

## State lives in `~/.claude/night/`

| File | Role |
|---|---|
| `brief.md` | The checklist a restarted session re-reads to recover context. **This is the memory across crashes** — if it is thin, a restart resumes blind. |
| `night.log` | Watchdog activity |
| `report.md` | Run output |
| `night-watchdog.ps1` | The watchdog itself |
| `STOP` | Kill switch; create it to end the watchdog |

None of this is in your project repository, and none of it belongs there — a real `brief.md` carries project specifics. This repo's `.gitignore` excludes `brief.md` and `report.md` for that reason; only [`templates/brief.md.template`](../templates/brief.md.template) is public.

**Pre-flight check:** confirm the directory holds more than just the watchdog script before arming. A run with no brief is a run that cannot survive its first restart. This is the single check that catches the most expensive failure — see [`templates/preflight-checklist.md`](../templates/preflight-checklist.md).

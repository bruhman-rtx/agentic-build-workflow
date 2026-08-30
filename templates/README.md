# Templates

Seven fillable files. Every heading carries its guidance in an HTML comment — what the section must answer, and what goes wrong if it is thin.

**The comments are the documentation.** Leave them in while the agent is building; they cost nothing and they tell a future session what each section was supposed to contain. Strip them before sharing the document with a human if you like.

**For what a filled version looks like, see [`examples/bourse/`](../examples/bourse/)** — a real PRD and pipeline document from a project built with this method, verbatim and unedited. The templates tell you what a section is for; the example shows you an answer that works at full size. Read them side by side.

---

## What each one is

| Template | What it is | Created when | Lives in |
|---|---|---|---|
| [`PRD-template.md`](PRD-template.md) | The specification of record. 20 sections plus two optional appendices. | After [`prompts/01`](../prompts/01-prd-interrogation.md) | Target repo root, as `PRD.md` |
| [`PIPELINE-template.md`](PIPELINE-template.md) | The build order, the exit gates, and Appendix A — the part the agent executes against. | After [`prompts/02`](../prompts/02-pipeline-adaptation.md) | Target repo root, as `PIPELINE.md` |
| [`CLAUDE.md.template`](CLAUDE.md.template) | Read automatically at every session start. Under twenty lines. | Before the first session | Target repo root, as `CLAUDE.md` |
| [`PROGRESS.md.template`](PROGRESS.md.template) | Session-by-session handoff. | Before the first session; appended at every session end | Target repo root, as `PROGRESS.md` |
| [`BUGS.md.template`](BUGS.md.template) | Every non-trivial bug, so patterns become visible across sessions. | Before the first session; appended as bugs occur | Target repo root, as `BUGS.md` |
| [`brief.md.template`](brief.md.template) | The night-run checklist. **The memory across crashes.** | Immediately before arming a night run | `~/.claude/night/brief.md` — **not** the repo |
| [`preflight-checklist.md`](preflight-checklist.md) | Twelve items to clear before arming. | Read, not copied | Stays here |

---

## Repo root vs `~/.claude/night/`

Five of these live in the target project's repository and are committed with it. They are the project's own documents, and they are what a fresh session reads to orient itself.

**`brief.md` is different.** It goes to `~/.claude/night/`, alongside the watchdog, and it is **not** committed — this repo's `.gitignore` excludes `brief.md` and `report.md` precisely because a real one carries project specifics. Only the `.template` is public.

That directory is where run state lives:

| File | Role |
|---|---|
| `brief.md` | The checklist a restarted session re-reads to recover context |
| `night.log` | Watchdog activity |
| `report.md` | Run output |
| `night-watchdog.ps1` | The watchdog itself — see [`scripts/`](../scripts/) |
| `STOP` | Kill switch; its presence ends the watchdog |

**Pre-flight:** confirm that directory holds more than just the watchdog script before arming. A run with no brief is a run that cannot survive its first restart.

---

## Order of creation

1. `PRD.md` — from prompt 01
2. `PIPELINE.md` — from prompt 02, same conversation
3. `CLAUDE.md` — hand-filled, pointing at both
4. `PROGRESS.md` and `BUGS.md` — empty tables, ready to append
5. `~/.claude/night/brief.md` — last, immediately before arming
6. Walk [`preflight-checklist.md`](preflight-checklist.md), then say go

---

## The three sections that carry the most weight

Inside `PRD-template.md`, three sections do disproportionate work in an agentic build, and each is marked in its guidance comment:

- **§20 Decision log** — the lookup table the agent greps when uncertain. Exhaustive, one line per decision, append-only.
- **§18 Open questions** — the honesty valve. Anything not listed is treated as settled, so an empty section actively misleads.
- **§19 Phasing with exit gates** — the only structure preventing work from being built on a foundation that does not hold. Every gate testable, never a judgement call.

Inside `PIPELINE-template.md`, one section does: **Appendix A**. Everything above it exists to make it correct.

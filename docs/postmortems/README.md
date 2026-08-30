# Postmortems

One file per night run. This directory is where evidence that the method works — or doesn't — accumulates.

The method in [`docs/workflow.md`](../workflow.md) is a set of claims about what prevents an agentic build from going wrong. Claims need evidence. A postmortem is the evidence for one run, written whether the run succeeded or not, because a run that went well for reasons you can't name is not a repeatable process.

---

## Naming

```
YYYY-MM-DD-<project>.md
```

The date the run was **armed**, not the date you read the report. A run armed at 11pm on the 3rd and read at 8am on the 4th is `2026-09-03-<project>.md`.

Use the project's short name, lowercase, hyphenated — the same name as its repository where possible.

```
2026-09-03-tessellate.md
2026-09-11-tessellate.md
2026-09-14-ledger-import.md
```

Multiple runs for one project on one day get a `-2`, `-3` suffix.

---

## What a postmortem covers

Four sections, in this order. The order matters: it moves from what you intended, to what happened, to why the gap existed, to what changes as a result.

### 1. What was armed

The setup, precisely enough that someone could reconstruct it.

- Night mode (`/nightmin` or `/nightmax`) and why that one
- The `/goal`, quoted verbatim
- Which stage of the pipeline doc the run was pointed at
- The state of `brief.md` when the run started — paste it, or link the commit
- Watchdog settings that differed from default (`-MaxHours`, `-StaleMinutes`)
- Anything unusual about the environment: missing toolchain, a service that had to be up, a known-flaky test

### 2. What came back

What the agent believed it did, and what it actually did. Read `report.md` first and the diff second — per `docs/workflow.md` Section 4 §4.5, the divergence between them is the whole point.

- Summary of `report.md`: what shipped, what broke, what was blocked
- Number of watchdog restarts, and what caused them (crash, usage limit, stall)
- Whether the stage's definition of done was actually met, in your judgement rather than the agent's
- **Where the report and the diff disagree.** Be specific. This is the highest-value part of the file.
- Any test that was weakened, skipped, or deleted — check for this explicitly rather than trusting the report

### 3. Where the documents were ambiguous

Every place the agent had to guess. The `OPEN` section of `brief.md` is the agent's own list; it will be incomplete, because the guesses it didn't notice making are the ones that matter.

For each ambiguity: what was unclear, what the agent chose, whether the choice was right, and which document should have settled it — the PRD, the pipeline doc, or the assembled prompt.

### 4. What changed in the method

The section that makes the file worth writing. If nothing changed, say so explicitly and say why — a run that surfaced no improvements is a real outcome, but an unexamined one is not.

- Rows added or strengthened in [`docs/failure-modes.md`](../failure-modes.md)
- Changes to the templates in [`templates/`](../../templates/)
- Changes to the prompts in [`prompts/`](../../prompts/)
- Changes to the command files or the watchdog

Link the commit that made each change. A postmortem that recommends a change without linking the change is a to-do list.

---

## The standing rule

**Write it before you start the next run.** The details that matter are the ones that fade first, and the temptation to skip the postmortem is strongest exactly when the run went well.

A postmortem that only ever gets written after a bad night produces a catalogue of disasters and no record of what actually works.

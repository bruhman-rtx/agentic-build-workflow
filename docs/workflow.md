# Before Claude Code Builds Anything
## The pre-build workflow: two documents, three prompts, and an unattended run

| Field | Value |
|---|---|
| Version | 1.0 |
| Date | 29 August 2026 |
| Purpose | The repeatable process for taking an app from a sentence in your head to an armed overnight Claude Code run, without the agent guessing at anything that mattered |

---

## Abstract

An agentic coding run fails in one of two ways. It builds the wrong thing, or it builds the right thing in the wrong order and discovers the foundation was broken after eight hours of work sat on top of it. Both failures share a root cause: the agent had to make a decision that should have been made before it started.

This document is the front-loading process that removes those decisions. It produces two artifacts and one prompt.

**The PRD** answers *what to build*. It is written by interrogation, not dictation — you describe the app in a paragraph, and Claude Desktop asks you thirty questions until nothing consequential is left ambiguous. The output is a specification dense enough that an engineer could build from it without asking you anything, ending in a decision log that captures every choice you made.

**The pipeline doc** answers *how to build it, in what order, and how to know when a stage is actually done*. It is derived from the AAA-company reference pipeline, adapted in context to your specific app, and it ends in an execution appendix written for the agent rather than for a human team.

**The Claude Code prompt** assembles both files with a night command, a goal, an instruction block, a verification protocol, and a tool inventory — then closes by demanding clarifying questions before any work begins.

That last step is not optional politeness. **The night commands forbid the agent from asking anything.** No `AskUserQuestion`, no `ExitPlanMode` — it works in silence until it finishes or you stop it. Every ambiguity that would ordinarily surface as a mid-build question has to be surfaced and closed *before* the run is armed, because once it is armed the agent will resolve ambiguity by inventing an answer and building on it. The clarifying-question round at the end of the prompt is the last chance to catch what the two documents missed.

The whole process costs an evening. It is the difference between waking up to a working foundation and waking up to eight hours of confident, well-tested, wrong.

---

## Section 1 — Context

### 1.1 Why two documents and not one

A PRD describes a destination. It is written in the present tense of a finished product: the app *has* these screens, the engine *behaves* this way. That is the correct register for a specification, and it is useless as a work order — nothing in it says what to build first, or what "first" even means.

A pipeline doc describes a route. Stages, dependencies, exit gates, and the specific tests that prove a stage is complete. It is written in the imperative and it assumes the destination is already settled.

Collapsing them into one document produces a file that does neither job well, because the two are read at different moments and by different processes. The agent reads the PRD when it needs to know *what a thing is*, and the pipeline when it needs to know *whether it is allowed to proceed*. Keeping them separate also means the PRD stays stable while the pipeline is annotated with progress, which matters over a multi-session build.

### 1.2 Why the questioning phase is the real work

The instinct is to write the PRD yourself and hand it over. This produces a worse document, for a reason that has nothing to do with writing ability: **you cannot enumerate your own assumptions.** The things you haven't thought about are, by definition, invisible to you. A structured interrogation surfaces them because the questioner has no stake in your mental model and asks about the boring adjacent decisions you skipped.

Thirty questions is roughly the point at which a consumer app of moderate complexity stops yielding new information. Fewer than twenty and you have a sketch. More than forty and you are usually re-asking things in different words.

### 1.3 What the agent does with ambiguity

Left unspecified, a coding agent does not stop. It picks the most conventional option and proceeds, and it will do this confidently and without flagging it. This is correct behaviour for a tool that must keep moving, and it is catastrophic under a night command where nobody is watching.

The three defences, in order of strength:

1. **The decision log** in the PRD — an explicit table of settled choices. The agent greps this.
2. **The open questions section** — an explicit list of what is *not* settled. Anything absent from this list is treated as decided. An empty section is therefore a lie with consequences.
3. **The clarifying-question round** before arming the run — the last human checkpoint.

---

## Part 1 — The PRD

### 1.1 The prompt

*In this repo: [`prompts/01-prd-interrogation.md`](../prompts/01-prd-interrogation.md)*

Paste into a **fresh** Claude Desktop conversation. Nothing else in context; the interrogation works better when the model isn't anchored on prior threads.

```
I want to build [one paragraph: what the app is, who it's for,
and the core thing a user does in it].

Before writing anything, interrogate this properly. Ask me
clarifying questions covering mechanics, content, economy,
progression, technical constraints, UI, and scope — everything
you'd need to write a PRD detailed enough that an engineer
could build from it without asking me anything.

Use the interactive question tool, three questions per batch,
and keep going in batches until you've genuinely covered the
space. Expect 25–40 questions total. Don't stop early.

Rules for the questioning:
- One decision per question, with concrete options, not
  open-ended prompts
- If I answer "your call" or "whatever's best", make the
  decision yourself, state what you chose and why, and move on
- If an answer of mine creates a conflict or a hidden cost,
  flag it in that turn rather than absorbing it silently
- Don't ask what I've already told you

When questioning is done, write the PRD as a markdown file.
Maximum detail — this is the specification of record, not a
summary. Include a decision log at the end capturing every
answer I gave. Flag anything you decided on my behalf, and
list what remains genuinely open.
```

**Why each rule earns its place.**

*Three per batch* — a thirty-question dump gets abandoned halfway through. Batches keep it conversational and let later questions adapt to earlier answers.

*Decide-for-me permission* — you will hit choices you have no opinion on. Without explicit permission to proceed, the conversation stalls on a decision that doesn't matter, and you start answering arbitrarily just to move on. Arbitrary answers are worse than delegated ones.

*Flag conflicts* — a polite questioner absorbs contradictions silently. You find them in month four. Requiring the flag in-turn converts a future problem into a present one, which is always the cheaper trade.

*Decision log* — this table is the single most-referenced artifact during the build. Everything else in the PRD is prose the agent must interpret; the log is unambiguous.

### 1.2 The skeleton

*In this repo: [`templates/PRD-template.md`](../templates/PRD-template.md)*

Section order matters. Each constrains the next, and the document is read top-down.

**Front matter:** version, date, author, status, working title, companion doc pointer.

| # | Section | What it must answer | Failure mode if thin |
|---|---|---|---|
| 1 | Document purpose | Who reads this, and what they can do afterwards | Nobody knows if it's a pitch or a spec |
| 2 | Product summary | The whole product in 4–6 paragraphs, ending in a one-line promise | Readers form different mental models and never discover it |
| 3 | Goals, non-goals, success metrics | Numbered goals with rationale; aggressively stated non-goals; targets with actual numbers | Scope creeps in month four with no basis to refuse it |
| 4 | Target users | 2–4 personas, each ending in a *design implication* line | Personas become decoration nobody consults |
| 5 | Design principles | 5–6 rules that pre-resolve future arguments | Every small decision gets re-litigated from scratch |
| 6 | Core loop | The repeating cycle, diagrammed, with a target session shape | Features accumulate with no place in the loop |
| 7–9 | Domain model | The 2–4 sections unique to *your* product — the world, the engine, the content system, whatever the hard part is | The part no template provides, and where generic PRDs fail |
| 10 | Core mechanics | The rules of interaction, exhaustively | Engineers invent the missing rules, and they're wrong |
| 11 | Economy / stakes | What's scarce, what's earned, what's lost | No tension, or tension in the wrong places |
| 12 | Progression | How capability expands over time | Everything available on day one; the user drowns |
| 13 | Content systems | Reference, teaching, help — **with volume targets** | Content is discovered as a ten-month workstream in month eight |
| 14 | Interface | Platforms, navigation, key screens, design tokens, onboarding, accessibility | Design starts from zero and drifts |
| 15 | Technical architecture | Stack **with reasons**, where logic runs, data model, performance budgets | Architecture decided by whoever writes code first |
| 16 | Non-functional requirements | Offline, privacy, legal positioning, data ownership, localisation | Retrofitted, expensively, under deadline |
| 17 | Risks | Severity-rated, each with a mitigation | Known risks surprise everyone anyway |
| 18 | Open questions | What you genuinely haven't decided | Fake certainty; the agent invents answers silently |
| 19 | Phasing | Ordered phases with **exit gates** | The agent builds the visible thing first |
| 20 | Decision log | Every locked decision as a one-line table | Decisions quietly reverse across sessions |

**The three that carry disproportionate weight in an agentic build:**

- **Decision log (§20)** — the lookup table when the agent is uncertain. Make it exhaustive and one line per decision.
- **Open questions (§18)** — the honesty valve. Anything not listed here is treated as settled, so an empty section actively misleads.
- **Phasing with exit gates (§19)** — the only structure preventing work from being built on a foundation that doesn't hold. Every phase needs a gate that is *testable*, not a gate that is a judgement call.

**Two additions worth making if your product has them:**

- **A domain-fidelity section.** If your app simulates, models, or reproduces something real — a market, a physical system, a legal process — you need a section defining what "accurate" means in testable terms. This becomes the most valuable document in the build.
- **A kill-criteria table.** The thresholds at which you'd stop. Written before you're emotionally invested, which is the only time they can be written honestly.

---

## Part 2 — The Pipeline Doc

### 2.1 The prompt

*In this repo: [`prompts/02-pipeline-adaptation.md`](../prompts/02-pipeline-adaptation.md). The reference doc to attach is [`reference/aaa-pipeline.md`](../reference/aaa-pipeline.md).*

Run this in the **same Claude Desktop conversation** that produced the PRD. It needs the accumulated context — a fresh conversation will produce a generic pipeline that could apply to any app, which is exactly what you don't want.

```
[Attach: the AAA company pipeline reference doc]

Now adapt this pipeline to the app we just specified. Not a
summary of it — a version rewritten in context of this
specific product, where every phase, gate, and artifact is
about what we're actually building.

Requirements:

1. Identify this product's equivalent of the feasibility
   spike — the single technical bet that, if it fails, kills
   the thesis. Make it a blocking Stage 1 with an explicit
   stop condition and testable pass criteria.

2. Identify this product's equivalent of the rater
   guidelines — the document that encodes the subjective
   standard so it becomes a system rather than one person's
   judgement. Specify its contents section by section.

3. Adapt the compliance matrix to this product's actual
   regulatory surface. Drop what doesn't apply, and be
   specific about what replaces it.

4. Size a realistic team, then state honestly what it costs
   to run the full pipeline — that number is the argument
   for which gates a lean build skips.

5. Split the lean-build translation into Keep, Compress, and
   Skip, with a reason per line in Keep.

6. End with an execution appendix written for a coding agent,
   not a human team: ordered stages, a testable definition of
   done per stage, explicit stop conditions, and standing
   rules the agent must never violate.

Write it as a markdown file, companion to the PRD, and
cross-reference PRD section numbers throughout.
```

**The two requirements that matter most** are 1 and 6. Requirement 1 forces the hardest technical risk to the front of the schedule, where it is cheap to fail. Requirement 6 is the only part of the document the agent actually executes against — everything above it is context that makes the appendix correct.

### 2.2 The skeleton

*In this repo: [`templates/PIPELINE-template.md`](../templates/PIPELINE-template.md)*

| # | Section | Contents |
|---|---|---|
| — | Front matter | Version, date, companion PRD pointer, purpose |
| — | **Adaptation note** | How this product differs structurally from the reference, and what that changes in the pipeline. Written first because it justifies every deviation below. |
| — | Phase map | Single table: phase, duration, exit gate |
| 0 | Origination | How the idea enters; the artifact is a one-pager and a scrappy demo of *the hard part* |
| 1 | Opportunity assessment | User sizing, competitive teardown, strategic fit, cost model. **The teardown is the part a lean build keeps** — it becomes your differentiation copy and your test matrix. |
| 2 | Funding & staffing | The honest team table. This number exists to justify what you skip. |
| 3 | Discovery + **the feasibility spike** | Foundational research, and the blocking technical gate with numeric pass criteria |
| 4 | Product definition | The PRD, plus the fidelity/standards spec, plus kill criteria |
| 5 | Technical design | Design doc inventory; cross-cutting reviews that start here and run for months |
| 6 | Build & internal iteration | Engineering practice, the internal release ladder, parallel workstreams |
| 7 | Compliance & launch review | The blocking-reviewer matrix, adapted to this product's real surface |
| 8 | Staged rollout | Rollout ladder, the experiments that matter, guardrails that block launch |
| 9 | GA | Launch mechanics, war room, what to watch in the first 72 hours |
| 10 | Operate / iterate / sunset | Ongoing rituals, and the data-export commitment |
| — | **Lean-build translation** | Keep (with a reason each) / Compress / Skip |
| — | **The asymmetry** | Why this product suits a small team or a large one, and which gates transfer regardless |
| — | **Appendix A: execution order** | Repo layout, ordered stages with DoD and stop conditions, standing rules for the agent |

**Appendix A is the operative document.** Everything above it exists to make it correct. It should contain:

- Repository structure, so the agent doesn't invent one
- Numbered stages in strict dependency order
- A **testable** definition of done per stage — "the suite is green", not "the engine works"
- Explicit **stop conditions** on any blocking stage, phrased to override schedule pressure
- **Standing rules**: the four to six things the agent must never do, stated as prohibitions rather than preferences

---

## Section 2 — The Commands

Custom slash commands live in `~/.claude/commands/`. Three matter for this workflow.

### 2.1 `/goal`

*In this repo: not shipped — see [`commands/README.md`](../commands/README.md) for why, and for the workaround.*

A single sentence defining what the run is *for*. Not a task list — the brief holds tasks. This is the standard the agent measures candidate work against when it needs to decide what to do next.

It matters most under `/nightmax`, where running out of assigned work is not a finish condition and the agent must select its own next task. Without a goal, "most valuable task" is undefined and the agent optimises for whatever is nearest.

```
/goal Get the engine through Stage 3 with the fidelity suite
green, and do not begin any client work.
```

A good goal is falsifiable and bounded. "Make progress on the app" is neither.

### 2.2 `/nightmin`

*In this repo: [`commands/nightmin.md`](../commands/nightmin.md)*

Works the brief, then stops. It ends when everything in the brief is either done or genuinely blocked.

Use when the work is well-defined and finite — a stage with a clear DoD. The stopping behaviour is a feature: an agent that stops when the brief is complete has not invented work to fill time.

### 2.3 `/nightmax`

*In this repo: [`commands/nightmax.md`](../commands/nightmax.md)*

Never stops on its own. Only `GM` or `stop` from you ends it. Running out of assigned work is not a finish condition — it selects the next most valuable task itself and continues.

Use when the work is open-ended and you want maximum throughput across an unattended window. **Requires a genuinely good `/goal`**, because self-selected work is only as good as the standard it's selected against.

### 2.4 Shared rules

Both modes:

- **Never ask.** No `AskUserQuestion`.
- **Never hand work back.** No `ExitPlanMode`.
- **Never wait.**
- Bash and PowerShell remain fully available — "no bash commands" in the config means no *permission prompts*, not a shell ban.
- **Silence is correct** while a night mode is armed. Progress goes to `brief.md`, not to you.

The first two rules are why this entire document exists. An agent that cannot ask is an agent whose questions must be pre-answered.

### 2.5 Restart survival

*In this repo: [`scripts/night-watchdog.ps1`](../scripts/night-watchdog.ps1), installed by [`scripts/install.ps1`](../scripts/install.ps1). See [`commands/README.md`](../commands/README.md) for the two-layer explanation.*

Two layers. **Either alone is insufficient**, which is worth internalising before arming a long run.

**Layer 1 — the cron nudge.** A 15-minute `CronCreate` loop nudges an idle session. Cron jobs are held in memory and die with the session, so this handles stalls but not crashes.

**Layer 2 — the watchdog.** `~/.claude/night/night-watchdog.ps1`, launched detached via `Start-Process`. This is what actually survives crashes and usage limits.

| Property | Behaviour |
|---|---|
| Poll interval | 15 minutes |
| Relaunch trigger | Session transcript idle 20+ minutes |
| Heartbeat | Transcript `mtime` — chosen because it updates *mid-task*, not only at task boundaries |
| Relaunch command | `claude --continue -p` |
| Concurrency | Relaunches are synchronous, so they cannot pile up |
| Kill switch | `~/.claude/night/STOP` |
| Runaway guard | `-MaxHours`, default 18 |

**State lives in `~/.claude/night/`:**

| File | Role |
|---|---|
| `brief.md` | The checklist a restarted session re-reads to recover context. **This is the memory across crashes** — if it's thin, a restart resumes blind. |
| `night.log` | Watchdog activity |
| `report.md` | Run output |

**Pre-flight check:** confirm the directory holds more than just the watchdog script before arming. A run with no brief is a run that cannot survive its first restart.

---

## Section 3 — The Instructions

The final Claude Code prompt has six components in a fixed order. Components 3, 5, and 6 are generated by the same Claude Desktop instance that wrote the two documents — it has the context to write them accurately, and you have the context to check them.

### 3.1 Prompt structure

```
1. The two files          PRD + pipeline doc, attached
2. Night command          /nightmin or /nightmax
3. /goal                  One falsifiable sentence
4. Instructions           How to read and use the two files
5. Verification & bug fixing
6. Tool inventory
7. Clarifying questions    ← the last human checkpoint
```

### 3.2 Generating the instruction block

*In this repo: [`prompts/03-instruction-block.md`](../prompts/03-instruction-block.md)*

Ask the desktop instance:

```
Write the instruction block for the Claude Code prompt.
It should tell the agent how to read and use both documents,
where to start, how to know when to advance, and what to
never do. One paragraph, dense, addressed to the agent.
```

It should come back looking roughly like this:

> Read the PRD fully first, then the pipeline doc. The PRD is the specification of what to build; the pipeline doc is the process and the build order. Begin at Appendix A, Stage 0, and do not advance to the next stage until that stage's definition of done is demonstrably met — not asserted, demonstrated. Stage 1 is blocking: if its pass criteria cannot be met after two remediation attempts, stop and write the failure to `report.md` rather than proceeding. Follow the standing rules in Appendix A on every commit. When the two documents conflict, the PRD's decision log wins on *what*, the pipeline wins on *when*. Cite the PRD section number that motivates each significant implementation decision, in the commit message. Anything not settled by either document and not listed in PRD §18 should be treated as settled — if you find something genuinely ambiguous that neither document covers, record it in `brief.md` under OPEN and proceed with the most conservative option.

That last clause matters. Under a night command the agent cannot ask, so it needs an explicit protocol for what to do with a question it can't ask: **log it, choose conservatively, keep going.**

### 3.3 Verification and bug fixing

*In this repo: [`prompts/04-verification-and-bugfixing.md`](../prompts/04-verification-and-bugfixing.md)*

Ask the desktop instance:

```
Write the verification and bug-fixing paragraph for the
Claude Code prompt, based on my actual toolchain: [list what
you have]. Cover what runs before every commit, what happens
when something fails, and what the agent must never do to
make a test pass.
```

The shape it should produce:

> Nothing merges without green. Before any commit, run the full check: the language test suites, typecheck, unit tests, and the relevant UI harness. Install missing toolchain components at Stage 0 rather than working around them. Bring the containerised stack up before integration tests and tear it down after. From the client stages onward, every commit touching the desktop client runs the browser-automation harness against the built app, and every commit touching mobile boots the emulator headless and runs the mobile UI flows. When a test fails, do not proceed to new work and do not weaken, skip, or delete the test — reproduce the failure in isolation, write a minimal failing case if one doesn't exist, fix the root cause, then re-run the full suite to confirm nothing else regressed. Treat any failure of a foundational-fidelity test as P0: the change is wrong, or the spec needs a human decision, which you record and defer rather than resolve. Log every non-trivial bug in `BUGS.md` with reproduction, root cause, and fix, so patterns become visible across sessions.

**The load-bearing sentence is "do not weaken, skip, or delete the test."** An unattended agent under pressure to make a suite pass will absolutely delete an assertion, and it will describe this accurately and calmly in its report. This must be a prohibition, not a preference.

**Note on harness selection:** browser-automation tools drive Electron and web natively. They do *not* drive React Native. Mobile UI testing needs a mobile-specific harness against an emulator. Getting this wrong wastes a stage.

### 3.4 Tool inventory

*In this repo: [`prompts/05-tool-inventory.md`](../prompts/05-tool-inventory.md)*

Ask the desktop instance:

```
Based on the tools I have available — [list them] — write the
tool inventory paragraph for the Claude Code prompt. Say what
each is for, when to reach for it, and any tool that looks
applicable but isn't.
```

The last clause is the valuable one. **Explicitly naming what a tool cannot do prevents a stage of wasted work**, and the agent will otherwise assume capability from a plausible name.

Cover: shell, repo operations, containerisation, database, emulator, UI harnesses, and any knowledge base. Close with a triage rule — *prefer the narrowest tool that answers the question; read a log before booting an emulator, run a unit test before a full UI flow* — because an unattended agent that reaches for the heaviest tool first burns the night on setup.

### 3.5 The clarifying-question round

*In this repo: [`prompts/06-clarifying-round.md`](../prompts/06-clarifying-round.md)*

The final line of the prompt, and the last checkpoint before silence:

```
Before doing any work: ask me as many clarifying questions as
you need. Anything ambiguous in either document, anything
about my environment, anything you would otherwise have to
guess at. Ask everything now — once the night command is
armed you cannot ask, and an unresolved ambiguity becomes a
guess you build on for eight hours. Do not start until I
say go.
```

Take this round seriously. It is the highest-value ten minutes in the entire process: the agent has read both documents in full and can see the gaps between them, which is a vantage point you don't have.

---

## Section 4 — Additions Worth Making

Five things not in the base workflow that materially improve the outcome.

### 4.1 `CLAUDE.md` in the repo root

*In this repo: [`templates/CLAUDE.md.template`](../templates/CLAUDE.md.template)*

Claude Code reads this automatically at every session start. The prompt you carefully assembled is gone the moment context resets; `CLAUDE.md` is not. It should hold, in under twenty lines: what the two documents are, where to start, the stage-gate rule, the standing rules, and the verification requirement.

**Without this, session two starts blind.** On a nine-stage build spanning many sessions, that is the difference between a coherent codebase and a patchwork.

### 4.2 `PROGRESS.md`, updated at every session end

*In this repo: [`templates/PROGRESS.md.template`](../templates/PROGRESS.md.template). Bug logging uses [`templates/BUGS.md.template`](../templates/BUGS.md.template).*

What shipped, which DoD criteria are met, what's next. This is the handoff between sessions and the thing you read in the morning to know where you are without reading a diff.

### 4.3 One stage per session

Resist the urge to let a single session span stages. Stage boundaries are where the DoD check happens, and a session that crosses one has usually skipped it. Ending the session forces the gate.

### 4.4 A named failure mode to guard against

*In this repo: the full catalogue is [`docs/failure-modes.md`](failure-modes.md).*

**The agent will build the visible thing first.** UI is legible progress; a matching engine or a data layer is not. Every instruction that enforces stage order is fighting this specific tendency, and it is worth stating the prohibition explicitly rather than hoping the ordering implies it.

### 4.5 Read the morning report before the code

`report.md` and `PROGRESS.md` tell you what the agent *believes* it did. The diff tells you what it did. Read the belief first — where the two diverge is exactly where the documents were ambiguous, and that divergence is the input to the next revision of the PRD.

---

## Appendix — Pre-flight Checklist

*In this repo: [`templates/preflight-checklist.md`](../templates/preflight-checklist.md)*

Run before arming any night command.

- [ ] PRD written, with a populated decision log and an honest open-questions section
- [ ] Pipeline doc written, with a testable DoD per stage and explicit stop conditions
- [ ] Both files in the repo root
- [ ] `CLAUDE.md` written
- [ ] `/goal` is one falsifiable sentence
- [ ] Night mode chosen — `/nightmin` for finite work, `/nightmax` for open-ended
- [ ] `~/.claude/night/brief.md` populated (**not just the watchdog script**)
- [ ] Watchdog launched detached; `-MaxHours` set appropriately
- [ ] `STOP` file path known and reachable
- [ ] Toolchain verified present, or Stage 0 instructed to install it
- [ ] Clarifying-question round completed and every question answered
- [ ] You have actually said go

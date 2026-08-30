<!--
PIPELINE TEMPLATE — the route, not the destination.

HOW TO USE THIS FILE
Produced by prompts/02-pipeline-adaptation.md, run in the SAME Claude Desktop
conversation that produced the PRD. It needs the accumulated context; a fresh
conversation produces a generic pipeline that could apply to any app, which
gates nothing.

The PRD says WHAT to build. This document says HOW, IN WHAT ORDER, and HOW TO
KNOW WHEN A STAGE IS ACTUALLY DONE. Keep them separate: the agent reads the PRD
when it needs to know what a thing is, and this when it needs to know whether
it is allowed to proceed. This document also gets annotated with progress,
which is why the PRD stays clean.

CROSS-REFERENCE PRD SECTION NUMBERS THROUGHOUT. Where the two documents
conflict, the PRD's decision log wins on *what*, this document wins on *when*.

APPENDIX A IS THE OPERATIVE SECTION. Everything above it exists to make it
correct. If you are short on time, phases 0-10 can be thin; Appendix A cannot.
-->

# PIPELINE — [Working Title]

| Field | Value |
|---|---|
| Version | 0.1 |
| Date | [YYYY-MM-DD] |
| Companion doc | [PRD.md](PRD.md) |
| Purpose | The build order, the exit gates, and the execution appendix the agent works against |

---

## Adaptation Note

<!--
WRITE THIS FIRST. It justifies every deviation below.

MUST ANSWER: How this product differs structurally from the reference pipeline
(reference/aaa-pipeline.md), and what that changes here.

The reference model describes an 18-30 month, fully-staffed consumer product
programme. Yours is not that. Say precisely how it differs — team size,
regulatory surface, whether there is a real ML component, whether there is
user-generated content — because each difference is what licenses you to drop
a gate later. A deviation without a stated reason reads as an oversight, and
the next person to read this will re-add the gate.

FAILURE MODE IF THIN: the pipeline reads as a summary of the reference doc with
the product's name substituted in, and nothing in it actually gates anything.
-->

| Dimension | Reference model | This product | What that changes |
|---|---|---|---|
| Team size | | | |
| Timeline | | | |
| Regulatory surface | | | |
| The hard technical part | | | |

---

## Phase Map

<!--
MUST ANSWER: a single table — phase, duration, exit gate.

One row per phase, nothing else. This is the orientation table someone reads
before the detail, and its value is that it fits on a screen.

Every exit gate here must be TESTABLE. If a gate reads as a judgement call,
fix it here before it propagates into Appendix A, where it becomes the thing
that lets the agent advance on a broken foundation.
-->

| # | Phase | Duration | Exit gate (testable) |
|---|---|---|---|
| 0 | Origination | | |
| 1 | Opportunity assessment | | |
| 2 | Funding & staffing | | |
| 3 | Discovery + feasibility spike | | |
| 4 | Product definition | | |
| 5 | Technical design | | |
| 6 | Build & internal iteration | | |
| 7 | Compliance & launch review | | |
| 8 | Staged rollout | | |
| 9 | GA | | |
| 10 | Operate / iterate / sunset | | |

---

## Phase 0 — Origination

<!--
MUST ANSWER: How the idea enters; the artifact is a one-pager and a scrappy
demo of *the hard part*.

Note "the hard part". A demo of the easy part proves nothing and is the most
common way this phase gets faked. If the demo is a UI mock, it is the wrong
demo — see docs/failure-modes.md, "agent builds the visible thing first".
-->

---

## Phase 1 — Opportunity Assessment

<!--
MUST ANSWER: User sizing, competitive teardown, strategic fit, cost model.

THE TEARDOWN IS THE PART A LEAN BUILD KEEPS. It becomes two things you will
otherwise have to invent later: your differentiation copy, and your test matrix.
Every competitor behaviour you catalogue is a case your product must handle,
handle differently on purpose, or explicitly refuse.

Keep the teardown concrete — named products, specific behaviours, what each
gets right.
-->

---

## Phase 2 — Funding & Staffing

<!--
MUST ANSWER: The honest team table.

THIS NUMBER EXISTS TO JUSTIFY WHAT YOU SKIP. Size the team the full pipeline
would actually need, and cost it honestly. The gap between that number and what
you have is the entire argument for the Skip column in the lean-build
translation below.

Do not shrink the estimate to feel better about it. An understated number
weakens the very argument this section exists to make.
-->

| Role | Headcount (full pipeline) | Available here |
|---|---|---|
| | | |

**Full-pipeline cost:** [honest number] · **Actual:** [what you have]

---

## Phase 3 — Discovery & the Feasibility Spike

<!--
MUST ANSWER: Foundational research, and the blocking technical gate with
NUMERIC pass criteria.

*** THE MOST IMPORTANT PHASE IN THIS DOCUMENT. ***

Every product has one technical bet that, if it fails, kills the thesis. This
phase tests it in week one, cheaply, before anything is built on top of it.
Requirement 1 of the pipeline prompt exists to force it here, where failing is
cheap.

The pass criteria must be NUMBERS, not judgement. "The ranking is good enough"
cannot fail. "Beats the naive baseline on human agreement by >= 15 points on a
200-item sample" can.

The stop condition must be phrased to OVERRIDE SCHEDULE PRESSURE, because the
failure mode is proceeding hopefully rather than stopping honestly.

See reference/feasibility-spikes.md for how to identify yours and how to write
the halt instruction.
-->

**The bet:** [the single technical claim the product rests on]

| Pass criterion | Threshold (numeric) | How measured | Sample / load |
|---|---|---|---|
| | | | |

**Stop condition:** <!-- What happens if it fails, phrased to override schedule pressure. Include a bounded remediation count. -->

---

## Phase 4 — Product Definition

<!--
MUST ANSWER: The PRD, plus the fidelity/standards spec, plus kill criteria.

The fidelity/standards spec is requirement 2 of the pipeline prompt: this
product's equivalent of rater guidelines — the document that encodes the
subjective standard so it becomes a system rather than one person's judgement.
Specify its contents section by section, not just its existence.

If you have one, it lives in PRD Appendix A (Domain Fidelity). Kill criteria
live in PRD Appendix B.
-->

| Artifact | Where it lives | Status |
|---|---|---|
| PRD | `PRD.md` | |
| Fidelity / standards spec | | |
| Kill criteria | PRD Appendix B | |

---

## Phase 5 — Technical Design

<!--
MUST ANSWER: Design doc inventory; cross-cutting reviews that start here and
run for months.

"Start here and run for months" is the point — these reviews are not a gate at
the end, they are a workstream beginning now. Naming them here is what stops
them from being discovered as a blocking surprise in Phase 7.
-->

| Design doc | Covers | PRD section |
|---|---|---|
| | | |

---

## Phase 6 — Build & Internal Iteration

<!--
MUST ANSWER: Engineering practice, the internal release ladder, parallel
workstreams.

For an agentic build this is where most of the calendar goes, and where
Appendix A does the real work. Keep this phase's prose short and push the
operative detail down into Appendix A rather than duplicating it.
-->

---

## Phase 7 — Compliance & Launch Review

<!--
MUST ANSWER: The blocking-reviewer matrix, adapted to this product's REAL
regulatory surface.

Requirement 3 of the pipeline prompt: drop what does not apply, and be specific
about what replaces it. A matrix copied wholesale from the reference model is
worse than none, because it trains everyone to ignore the matrix.
-->

| Review | Applies? | Why / why not | Blocking? |
|---|---|---|---|
| | | | |

---

## Phase 8 — Staged Rollout

<!--
MUST ANSWER: Rollout ladder, the experiments that matter, guardrails that block
launch.

A guardrail is only a guardrail if it can block. Give each one a numeric
threshold, the same discipline as the feasibility spike.
-->

---

## Phase 9 — GA

<!--
MUST ANSWER: Launch mechanics, war room, what to watch in the first 72 hours.
-->

---

## Phase 10 — Operate, Iterate, or Sunset

<!--
MUST ANSWER: Ongoing rituals, and the data-export commitment.

The data-export commitment is easy to defer and expensive to retrofit. It
should agree with PRD §16 (data ownership and export).
-->

---

## Lean-Build Translation

<!--
MUST ANSWER: Keep / Compress / Skip, WITH A REASON PER LINE IN KEEP.

Requirement 5 of the pipeline prompt. The reason in the Keep column is what
makes this section survive contact with a deadline — under pressure, an
unreasoned Keep migrates to Compress and then to Skip without anyone noticing.

Skip is not shameful. The Phase 2 cost number is what justifies it. But an
unexplained Skip is indistinguishable from an oversight, so give it a line too.
-->

### Keep — these prevent product-killing failures

| Gate / artifact | Why it stays |
|---|---|
| | |

### Compress

| Gate / artifact | Compressed to |
|---|---|
| | |

### Skip

| Gate / artifact | Why it is safe to skip here |
|---|---|
| | |

---

## The Asymmetry

<!--
MUST ANSWER: Why this product suits a small team or a large one, and which
gates transfer regardless.

The transferable gates are the useful output of this section — the handful of
things that are worth doing at any team size. Those are the ones that must
appear in Appendix A.
-->

---

# Appendix A — Execution Order

<!--
=============================================================================
*** THIS IS THE OPERATIVE DOCUMENT. ***

Everything above exists to make this appendix correct. It is the only part the
agent actually executes against, and it is written FOR A CODING AGENT, not for
a human team.

It must contain four things, and the guidance for each is below:
  1. Repository structure — so the agent does not invent one
  2. Numbered stages in strict dependency order
  3. A TESTABLE definition of done per stage
  4. Explicit stop conditions on any blocking stage
  5. Standing rules — 4-6 prohibitions

Write it in the imperative. Address the agent directly. Assume it will be read
by a session that has no memory of you writing it, because that is exactly what
happens from session two onward.
=============================================================================
-->

## A.1 Repository Structure

<!--
Specify the layout so the agent does not invent one. A directory tree in a
fenced block, with a one-line purpose per directory.

FAILURE MODE IF THIN: layout emerges from whatever the agent typed first and is
never coherent again.

Include where PRD.md, PIPELINE.md, CLAUDE.md, PROGRESS.md and BUGS.md live —
the workflow assumes repo root for all five.
-->

```
[project]/
├── CLAUDE.md          # read automatically at every session start
├── PRD.md             # the specification of record
├── PIPELINE.md        # this document
├── PROGRESS.md        # updated at every session end
├── BUGS.md            # every non-trivial bug
└── ...
```

## A.2 Stages

<!--
NUMBERED, IN STRICT DEPENDENCY ORDER. One stage per session — stage boundaries
are where the definition-of-done check happens, and a session that crosses one
has usually skipped it.

FOR EACH STAGE, THE DEFINITION OF DONE MUST BE TESTABLE.
  Bad:  "the engine works"
  Good: "the fidelity suite is green on the reference dataset"

The test: could a session at 3am, with no human present and an incentive to
advance, honestly claim this stage was done when it was not? If yes, the gate
is not testable yet. Rewrite it as a command that exits zero.

Stage 0 is toolchain setup. Install missing components there rather than
working around them later.

Stage 1 is the feasibility spike from Phase 3, and it is BLOCKING.

Copy the template block below once per stage.
-->

### Stage 0 — [Toolchain and scaffold]

- **Depends on:** —
- **Deliverable:**
- **Definition of done (testable):** <!-- a command that exits zero -->
- **Stop condition:** <!-- if any -->
- **PRD sections:**

### Stage 1 — [The feasibility spike] · **BLOCKING**

- **Depends on:** Stage 0
- **Deliverable:**
- **Definition of done (testable):** <!-- the numeric pass criteria from Phase 3 -->
- **Stop condition:** <!--
  REQUIRED ON THIS STAGE. Phrase it to override schedule pressure and bound the
  retries. For example: "if the pass criteria are not met after two remediation
  attempts, STOP. Do not proceed to Stage 2. Write the failure, the measured
  numbers, and what was attempted to report.md, and halt."
  The failure mode is proceeding hopefully rather than stopping honestly, so
  the instruction has to be unambiguous enough to survive an agent that wants
  to keep moving.
  -->
- **PRD sections:**

### Stage 2 — [...]

- **Depends on:** Stage 1
- **Deliverable:**
- **Definition of done (testable):**
- **Stop condition:**
- **PRD sections:**

## A.3 Standing Rules

<!--
FOUR TO SIX THINGS THE AGENT MUST NEVER DO, STATED AS PROHIBITIONS RATHER THAN
PREFERENCES.

This distinction is not stylistic. "Prefer not to weaken tests" and "do not
weaken tests" produce measurably different behaviour from an unattended agent
under pressure to make a suite pass.

Keep the list short. Four to six rules get followed; fifteen get skimmed.

The starter set below is drawn from docs/failure-modes.md. Replace or extend it
with the prohibitions specific to your product — but do not delete rules 1 or 2.
-->

1. **Never weaken, skip, or delete a test to make a suite pass.** Reproduce the failure in isolation, write a minimal failing case if one does not exist, fix the root cause, then re-run the full suite.
2. **Never advance past a stage whose definition of done is not demonstrated.** Asserted is not demonstrated.
3. **Never resolve an ambiguity silently.** If neither document settles it, record it in `brief.md` under `OPEN`, choose the most conservative option, and keep going.
4. **Never build UI ahead of the foundation it displays.** Stage order is not a suggestion.
5. **Never force-push, never push to the default branch, never deploy.**
6. [product-specific prohibition]

## A.4 Progress Convention

<!--
How the agent records what it did. Keep this aligned with
templates/PROGRESS.md.template and templates/BUGS.md.template.
-->

- Update `PROGRESS.md` at every session end: stage, what shipped, which DoD criteria are met, what is next.
- Log every non-trivial bug in `BUGS.md` with reproduction, root cause, and fix.
- Cite the PRD section number that motivates each significant implementation decision, in the commit message.

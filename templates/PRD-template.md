<!--
PRD TEMPLATE — the specification of record.

HOW TO USE THIS FILE
Produced by prompts/01-prd-interrogation.md. Do not fill it in by hand from a
blank page: run the interrogation first, then use these headings to organise
what came back. You cannot enumerate your own assumptions, which is the whole
reason the questioning phase exists.

The guidance in HTML comments is for you. It survives into the filled document
harmlessly and can be stripped before sharing, but leave it in while the agent
is building — it costs nothing and it tells a future session what each section
was supposed to contain.

SECTION ORDER MATTERS. Each section constrains the next, and the document is
read top-down. Do not reorder.

Delete a scaffold table only when the section genuinely does not apply to your
product, and say so in one line rather than leaving the heading empty. An empty
heading reads as "nothing to say here", which is indistinguishable from
"we forgot".
-->

# PRD — [Working Title]

| Field | Value |
|---|---|
| Version | 0.1 |
| Date | [YYYY-MM-DD] |
| Author | |
| Status | Draft \| In review \| Locked |
| Working title | |
| Companion doc | [PIPELINE.md](PIPELINE.md) |

<!--
FRONT MATTER: version, date, author, status, working title, companion doc
pointer. The companion pointer is not decoration — the agent is told to read
both documents, and this is how it finds the second one.

STATUS: mark it Locked before arming a night run. A PRD still in Draft is a
PRD you are still changing, and the agent will build against whatever it read
at session start.
-->

---

## 1. Document Purpose

<!--
MUST ANSWER: Who reads this, and what they can do afterwards.
FAILURE MODE IF THIN: Nobody knows if it's a pitch or a spec.

Name the readers explicitly, and include the coding agent as one of them. State
the standard this document is held to: detailed enough that an engineer could
build from it without asking you anything.
-->

---

## 2. Product Summary

<!--
MUST ANSWER: The whole product in 4-6 paragraphs, ending in a one-line promise.
FAILURE MODE IF THIN: Readers form different mental models and never discover it.

The one-line promise is the test. If you cannot write it, the product is not yet
one thing. Everyone who reads this document should be able to recite that line
back identically — that is what stops two people building toward two products.
-->

**The promise:** [one line]

---

## 3. Goals, Non-Goals, and Success Metrics

<!--
MUST ANSWER: Numbered goals with rationale; aggressively stated non-goals;
targets with actual numbers.
FAILURE MODE IF THIN: Scope creeps in month four with no basis to refuse it.

"Aggressively stated" is the operative word for non-goals. A non-goal you are
slightly embarrassed to have written down is the right register — it is the one
that will actually hold when someone proposes the feature in month four.

Success metrics need real numbers. "Fast" is not a target; "p95 under 200ms on
the reference dataset" is. A metric without a number cannot be failed, and a
metric that cannot be failed is decoration.
-->

### 3.1 Product Goals

| # | Goal | Rationale |
|---|---|---|
| G1 | | |
| G2 | | |
| G3 | | |

### 3.2 Non-Goals

| # | Non-goal | Why we are refusing this |
|---|---|---|
| NG1 | | |
| NG2 | | |

### 3.3 Success Metrics

| # | Metric | Target (with a number) | How it is measured |
|---|---|---|---|
| M1 | | | |
| M2 | | | |

---

## 4. Target Users

<!--
MUST ANSWER: 2-4 personas, each ending in a *design implication* line.
FAILURE MODE IF THIN: Personas become decoration nobody consults.

The design implication line is what makes a persona load-bearing. Without it a
persona is a short story. With it, it is a constraint you can check a decision
against. Write it as "Therefore: ..." and make it specific enough to lose an
argument.

Two to four. More than four and none of them constrains anything.
-->

### 4.1 [Persona name]

- **Who:**
- **Context of use:**
- **What they are trying to do:**
- **What would make them abandon it:**
- **Therefore:** [the design implication]

### 4.2 [Persona name]

- **Who:**
- **Context of use:**
- **What they are trying to do:**
- **What would make them abandon it:**
- **Therefore:** [the design implication]

---

## 5. Design Principles

<!--
MUST ANSWER: 5-6 rules that pre-resolve future arguments.
FAILURE MODE IF THIN: Every small decision gets re-litigated from scratch.

The test of a principle is that it can lose. "Be delightful" resolves nothing
because nothing contradicts it. "Speed over configurability" resolves an
argument before it happens, because it tells you which side loses.

State each as a preference between two goods, not as a virtue.
-->

| # | Principle | What it rules out |
|---|---|---|
| P1 | | |
| P2 | | |
| P3 | | |
| P4 | | |
| P5 | | |

---

## 6. Core Loop

<!--
MUST ANSWER: The repeating cycle, diagrammed, with a target session shape.
FAILURE MODE IF THIN: Features accumulate with no place in the loop.

Diagram it, even crudely — a fenced ASCII cycle is enough. The loop is the thing
every later feature has to justify itself against: if a proposed feature has no
position in this cycle, that is the argument against building it.

Target session shape: how long a session lasts, how many loop iterations it
contains, and what makes someone stop. "Until they get bored" is not a shape.
-->

```
[ step 1 ] -> [ step 2 ] -> [ step 3 ]
     ^                           |
     +---------------------------+
```

**Target session shape:** [duration, iterations per session, what ends a session]

---

## 7. [Domain Model — part 1]

<!--
SECTIONS 7-9 ARE YOURS.

MUST ANSWER: The 2-4 sections unique to *your* product — the world, the engine,
the content system, whatever the hard part is.
FAILURE MODE IF THIN: This is the part no template provides, and where generic
PRDs fail.

Rename these headings to the actual subjects. If your product is a simulation,
one of them is the model. If it is a marketplace, one is matching. If it is a
tool, one is the document format. The hard part of your product goes here, at
maximum detail, and it is the section the agent will re-read most often.

If you cannot think what belongs in 7-9, the interrogation was not thorough
enough. Go back to prompts/01-prd-interrogation.md rather than filling these
with restated summary.
-->

---

## 8. [Domain Model — part 2]

<!--
See the guidance under section 7. Rename this heading to its real subject, or
delete it if your product only needs two domain sections.
-->

---

## 9. [Domain Model — part 3]

<!--
See the guidance under section 7. Rename this heading to its real subject, or
delete it if your product only needs two domain sections.
-->

---

## 10. Core Mechanics

<!--
MUST ANSWER: The rules of interaction, exhaustively.
FAILURE MODE IF THIN: Engineers invent the missing rules, and they're wrong.

"Exhaustively" is not rhetorical. Every rule you leave out is a rule the agent
will invent, confidently, and it will not tell you it did. Enumerate edge cases,
failure states, and what happens on invalid input.

A useful test: hand this section alone to someone and ask them to describe what
happens in the awkward case you have in mind. If they cannot, the section is
not exhaustive yet.
-->

| # | Mechanic | Rule | Edge cases |
|---|---|---|---|
| | | | |

---

## 11. Economy / Stakes

<!--
MUST ANSWER: What's scarce, what's earned, what's lost.
FAILURE MODE IF THIN: No tension, or tension in the wrong places.

Something must be scarce or nothing matters. Name the scarce resource even if
your product is not a game — attention, time, quota, reputation, credits, and
undo-ability are all scarcities.

Say explicitly what can be *lost*. Products with no downside have no stakes,
and stakes are what makes the loop in section 6 turn.
-->

| Resource | Scarce because | How it is earned | How it is lost |
|---|---|---|---|
| | | | |

---

## 12. Progression

<!--
MUST ANSWER: How capability expands over time.
FAILURE MODE IF THIN: Everything available on day one; the user drowns.

Progression is as much about what is *withheld* as what is unlocked. Say what a
first-session user cannot see yet, and what event reveals it.

This applies to tools as much as to games: a settings panel with ninety options
on first launch is the same failure.
-->

| Stage | What the user can do | What is still hidden | What unlocks the next stage |
|---|---|---|---|
| | | | |

---

## 13. Content Systems

<!--
MUST ANSWER: Reference, teaching, help — **with volume targets**.
FAILURE MODE IF THIN: Content is discovered as a ten-month workstream in month
eight.

The volume targets are the entire point of this section. "We'll need some help
docs" hides a workstream. "40 reference entries at ~300 words, 12 tutorial
flows, 60 tooltips" is a plan you can schedule and resource.

Count everything that has to be written by a human: reference entries, tutorial
steps, error messages, empty states, onboarding copy, sample data.
-->

| Content type | Purpose | Volume target | Who writes it |
|---|---|---|---|
| | | | |

---

## 14. Interface

<!--
MUST ANSWER: Platforms, navigation, key screens, design tokens, onboarding,
accessibility.
FAILURE MODE IF THIN: Design starts from zero and drifts.

Name the platforms precisely — "desktop and mobile" hides the harness question
that wastes a stage later. Say Electron, or web, or React Native, by name, and
note it again in the tool inventory (prompts/05-tool-inventory.md), because the
UI test harness follows from this answer.

Design tokens: colour, type scale, spacing, radius. Fixing them here is what
stops the drift.
-->

### 14.1 Platforms

### 14.2 Navigation and Key Screens

### 14.3 Design Tokens

### 14.4 Onboarding

### 14.5 Accessibility

---

## 15. Technical Architecture

<!--
MUST ANSWER: Stack **with reasons**, where logic runs, data model, performance
budgets.
FAILURE MODE IF THIN: Architecture decided by whoever writes code first.

"With reasons" is load-bearing. A stack list without rationale gets silently
substituted the first time something is inconvenient. The reason is what makes
the choice defensible in session six.

Performance budgets belong here as numbers, and they should match the metrics
in section 3.3. A budget is also what makes the feasibility spike testable —
see reference/feasibility-spikes.md.
-->

### 15.1 Stack

| Layer | Choice | Reason |
|---|---|---|
| | | |

### 15.2 Where Logic Runs

### 15.3 Data Model

### 15.4 Performance Budgets

| Operation | Budget | Measured under what load |
|---|---|---|
| | | |

---

## 16. Non-Functional Requirements

<!--
MUST ANSWER: Offline, privacy, legal positioning, data ownership, localisation.
FAILURE MODE IF THIN: Retrofitted, expensively, under deadline.

Each of these is cheap to design in and expensive to add. Answer each one even
if the answer is "not applicable, because ..." — a recorded decision not to
support offline is worth far more than silence, because silence gets rediscovered
as a question every few sessions.
-->

| Requirement | Decision | Rationale |
|---|---|---|
| Offline behaviour | | |
| Privacy / data handling | | |
| Legal positioning | | |
| Data ownership and export | | |
| Localisation | | |

---

## 17. Risks

<!--
MUST ANSWER: Severity-rated, each with a mitigation.
FAILURE MODE IF THIN: Known risks surprise everyone anyway.

A risk without a mitigation is a worry. Rate severity honestly; the highest-rated
technical risk is usually your feasibility spike, and if it is not, check whether
you have identified the spike correctly.
-->

| # | Risk | Severity | Likelihood | Mitigation |
|---|---|---|---|---|
| R1 | | High \| Med \| Low | | |
| R2 | | | | |

---

## 18. Open Questions

<!--
MUST ANSWER: What you genuinely haven't decided.
FAILURE MODE IF THIN: Fake certainty; the agent invents answers silently.

*** ONE OF THE THREE SECTIONS THAT CARRY DISPROPORTIONATE WEIGHT. ***

This is the honesty valve. Anything NOT listed here is treated as settled by the
agent — so an empty section does not mean "everything is decided", it means
"resolve everything yourself, silently". An empty section is a lie with
consequences.

Being unable to fill this in is a warning sign, not a milestone. After a
thorough interrogation there are always leftovers.

Each row needs an owner and a deadline, or it is not a question, it is a shrug.
-->

| # | Question | Why it is still open | Who decides | By when |
|---|---|---|---|---|
| Q1 | | | | |

---

## 19. Phasing

<!--
MUST ANSWER: Ordered phases with **exit gates**.
FAILURE MODE IF THIN: The agent builds the visible thing first.

*** ONE OF THE THREE SECTIONS THAT CARRY DISPROPORTIONATE WEIGHT. ***

This is the only structure preventing work from being built on a foundation that
does not hold. The agent will build the visible thing first — UI is legible
progress, a data layer is not — and phasing with real gates is what fights that.

EVERY GATE MUST BE TESTABLE, NOT A JUDGEMENT CALL. "The engine works" always
passes. "The fidelity suite is green on the reference dataset" cannot be
fudged at 3am.

This section is the input to the pipeline doc's Appendix A. Keep the two
consistent; where they disagree, the pipeline wins on ordering and this wins
on scope.
-->

| Phase | What ships | Exit gate (testable) | Depends on |
|---|---|---|---|
| 0 | | | — |
| 1 | | | |
| 2 | | | |

---

## 20. Decision Log

<!--
MUST ANSWER: Every locked decision as a one-line table.
FAILURE MODE IF THIN: Decisions quietly reverse across sessions.

*** ONE OF THE THREE SECTIONS THAT CARRY DISPROPORTIONATE WEIGHT. ***

The single most-referenced artifact during the build. Everything else in this
PRD is prose the agent must interpret; the log is unambiguous, and the agent
greps it when uncertain.

Make it exhaustive and keep it to one line per decision. Include the decisions
you delegated — anything the model decided on your behalf during the
interrogation gets a row here, marked as such, because a delegated decision you
never noticed is exactly the one that surprises you later.

Append, never rewrite. If a decision reverses, add a new row that supersedes the
old one and say so. The history is the value.
-->

| # | Decision | Rationale | Decided by | Date |
|---|---|---|---|---|
| D1 | | | You \| Delegated | |
| D2 | | | | |

---

<!--
=============================================================================
OPTIONAL SECTIONS — include only if they apply. Two additions worth making.
=============================================================================
-->

## A. Domain Fidelity *(optional)*

<!--
OPTIONAL. Include this if your app simulates, models, or reproduces something
real — a market, a physical system, a legal process.

You need a section defining what "accurate" means IN TESTABLE TERMS. Not "the
simulation should feel realistic" but the specific statistical or behavioural
properties that must hold, with tolerances.

If your product has one, THIS BECOMES THE MOST VALUABLE DOCUMENT IN THE BUILD:
it is what turns a subjective standard into a suite that can fail. It is also
what makes "treat any foundational-fidelity failure as P0" a meaningful
instruction rather than a slogan.
-->

| # | Property that must hold | How it is tested | Tolerance |
|---|---|---|---|
| F1 | | | |

---

## B. Kill Criteria *(optional)*

<!--
OPTIONAL but strongly recommended. The thresholds at which you would stop.

Written BEFORE you are emotionally invested, which is the only time they can be
written honestly. Once six weeks of work exists, every threshold becomes
negotiable and the exercise is worthless.

Pair this with the feasibility spike's stop condition — see
reference/feasibility-spikes.md. The spike's halt instruction and these criteria
are the same discipline applied at two scales.
-->

| # | If this is true | Then we stop | Measured when |
|---|---|---|---|
| K1 | | | |

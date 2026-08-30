# Pipeline Adaptation

**When:** Step 2, immediately after the PRD is written.
**Where:** Claude Desktop, the **same conversation** that produced the PRD. It needs the accumulated context — a fresh conversation will produce a generic pipeline that could apply to any app, which is exactly what you don't want.
**Produces:** The pipeline doc — a markdown companion to the PRD, cross-referencing PRD section numbers throughout, ending in Appendix A: the execution appendix the agent actually builds against.

Attach [`reference/aaa-pipeline.md`](../reference/aaa-pipeline.md) before sending.

---

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

---

## Notes

**The two requirements that matter most** are 1 and 6. Requirement 1 forces the hardest technical risk to the front of the schedule, where it is cheap to fail. Requirement 6 is the only part of the document the agent actually executes against — everything above it is context that makes the appendix correct.

---

## Why two documents and not one

A PRD describes a destination. It is written in the present tense of a finished product: the app *has* these screens, the engine *behaves* this way. That is the correct register for a specification, and it is useless as a work order — nothing in it says what to build first, or what "first" even means.

A pipeline doc describes a route. Stages, dependencies, exit gates, and the specific tests that prove a stage is complete. It is written in the imperative and it assumes the destination is already settled.

Collapsing them into one document produces a file that does neither job well, because the two are read at different moments and by different processes. The agent reads the PRD when it needs to know *what a thing is*, and the pipeline when it needs to know *whether it is allowed to proceed*. Keeping them separate also means the PRD stays stable while the pipeline is annotated with progress, which matters over a multi-session build.

---

## On requirement 1 — the feasibility spike

Every product has one technical bet that, if it fails, kills the thesis. Requirement 1 asks the model to name yours and schedule it first, with pass criteria that are numeric rather than a judgement call.

[`reference/feasibility-spikes.md`](../reference/feasibility-spikes.md) covers how to identify it and how to write the stop condition so it overrides schedule pressure.

---

## On requirement 6 — Appendix A

**Appendix A is the operative document.** Everything above it exists to make it correct. Check that what comes back contains:

- Repository structure, so the agent doesn't invent one
- Numbered stages in strict dependency order
- A **testable** definition of done per stage — "the suite is green", not "the engine works"
- Explicit **stop conditions** on any blocking stage, phrased to override schedule pressure
- **Standing rules**: the four to six things the agent must never do, stated as prohibitions rather than preferences

[`templates/PIPELINE-template.md`](../templates/PIPELINE-template.md) carries the full section-by-section guidance, with the most detail on Appendix A.

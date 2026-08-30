# Instruction Block

**When:** Step 3, after both documents exist.
**Where:** Claude Desktop, the same conversation that produced the PRD and the pipeline doc. It has the context to write this accurately, and you have the context to check it.
**Produces:** ⚠️ **This is a meta-prompt.** It does not instruct Claude Code. It asks Claude Desktop to *generate* a block of text — one dense paragraph addressed to the agent — which you then paste into the final Claude Code prompt as its **Instructions** section (§3.1). What comes back is the deliverable; the prompt below is only how you ask for it.

---

```
Write the instruction block for the Claude Code prompt.
It should tell the agent how to read and use both documents,
where to start, how to know when to advance, and what to
never do. One paragraph, dense, addressed to the agent.
```

---

## Notes

That last clause matters. Under a night command the agent cannot ask, so it needs an explicit protocol for what to do with a question it can't ask: **log it, choose conservatively, keep going.**

### Example of what comes back

> **The block below is EXAMPLE OUTPUT, not the prompt.** Do not paste it into Claude Desktop — paste the fenced block above. This is here so you know what a good answer looks like, and so you can tell when the one you got back is thin. Your own version will name your product's stages, documents, and section numbers.

> Read the PRD fully first, then the pipeline doc. The PRD is the specification of what to build; the pipeline doc is the process and the build order. Begin at Appendix A, Stage 0, and do not advance to the next stage until that stage's definition of done is demonstrably met — not asserted, demonstrated. Stage 1 is blocking: if its pass criteria cannot be met after two remediation attempts, stop and write the failure to `report.md` rather than proceeding. Follow the standing rules in Appendix A on every commit. When the two documents conflict, the PRD's decision log wins on *what*, the pipeline wins on *when*. Cite the PRD section number that motivates each significant implementation decision, in the commit message. Anything not settled by either document and not listed in PRD §18 should be treated as settled — if you find something genuinely ambiguous that neither document covers, record it in `brief.md` under OPEN and proceed with the most conservative option.

### What to check before you paste it

- Does it say *demonstrated*, not asserted, for the stage gate?
- Does it name the blocking stage and give it a bounded remediation count?
- Does it resolve document conflicts explicitly — which one wins on *what*, which on *when*?
- **Does it give the log-and-proceed protocol for unaskable questions?** This is the clause that keeps a night run honest. Without it the agent guesses silently, and you never learn where.

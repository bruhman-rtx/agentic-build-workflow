# The Clarifying-Question Round

**When:** Step 6. The final line of the assembled prompt, and the last checkpoint before silence.
**Where:** Claude Code, as the closing component of the prompt — *after* the two documents, the night command, the goal, the instruction block, the verification paragraph, and the tool inventory.
**Produces:** Questions from the agent, which you answer before saying go. Not a generated block — unlike prompts 03, 04, and 05, this text is pasted as-is and is read by the agent that will do the building.

---

```
Before doing any work: ask me as many clarifying questions as
you need. Anything ambiguous in either document, anything
about my environment, anything you would otherwise have to
guess at. Ask everything now — once the night command is
armed you cannot ask, and an unresolved ambiguity becomes a
guess you build on for eight hours. Do not start until I
say go.
```

---

## Notes

Take this round seriously. It is the highest-value ten minutes in the entire process: the agent has read both documents in full and can see the gaps between them, which is a vantage point you don't have.

---

## Why this exists at all

**The night commands forbid the agent from asking anything.** No `AskUserQuestion`, no `ExitPlanMode` — it works in silence until it finishes or you stop it.

Every ambiguity that would ordinarily surface as a mid-build question therefore has to be surfaced and closed *before* the run is armed, because once it is armed the agent will resolve ambiguity by inventing an answer and building on it. It will do this confidently and without flagging it, which is correct behaviour for a tool that must keep moving and catastrophic under a night command where nobody is watching.

This round is the last chance to catch what the two documents missed.

---

## How to run it

**Answer every question.** A question you skip becomes a guess you sleep through.

**Answer them in the documents, not just in chat.** An answer that lives only in the conversation evaporates when the context resets — which on a multi-session build is a certainty, not a risk. Every consequential answer should end up in the PRD's decision log (§20), or in the pipeline doc, or in `CLAUDE.md`. See [`templates/CLAUDE.md.template`](../templates/CLAUDE.md.template).

**Watch for the questions you can't answer.** Those are genuinely open, and they belong in PRD §18 — not silently resolved. An open-questions section that is empty because you closed every question in chat is the same lie as one that is empty because you never asked.

**Do not say go until it's clean.** The final line of the prompt says *do not start until I say go*, and that word is the arming switch. Before you type it, walk [`templates/preflight-checklist.md`](../templates/preflight-checklist.md) — the last item on it is that you have actually said go.

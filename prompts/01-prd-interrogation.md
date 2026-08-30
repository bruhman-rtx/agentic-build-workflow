# PRD Interrogation

**When:** Step 1. Before any document exists — this is the first thing you do.
**Where:** Claude Desktop, a **fresh** conversation. Nothing else in context; the interrogation works better when the model isn't anchored on prior threads.
**Produces:** 25–40 clarifying questions asked in batches of three, then the PRD itself as a markdown file — the specification of record, ending in a decision log.

Replace the bracketed paragraph with your own before sending. Everything else goes in as written.

---

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

---

## Notes

**Why each rule earns its place.**

*Three per batch* — a thirty-question dump gets abandoned halfway through. Batches keep it conversational and let later questions adapt to earlier answers.

*Decide-for-me permission* — you will hit choices you have no opinion on. Without explicit permission to proceed, the conversation stalls on a decision that doesn't matter, and you start answering arbitrarily just to move on. Arbitrary answers are worse than delegated ones.

*Flag conflicts* — a polite questioner absorbs contradictions silently. You find them in month four. Requiring the flag in-turn converts a future problem into a present one, which is always the cheaper trade.

*Decision log* — this table is the single most-referenced artifact during the build. Everything else in the PRD is prose the agent must interpret; the log is unambiguous.

---

## Why this phase is the real work

The instinct is to write the PRD yourself and hand it over. This produces a worse document, for a reason that has nothing to do with writing ability: **you cannot enumerate your own assumptions.** The things you haven't thought about are, by definition, invisible to you. A structured interrogation surfaces them because the questioner has no stake in your mental model and asks about the boring adjacent decisions you skipped.

Thirty questions is roughly the point at which a consumer app of moderate complexity stops yielding new information. Fewer than twenty and you have a sketch. More than forty and you are usually re-asking things in different words.

---

## What to do with the output

Fill it against [`templates/PRD-template.md`](../templates/PRD-template.md), which carries the full section-by-section guidance. Pay particular attention to the three sections that carry disproportionate weight in an agentic build:

- **The decision log (§20)** — the lookup table when the agent is uncertain. Exhaustive, one line per decision.
- **Open questions (§18)** — the honesty valve. Anything not listed here is treated as settled, so an empty section actively misleads.
- **Phasing with exit gates (§19)** — the only structure preventing work from being built on a foundation that doesn't hold. Every gate must be *testable*, not a judgement call.

Then go straight to [`02-pipeline-adaptation.md`](02-pipeline-adaptation.md) **in the same conversation**.

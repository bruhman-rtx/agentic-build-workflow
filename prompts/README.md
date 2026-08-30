# Prompts

Six prompts, run in order. Together they take you from a paragraph describing an app to an armed Claude Code run with nothing left to guess at.

Each file holds one prompt in a fenced block, ready to copy-paste, plus the reasoning behind it. Every prompt here is extracted verbatim from [`docs/workflow.md`](../docs/workflow.md).

---

## In execution order

| # | Prompt | When | Where | Produces |
|---|---|---|---|---|
| 01 | [PRD Interrogation](01-prd-interrogation.md) | First. Before any document exists. | Claude Desktop, **fresh** conversation | 25–40 questions in batches of three, then the PRD, ending in a decision log |
| 02 | [Pipeline Adaptation](02-pipeline-adaptation.md) | Straight after the PRD | Claude Desktop, **same** conversation | The pipeline doc, ending in Appendix A — the execution appendix |
| 03 | [Instruction Block](03-instruction-block.md) | Once both documents exist | Claude Desktop, same conversation | ⚠️ **Meta-prompt** → the *Instructions* paragraph of the Claude Code prompt |
| 04 | [Verification and Bug Fixing](04-verification-and-bugfixing.md) | After 03 | Claude Desktop, same conversation | ⚠️ **Meta-prompt** → the *Verification & bug fixing* paragraph |
| 05 | [Tool Inventory](05-tool-inventory.md) | After 04 | Claude Desktop, same conversation | ⚠️ **Meta-prompt** → the *Tool inventory* paragraph |
| 06 | [Clarifying Round](06-clarifying-round.md) | Last line of the assembled prompt | **Claude Code** | Questions from the agent, which you answer before saying go |

---

## The meta-prompt distinction

**Prompts 03, 04, and 05 are meta-prompts, and this is the easiest thing here to get wrong.**

They are not instructions to the coding agent. They are requests to **Claude Desktop** to *write* a block of text for you. What comes back from Claude Desktop is what you paste into the final Claude Code prompt — the prompt file itself never goes near Claude Code.

Files 03 and 04 include a worked example of what should come back, under a heading that labels it as example output. **Do not paste those examples.** They describe a particular product and a particular toolchain; yours will differ in every specific. They are there so you can recognise a thin answer when you get one.

Prompts 01, 02, and 06 are ordinary prompts: 01 and 02 are pasted into Claude Desktop as written, and 06 is pasted into Claude Code as written.

Why generate 03–05 rather than write them yourself? Because the same Claude Desktop instance has just written both documents and has the context to describe them accurately — and you have the context to check what it says. Each file ends with a *what to check before you paste it* list for exactly that.

---

## Where the output goes

Prompts 01 and 02 produce documents. Prompts 03, 04, and 05 produce paragraphs. All of it assembles into a single Claude Code prompt with seven parts in a fixed order:

```
1. The two files          PRD + pipeline doc, attached
2. Night command          /nightmin or /nightmax
3. /goal                  One falsifiable sentence
4. Instructions           ← from prompt 03
5. Verification & bug fixing  ← from prompt 04
6. Tool inventory         ← from prompt 05
7. Clarifying questions   ← prompt 06, the last human checkpoint
```

Parts 2 and 3 come from [`commands/`](../commands/) rather than from a prompt.

Before you arm the run, walk [`templates/preflight-checklist.md`](../templates/preflight-checklist.md).

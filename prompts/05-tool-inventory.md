# Tool Inventory

**When:** Step 5, after the verification paragraph.
**Where:** Claude Desktop, the same conversation. Replace the bracketed list with the tools you actually have before sending.
**Produces:** ⚠️ **This is a meta-prompt.** It does not instruct Claude Code. It asks Claude Desktop to *generate* the **Tool inventory** paragraph of the final Claude Code prompt (§3.1). What comes back is what you paste; the prompt below is only how you ask for it.

---

```
Based on the tools I have available — [list them] — write the
tool inventory paragraph for the Claude Code prompt. Say what
each is for, when to reach for it, and any tool that looks
applicable but isn't.
```

---

## Notes

The last clause is the valuable one. **Explicitly naming what a tool cannot do prevents a stage of wasted work**, and the agent will otherwise assume capability from a plausible name.

Cover: shell, repo operations, containerisation, database, emulator, UI harnesses, and any knowledge base. Close with a triage rule — *prefer the narrowest tool that answers the question; read a log before booting an emulator, run a unit test before a full UI flow* — because an unattended agent that reaches for the heaviest tool first burns the night on setup.

### On the absence of an example here

Unlike [`03-instruction-block.md`](03-instruction-block.md) and [`04-verification-and-bugfixing.md`](04-verification-and-bugfixing.md), the source material gives no worked example for this paragraph, and none is invented here. That is the right outcome: a tool inventory is entirely specific to the machine the run happens on, so a sample would be a template you'd have to unlearn rather than a model you could follow.

Use the checklist below instead.

### What to check before you paste it

- Is every tool on your list actually covered, with **what it is for** and **when to reach for it**?
- Does it name at least one tool that **looks applicable but isn't**? If it names none, push back — there is almost always one, and that omission is the expensive kind. (Browser automation against React Native is the canonical case; see [`docs/failure-modes.md`](../docs/failure-modes.md).)
- Does it close with the triage rule — narrowest tool first?
- Does it cover the whole span: shell, repo operations, containerisation, database, emulator, UI harnesses, knowledge base?
- Are there tools you have that you *don't* want used unattended? Say so here; this paragraph is the only place that instruction lands.

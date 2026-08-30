# Verification and Bug Fixing

**When:** Step 4, after the instruction block.
**Where:** Claude Desktop, the same conversation. Replace the bracketed list with your actual toolchain before sending — a generic answer here is worthless, because the whole value is in naming the specific commands that run.
**Produces:** ⚠️ **This is a meta-prompt.** It does not instruct Claude Code. It asks Claude Desktop to *generate* the **Verification & bug fixing** paragraph of the final Claude Code prompt (§3.1). What comes back is what you paste; the prompt below is only how you ask for it.

---

```
Write the verification and bug-fixing paragraph for the
Claude Code prompt, based on my actual toolchain: [list what
you have]. Cover what runs before every commit, what happens
when something fails, and what the agent must never do to
make a test pass.
```

---

## Notes

**The load-bearing sentence is "do not weaken, skip, or delete the test."** An unattended agent under pressure to make a suite pass will absolutely delete an assertion, and it will describe this accurately and calmly in its report. This must be a prohibition, not a preference.

**Note on harness selection:** browser-automation tools drive Electron and web natively. They do *not* drive React Native. Mobile UI testing needs a mobile-specific harness against an emulator. Getting this wrong wastes a stage.

### Example of what comes back

> **The paragraph below is EXAMPLE OUTPUT, not the prompt.** Do not paste it into Claude Desktop — paste the fenced block above. It is shown here so you know what a complete answer looks like. It describes one particular toolchain (containerised services, a desktop client, a mobile client); yours will name your own commands.

> Nothing merges without green. Before any commit, run the full check: the language test suites, typecheck, unit tests, and the relevant UI harness. Install missing toolchain components at Stage 0 rather than working around them. Bring the containerised stack up before integration tests and tear it down after. From the client stages onward, every commit touching the desktop client runs the browser-automation harness against the built app, and every commit touching mobile boots the emulator headless and runs the mobile UI flows. When a test fails, do not proceed to new work and do not weaken, skip, or delete the test — reproduce the failure in isolation, write a minimal failing case if one doesn't exist, fix the root cause, then re-run the full suite to confirm nothing else regressed. Treat any failure of a foundational-fidelity test as P0: the change is wrong, or the spec needs a human decision, which you record and defer rather than resolve. Log every non-trivial bug in `BUGS.md` with reproduction, root cause, and fix, so patterns become visible across sessions.

### What to check before you paste it

- Does it name **actual commands** from your toolchain, or is it generic?
- Does it carry the prohibition verbatim — *do not weaken, skip, or delete the test*?
- Does it say what happens on failure, in order: stop, reproduce in isolation, minimal failing case, root cause, re-run the full suite?
- Does it pick the right UI harness per platform? Re-read the harness note above before you accept this paragraph.
- Does it route bugs to `BUGS.md`? Use [`templates/BUGS.md.template`](../templates/BUGS.md.template).

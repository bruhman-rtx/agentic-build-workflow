# Pre-flight Checklist

Run before arming any night command.

Once the run is armed the agent cannot ask you anything, so every item here is a question that has to be closed now or guessed at later. Work down the list in order — the last item is the arming switch.

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

---

## Notes on the items that get skipped

**"Populated decision log and an honest open-questions section."** Both halves matter, and the second is the one that gets faked. An empty open-questions section does not mean everything is decided — it means the agent will resolve every gap silently. See [`templates/PRD-template.md`](PRD-template.md) §18.

**"A testable DoD per stage."** The test: could a session at 3am, with nobody watching and an incentive to advance, honestly claim this stage was done when it was not? If yes, the gate is not testable. Rewrite it as a command that exits zero.

**"`~/.claude/night/brief.md` populated (not just the watchdog script)."** This is the pre-flight check that catches the most expensive failure. A directory holding only `night-watchdog.ps1` means the first restart resumes blind. Fill it from [`templates/brief.md.template`](brief.md.template) and make it self-sufficient — the restarted session has no memory of the conversation that armed the run.

**"Watchdog launched detached; `-MaxHours` set appropriately."** Detached via `Start-Process`, or it dies with the session and you are left with only the cron nudge — which is in-memory and dies with the session too. **Either layer alone is insufficient.** See [`commands/README.md`](../commands/README.md).

**"`STOP` file path known and reachable."** `~/.claude/night/STOP`. Know it before you need it, because the moment you need it is the moment you do not want to be reading a script to find out.

**"Clarifying-question round completed and every question answered."** Not skimmed. The agent has read both documents in full and can see the gaps between them, which is a vantage point you do not have. See [`prompts/06-clarifying-round.md`](../prompts/06-clarifying-round.md).

**"You have actually said go."** It is on the list because it has been forgotten. The final line of the assembled prompt says *do not start until I say go* — until you type it, nothing is running.

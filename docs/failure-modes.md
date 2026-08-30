# Failure Modes

A catalogue of the specific ways an agentic build goes wrong, and the instruction in this method that exists to prevent each one.

The point of the catalogue is that a failure mode you can name is a failure mode you can write a prohibition against — and a prohibition in the PRD, the pipeline doc, or the assembled prompt is the only thing standing between an unattended agent and eight hours of confident, well-tested, wrong.

**The Source column** cites [`docs/workflow.md`](workflow.md). That document reuses section numbers across its parts, so citations are given as *part + section*: `Part 1 §1.2` is the PRD skeleton, `Section 1 §1.2` is a different section entirely.

---

## 1. Failures of the documents

These happen before the run is armed. They are cheap to fix here and expensive to fix anywhere else.

| Failure mode | What it looks like | The instruction that prevents it | Source |
|---|---|---|---|
| Empty open-questions section read as "everything is settled" | PRD §18 is blank or perfunctory. The agent treats every unlisted item as decided and builds on invented answers without flagging one. | Anything absent from the open-questions list is treated as settled, so an empty section is a lie with consequences. Populate it honestly, or accept that the agent will close those gaps itself. | Part 1 §1.2, skeleton row 18 |
| Decisions quietly reverse across sessions | Session four re-litigates a choice made in session one, in the opposite direction, and nothing in the repo notices. | Maintain an exhaustive decision log (PRD §20), one line per locked decision. It is the lookup table the agent greps when uncertain. | Part 1 §1.2, skeleton row 20 |
| Exit gate is a judgement call, not a test | "The engine works" as a stage gate. Nobody can say whether it passed, so it always passes. | Every phase needs a gate that is *testable*. "The suite is green", not "the engine works". | Part 1 §1.2; Part 2 §2.2 |
| Scope creeps with no basis to refuse it | Month four, a feature arrives that nobody can argue against, because nothing was ever written down as out of scope. | State non-goals aggressively, and give success metrics actual numbers. | Part 1 §1.2, skeleton row 3 |
| Content discovered as a ten-month workstream in month eight | The system is built; the reference, teaching, and help content it needs turns out to be the actual project. | Content systems get **volume targets** in the PRD, not just a description. | Part 1 §1.2, skeleton row 13 |
| Interrogation abandoned halfway | A thirty-question dump arrives in one message. It gets skimmed, half-answered, and the resulting PRD is a sketch. | Three questions per batch. Batches stay conversational and let later questions adapt to earlier answers. | Part 1 §1.1 |
| Conversation stalls on a decision that doesn't matter | You have no opinion on a choice, so you answer arbitrarily just to move on. Arbitrary answers are worse than delegated ones. | Grant explicit decide-for-me permission: on "your call", the model decides, states what it chose and why, and moves on. | Part 1 §1.1 |
| Conflicts absorbed silently | A polite questioner takes two contradictory answers and reconciles them quietly. You find the contradiction in month four. | Require conflicts and hidden costs to be flagged *in the turn they arise*, converting a future problem into a present one. | Part 1 §1.1 |
| Generic pipeline that could apply to any app | The pipeline doc is a summary of the reference model with the product's name substituted in. It gates nothing. | Run the pipeline prompt in the **same conversation** that produced the PRD. It needs the accumulated context. | Part 2 §2.1 |
| The killer technical risk is discovered late | The one bet the thesis rests on gets tested in month six, on top of everything already built on it. | Identify the feasibility spike and make it a blocking Stage 1 with an explicit stop condition and testable pass criteria. See [`reference/feasibility-spikes.md`](../reference/feasibility-spikes.md). | Part 2 §2.1, requirement 1 |
| Agent invents a repo structure | Directory layout emerges from whatever the agent typed first, and is never coherent again. | Appendix A specifies repository structure, so the agent does not invent one. | Part 2 §2.2 |
| Required-input list does not separate blocking from scoped | The document says "if any required input is missing, halt". One input out of many is absent — and it gated a single file. Read literally, the whole run dies over it; read loosely, the agent invents a halt policy of its own and does not log doing so. | Mark every required input **blocking** or **scoped**. For a scoped input, say what a partial halt must produce: build the rest, skip that unit, and make the absence visible **in the artifact**, not only in the report. An undifferentiated halt rule forces the agent to choose between destroying the run and improvising. | [Postmortem 2026-08-30](postmortems/2026-08-30-agentic-build-workflow.md) §3.1 |
| Build destination unnamed, so the sources get published | The document says what to build and never says **where**. The obvious reading is "here" — and the working directory is where the private source material already sits. It ends up committed into the repo being prepared for publication, and the result looks correct. | Name the output directory absolutely, and state what must **not** end up in it. "Where" is not something an unattended agent should infer from context; the guess fails silently and, once pushed, permanently. | [Postmortem 2026-08-30](postmortems/2026-08-30-agentic-build-workflow.md) §3.2 |

---

## 2. Failures of the run

These happen at 3am with nobody watching, which is exactly why they need to be prohibitions rather than preferences.

| Failure mode | What it looks like | The instruction that prevents it | Source |
|---|---|---|---|
| Agent builds the visible thing first | UI before the matching engine, screens before the data layer. UI is legible progress; a foundation is not. Eight hours of work ends up sitting on something broken. | State the prohibition explicitly rather than hoping stage ordering implies it. Do not advance until the current stage's definition of done is *demonstrated*, not asserted. | Section 4 §4.4 |
| Agent weakens or deletes a test to make a suite pass | An assertion disappears, or a test is skipped, and the morning report describes this accurately and calmly as progress. | **Do not weaken, skip, or delete the test.** Reproduce the failure in isolation, write a minimal failing case, fix the root cause, re-run the full suite. This must be a prohibition, not a preference. | Section 3 §3.3 |
| Agent resolves ambiguity by inventing an answer, silently | Left unspecified, an agent does not stop. It picks the most conventional option, proceeds confidently, and never flags it. Correct behaviour for a tool that must keep moving; catastrophic under a night command. | Three defences in order of strength: the decision log, the open-questions section, and the clarifying-question round. Plus an explicit protocol for the question that cannot be asked — **log it under `OPEN`, choose the most conservative option, keep going.** | Section 1 §1.3; Section 3 §3.2 |
| Agent reaches for the heaviest tool first | The night is spent booting an emulator to answer a question a log file would have settled. | Close the tool inventory with a triage rule: prefer the narrowest tool that answers the question. Read a log before booting an emulator; run a unit test before a full UI flow. | Section 3 §3.4 |
| Wrong UI harness chosen | Browser automation pointed at React Native. It looks applicable from the name and cannot work. A stage is wasted discovering this. | The tool inventory must name **any tool that looks applicable but isn't**. Browser automation drives Electron and web natively; mobile UI needs a mobile-specific harness against an emulator. | Section 3 §3.3, harness note |
| Foundational-fidelity failure treated as an ordinary bug | A test that encodes what "correct" means for the domain fails, and gets patched around to keep the stage moving. | Treat any foundational-fidelity failure as P0: either the change is wrong, or the spec needs a human decision — which the agent records and defers rather than resolves. | Section 3 §3.3 |
| Bug patterns never become visible | The same class of bug is fixed four times across four sessions and nobody notices it is one bug. | Log every non-trivial bug in `BUGS.md` with reproduction, root cause, and fix, so patterns become visible across sessions. | Section 3 §3.3 |

---

## 3. Failures across sessions and restarts

The run is not one session. Anything that lives only in a session's context is already lost.

| Failure mode | What it looks like | The instruction that prevents it | Source |
|---|---|---|---|
| Session two starts blind because the prompt evaporated | The carefully assembled prompt is gone the moment context resets. On a nine-stage build spanning many sessions, this is the difference between a coherent codebase and a patchwork. | `CLAUDE.md` in the repo root, read automatically at every session start: what the two documents are, where to start, the stage-gate rule, the standing rules, the verification requirement. Under twenty lines. | Section 4 §4.1 |
| Restart resumes blind because `brief.md` was thin | The watchdog relaunches after a crash. The restarted session reads a brief that says "continue the work" and has to guess what that means. | `brief.md` is the memory across crashes. Write it specific and concrete, append to it as items complete, and pre-flight that `~/.claude/night/` holds more than just the watchdog script. | Section 2 §2.5 |
| Relying on the cron nudge alone | The 15-minute in-session loop handles a stall and dies with the session, so the first crash or usage-limit lockout ends the night silently. | Two layers, and **either alone is insufficient**. The cron nudge handles stalls; the detached watchdog is what survives crashes. Arm both. | Section 2 §2.5 |
| Session spans stages and skips the gate | One long session rolls through a stage boundary. The definition-of-done check is what the boundary is *for*, so it never happens. | One stage per session. Ending the session forces the gate. | Section 4 §4.3 |
| Reading the diff before the report | You reconstruct what happened from code, and never learn where the documents misled the agent. | Read `report.md` and `PROGRESS.md` first — that is what the agent *believes* it did. Where belief and diff diverge is exactly where the documents were ambiguous, and that divergence is the input to the next revision of the PRD. | Section 4 §4.5 |
| Arming a run with questions still open | The clarifying round is skipped or skimmed because the documents feel finished. | Take the round seriously. The agent has read both documents in full and can see the gaps between them, which is a vantage point you do not have. Do not say go until every question is answered. | Section 3 §3.5; Appendix |
| Watchdog cannot tell "no heartbeat" from "no session" | The liveness signal is missing because the watchdog is pointed at the wrong place, not because the session died. It reads absence as a stall and relaunches against a run that is perfectly healthy — immediately, and every interval after. Two agents, one repo, one brief, overwriting each other. Repointing it somewhere that *looks* alive silences the restarts and leaves the night with no crash recovery at all. | **Fail closed:** no transcript means liveness is *unknown*, so wait and log the resolved path — only a heartbeat that exists and is stale may trigger a restart. Then have the watchdog print the heartbeat it found **at arm time**, and read that line, because nothing downstream can tell whether it belongs to the run you armed. Note that synchronous relaunch does **not** cover this: it stops the watchdog stacking its own relaunches, not colliding with the original. | [Postmortem 2026-08-30](postmortems/2026-08-30-agentic-build-workflow.md) §4.3 |

---

## 4. Failures of the artifact you publish

The run succeeded and the repository is correct. These are the ways it discloses something anyway. They are last in this list and first in consequence: every other failure mode here can be fixed in the next commit, and these cannot be fixed after a push.

| Failure mode | What it looks like | The instruction that prevents it | Source |
|---|---|---|---|
| Identity travels in metadata the content scrub never reads | Every file passes the scrub. Every commit is authored under a personal address containing the exact name the scrub removed from the files. It is not a credential, so a credential halt does not fire, and every stated check reports clean. | Scope the scrub to **metadata as well as contents** — commit author and committer, tags, the licence holder. Check `git log --format='%an <%ae>'` before the first push, when a rewrite is still free. A check narrower than the property it stands in for will pass and mean nothing. | [Postmortem 2026-08-30](postmortems/2026-08-30-agentic-build-workflow.md) §3.4 |
| An auto-derived identity field resolves by querying an account | The document fills the licence holder from config with an API lookup as fallback. The primary returns the pseudonymous handle; the fallback returns a real full name, into a file nobody re-reads. The fallback is the branch that runs on an unconfigured machine. | Name the holder **outright** in the document rather than deriving it. Any field that identifies a person and has a fallback will eventually take the fallback, and identity is the one field where the wrong value cannot be withdrawn after publication. | [Postmortem 2026-08-30](postmortems/2026-08-30-agentic-build-workflow.md) §3.3 |

---

## Adding to this catalogue

**This is a living document.** Every postmortem in [`docs/postmortems/`](postmortems/) should end by adding a row here, or by strengthening a row that already exists and did not hold.

A new row needs all four columns, and the third is the one that matters: a failure mode without a preventing instruction is an observation, not a lesson. If you cannot yet write the instruction, leave the row in the postmortem until you can.

When an instruction here proves insufficient in practice, change it in place and note the revision in the postmortem that prompted it. This catalogue should describe the method as it is now, not as it has been.

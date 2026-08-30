# 2026-08-30 — agentic-build-workflow

The method applied to itself: an unattended run whose deliverable was this repository.

That makes it a weak test of some things and an unusually sharp test of others. It exercised the pre-build documents hard — a spec was the only input, and every gap in it had to be resolved without asking. It exercised the unattended-execution layer barely at all. Section 1 says which was which, because a postmortem that lets you read a partial test as a full one is worse than none.

---

## 1. What was armed

| | |
|---|---|
| **Mode** | `/nightmin`. Scope was enumerable in advance — a file tree and a definition of done — so the open-ended mandate of `/nightmax` bought nothing. |
| **The `/goal`** | **There was none.** `/goal` does not exist as a command file on this machine, so there was nothing to invoke. See §3.1. |
| **Pointed at** | `REPO-SPEC-v1.0.md` — a repository specification, **not** a `PIPELINE.md`. No stage, no exit gate. |
| **`brief.md`** | **None.** The run had no brief of its own. |
| **Watchdog** | **Not armed.** |
| **Environment** | Windows 11; PowerShell 5.1 and Git Bash side by side; `core.autocrlf=true`; `gh` authenticated. |

### What this run did not test

The night apparatus is five mechanisms. This run used one and a half:

| Mechanism | Used? | Consequence for this postmortem |
|---|---|---|
| The two pre-build documents | Substituted — one spec did the job of both | The spec's ambiguities are still document ambiguities. §3 is fully in scope. |
| The autonomy rules (never ask, never hand back) | **Yes** | Every §3 ambiguity was resolved under them. |
| `brief.md` as memory across restarts | **No** | Untested. See below. |
| The watchdog | **No** | Untested here — but §4.3 has direct evidence from a concurrent run. |
| Stage gates | **No** | A file tree is not a stage. Nothing gated anything. |

**The context reset is the interesting gap.** The run compacted mid-build and continued correctly — but it survived on the session summary, which is a harness feature, not a method feature. `brief.md` is what the method claims survives a *crash*, and a compaction is not a crash: the process never died. So the claim in [`docs/failure-modes.md`](../failure-modes.md) that a thin brief breaks a restart remains **untested by this run**, and the run's smooth continuation is not evidence for it.

---

## 2. What came back

34 tracked files, 4,459 lines of markdown, 10 commits, pushed. Repository private. One file deliberately halted rather than invented.

Ten of eleven definition-of-done items passed. The eleventh was the halted file.

**Watchdog restarts: 0.** None was armed. Zero restarts here means nothing about reliability.

**Tests weakened, skipped, or deleted: none.** There was no suite to weaken. The two verification techniques used instead were mechanical: verbatim extractions were spliced into a placeholder and `diff`-ed against source, and both installers were run against a real `~/.claude/` with SHA256 before and after.

### Where the report and the work disagreed

Three divergences, all in the same direction — the report was confident and the artifact was not ready.

**1. A definition-of-done item self-assessed as passing, and wasn't.** DoD 5 asks that every template heading carry guidance. The report said PASS. A mechanical count afterwards found **18 subsections** with no comment of their own, inheriting their parent's. Prose judgement said done; counting said not done.

**2. An installer reported "up to date" for files that differed.** Under `-WhatIf`, `install.ps1` compared two genuinely different command files and announced no action needed. `Get-FileHash` reaches through provider cmdlets that inherit `$WhatIfPreference`; both hashes came back `$null`, and `$null -eq $null`. The failure was silent and in the worst direction: a dry run whose entire purpose is to tell you what *would* change, telling you nothing would. Replaced with a direct .NET SHA256 stream read.

**3. The scrub scan passed, on the wrong surface.** The spec's scan was run over every tracked file and returned clean. It *was* clean. Meanwhile every commit to that point was authored under a personal email address containing the exact name being scrubbed out of the file contents. The check did what it was told; what it was told to look at was incomplete. See §3.4.

The pattern in all three: **the check that passed was narrower than the property it was standing in for.**

---

## 3. Where the documents were ambiguous

Four. The first three were surfaced before the run and answered; the fourth was found mid-run, and nothing in the spec would have caught it.

### 3.1 A required input was missing, and the halt rule was all-or-nothing

The spec listed four required inputs and said: if any is missing, halt. One — the `/goal` command file — did not exist anywhere on the machine. A later exhaustive search confirmed it: no `goal.md` under `~/.claude`, and nothing matching it in a profile-wide sweep.

Read literally, one absent file out of 31 meant halting the entire build and producing nothing.

**Chosen:** a partial halt. Build everything else; halt that one file; make the absence visible in three places rather than burying it in the report — a dedicated section in [`commands/README.md`](../../commands/README.md), a line in the root README's requirements, and the cross-reference in [`docs/workflow.md`](../workflow.md) repointed so it did not dangle at a file that was never written.

**Was it right?** Yes, and the spec did not authorise it. A halt rule that cannot distinguish *this input blocks everything* from *this input scopes one file* forces the agent to either destroy the run or improvise a policy. It improvised. That worked here, and it is exactly the kind of unlogged judgement call the method exists to eliminate.

**Which document should have settled it:** the spec's input list, by marking each input blocking or scoped, and saying for scoped inputs what a partial halt must produce.

### 3.2 The build destination was never named

The spec gave the `gh repo create` command and said "then clone, or initialise locally and set the remote". It never said **where on disk**.

The obvious reading — build here — was the dangerous one. The working directory already held the source documents, and the spec's own `.gitignore` section did not exclude them. Building in place would have committed the private source material into the repository being prepared for publication, and it would have looked correct.

**Chosen:** asked, before starting. Built in a sibling directory.

**Which document should have settled it:** the spec. A document that starts a build names its output directory and states what must not end up in it. "Where" is not a detail an unattended agent should be deducing from context, and the failure is silent when it guesses wrong.

### 3.3 The licence-holder fallback selected a real name

The spec set the copyright holder from `git config user.name`, falling back to `gh api user --jq .name`.

Verified empirically rather than assumed:

- primary returns the pseudonymous handle
- **fallback returns a real full name**

For a repository published under a handle, the fallback deanonymises the author automatically, in a file nobody re-reads. And the spec's own scrub rules explicitly exempt "personal identifiers **beyond the licence copyright**" — so the rules *permit* the disclosure that the fallback *selects*.

**Chosen:** asked. Used the handle.

**Which document should have settled it:** the spec — by naming the holder outright. A fallback that resolves an identity question by querying an account is a fallback that will eventually be wrong in the one direction that cannot be undone after publication.

### 3.4 Nothing covered identity metadata

Found mid-run, unprompted by any instruction.

Every commit was authored and committed under a personal email address. The scrub rules governed file contents and said nothing about author metadata. It is not a credential, so the halt condition did not fire. Every stated check passed.

But it is permanent, it becomes public the moment the repository does, and it contains the very name being removed from the files. Scrubbing a name out of 31 files while committing under an address containing it is not a partial success; it is the same disclosure by another route.

**Chosen:** rewrote the commits — unpushed at that point, so nothing had been published — to the account's GitHub noreply address, verified file contents byte-identical across the rewrite, and set the address **repo-locally only**, leaving the machine's global configuration untouched. Recorded prominently in the run report as reversible and as the operator's decision.

**3.3 and 3.4 are one failure with two faces.** The scrub rules were written about *contents*. A repository discloses identity through metadata too — commit author, committer, tag, licence holder — and nothing was pointed at that surface. §3.3 was caught because a human was asked. §3.4 was caught by accident.

---

## 4. What changed in the method

### 4.1 Rows added to the failure-mode catalogue

Five rows in [`docs/failure-modes.md`](../failure-modes.md), added in the commit that adds this file:

| Row | Section | From |
|---|---|---|
| Required-input list does not separate blocking from scoped | 1, documents | §3.1 |
| Build destination unnamed, so the sources get published | 1, documents | §3.2 |
| Watchdog cannot tell "no heartbeat" from "no session" | 3, restarts | §4.3 |
| Identity travels in metadata the content scrub never reads | **4, new** | §3.4 |
| An auto-derived identity field resolves by querying an account | **4, new** | §3.3 |

The last two needed a new section. The existing three cover the documents, the run, and the restarts — all failures of *building the thing*. Disclosure is a failure of *publishing* it, it has no earlier moment in which to be caught, and unlike every other row in the catalogue it cannot be fixed in the next commit.

They are kept as two rows rather than one because the preventing instructions differ: one widens the scrub's *scope* to metadata, the other removes a *fallback* that resolves identity by querying an account.

### 4.2 Changes to the templates and prompts

**None.** Neither was exercised: this run was pointed at a repository spec, not a PRD and a pipeline document. Recording "no changes" without that caveat would imply they were tested and held. They were not tested.

### 4.3 Changes to the watchdog — commit `6a17a72`

The one change here backed by direct evidence, and it did not come from this run. It came from a *different* run active on the same machine at the same time, which this build's own investigation stumbled into.

The staleness test defaulted to stale and was only cleared when a transcript was found. A `-Cwd` whose slug had no transcript directory therefore produced no heartbeat, ever — which the script read as a stall.

Sanitised from a real `night.log` (absolute paths reduced to `~` per this repo's own scrub rules):

```
[11:22:56] watchdog start mode=min pid=<A> cwd=~/Projects/<project> stale=20m interval=900s
[11:22:56] watching transcripts in ~/.claude/projects/<slug-of-project>
[11:22:56] session looks stalled (no transcript activity for >= 20m) - restart #1
[11:30:53] watchdog start mode=min pid=<B> cwd=~ stale=20m interval=900s
[11:30:53] watching transcripts in ~/.claude/projects/<slug-of-home>
```

**Restart #1 fires in the same second the watchdog starts.** Not after twenty minutes — immediately, on the first poll, against a session that had been working for half an hour. That transcript directory was later confirmed never to have existed.

The relaunch put a second agent on the same repository and the same brief. They overwrote each other's files. The surviving session diagnosed it from the log and wrote a single-writer lock into the top of its own brief.

Two things this falsifies:

**The concurrency claim was wrong.** Both `commands/README.md` and `docs/workflow.md` stated: *relaunches are synchronous, so they cannot pile up*. True, and irrelevant. Synchronous relaunch stops the watchdog stacking its **own** relaunches. It says nothing about a relaunch colliding with the still-alive original, which is a different writer entirely. Corrected in `commands/README.md`. `docs/workflow.md` is a verbatim extract and still carries the original wording — **flagged for v1.1 of the source document**, not silently edited here.

**The repair applied at the time made it worse.** The line at 11:30:53 is that repair: kill the watchdog, restart it with `-Cwd` pointed at the home directory. The restarts stopped. They stopped because that slug is kept permanently warm by unrelated sessions, so the heartbeat never goes stale and the watchdog **never fires at all**. That run continued for hours with no crash recovery and a clean-looking log. At the time of writing, that process is still alive, still guarding nothing.

A wrong `-Cwd` fails in two silent ways, and they are not symmetric:

| Slug contains | Watchdog sees | Result |
|---|---|---|
| No transcripts | No heartbeat | Relaunches immediately and forever. Duplicate writers. **Loud.** |
| Another session's transcripts | A permanently fresh heartbeat | Never fires. No crash recovery. **Silent.** |

The change:

- **Fail closed.** No transcript now means liveness is *unknown*, not stalled: log the resolved slug and wait. Only a transcript that exists and is older than `-StaleMinutes` triggers a restart.
- **Report the heartbeat at arm time** — which file, how many minutes old. Nothing inside the script can tell whether that file belongs to the run you armed, so this line is the only moment the silent failure is visible. Read it after arming.

Verified by extracting the patched decision block out of the shipped script and running it against four cases: directory missing, directory empty, transcript fresh, transcript ninety minutes old. Only the last relaunches.

---

## What this run is evidence for

**That the halt-rather-than-invent rule works.** A command file was missing and no plausible fabrication was written in its place, at the cost of one file out of 31. That is the rule doing its job, and the failure it prevented would have been invisible — a fabricated command reads as authoritative and matches nothing.

**That pre-build clarifying questions pay.** Three of the four ambiguities in §3 were caught by asking before arming. Each would otherwise have been resolved silently, and wrongly, by an agent forbidden to ask: the sources published, the author deanonymised, or the run destroyed over one absent file.

**Not that the night apparatus works.** No watchdog, no brief, no stage gate, no `/goal`. The only hard evidence about the watchdog collected here is evidence of a defect, and it arrived from somewhere else.

**The next run should be the opposite shape:** a small application, a real PRD and pipeline document, a real brief, the watchdog armed and its arm-time heartbeat line actually read. That tests the four mechanisms this one left untouched.

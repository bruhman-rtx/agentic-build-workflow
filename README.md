# agentic-build-workflow

A pre-build method for agentic coding: write the two documents that answer every question an overnight agent would otherwise have to answer for itself.

---

## The problem

An agentic run fails in one of two ways: it builds the wrong thing, or it builds the right thing in the wrong order on a foundation that does not hold. Both trace back to a decision the agent had to make that should have been made before the run started. **The night modes forbid asking** — no questions, no handing work back, no waiting — so every ambiguity has to die before the run is armed.

This repo is the machinery for killing them: the prompts that extract the decisions from you, the templates that hold them, and the commands and watchdog that keep an unattended run alive long enough to use them.

---

## What's here

| Directory | What it is for |
|---|---|
| [`docs/`](docs/) | The method itself — [`workflow.md`](docs/workflow.md) end to end, a [catalogue of failure modes](docs/failure-modes.md) and the instruction that prevents each, and [`postmortems/`](docs/postmortems/) where run evidence accumulates |
| [`prompts/`](prompts/) | Six prompts in execution order, verbatim and ready to paste, that take you from a product idea to a complete Claude Code instruction block |
| [`templates/`](templates/) | Fillable skeletons for the PRD, the pipeline document, the run-state files, and the night brief. Every heading carries its guidance in an HTML comment |
| [`commands/`](commands/) | The `/nightmin` and `/nightmax` slash commands, plus the shared rules and the two-layer restart-survival explanation |
| [`scripts/`](scripts/) | The watchdog that survives crashes and usage limits, and idempotent installers for both shells |
| [`reference/`](reference/) | The [full AAA product pipeline](reference/aaa-pipeline.md) you compress against, and a [guide to feasibility spikes](reference/feasibility-spikes.md) — finding the one bet that kills your thesis |
| [`examples/`](examples/) | **A worked example.** A real, complete [PRD](examples/bourse/PRD.md) and [pipeline document](examples/bourse/PIPELINE.md) from a project built with this method — verbatim, unedited, to read beside the empty templates |

---

## Quickstart

Clone to armed run. Six steps; you should not need `docs/workflow.md` to follow them.

**1. Install the commands.**

```powershell
git clone https://github.com/bruhman-rtx/agentic-build-workflow
cd agentic-build-workflow
./scripts/install.ps1          # or: sh scripts/install.sh
```

Installs the night commands to `~/.claude/commands/` and the watchdog to `~/.claude/night/`. Idempotent, and it will not overwrite an existing file without asking.

**2. Write the PRD.** In Claude Desktop, paste [`prompts/01-prd-interrogation.md`](prompts/01-prd-interrogation.md). Answer the interrogation honestly — especially the parts you would rather leave open. Fill [`templates/PRD-template.md`](templates/PRD-template.md) with what comes out. Save as `PRD.md` in your project root. If you are unsure how full an answer should be, [`examples/bourse/PRD.md`](examples/bourse/PRD.md) is a real filled one.

**3. Adapt the pipeline.** In the *same conversation*, paste [`prompts/02-pipeline-adaptation.md`](prompts/02-pipeline-adaptation.md) along with [`reference/aaa-pipeline.md`](reference/aaa-pipeline.md). The model compresses the full pipeline against your constraints. Fill [`templates/PIPELINE-template.md`](templates/PIPELINE-template.md) and save as `PIPELINE.md`. **Appendix A is the part the agent executes against** — spend your time there. To see what the compression actually produces, diff [`reference/aaa-pipeline.md`](reference/aaa-pipeline.md) against [`examples/bourse/PIPELINE.md`](examples/bourse/PIPELINE.md) — same skeleton, one project's specifics.

**4. Generate the instruction block.** Still the same conversation: [`prompts/03`](prompts/03-instruction-block.md), then [`prompts/04`](prompts/04-verification-and-bugfixing.md), then [`prompts/05`](prompts/05-tool-inventory.md). These are *meta-prompts* — they produce the blocks you assemble, they are not themselves the final prompt. [`prompts/README.md`](prompts/README.md) shows the assembly order.

**5. Close the gaps.** Paste [`prompts/06-clarifying-round.md`](prompts/06-clarifying-round.md) and answer every question it asks. Then write `CLAUDE.md` from [its template](templates/CLAUDE.md.template) — under twenty lines, read at every session start — and drop empty [`PROGRESS.md`](templates/PROGRESS.md.template) and [`BUGS.md`](templates/BUGS.md.template) in the project root.

**6. Arm the run.** Fill `~/.claude/night/brief.md` from [`templates/brief.md.template`](templates/brief.md.template) — **this is the memory across crashes**, so write it self-sufficiently. Launch the watchdog detached. Walk [`templates/preflight-checklist.md`](templates/preflight-checklist.md). Then paste the assembled prompt, set a one-sentence goal, choose `/nightmin` or `/nightmax`, and say go.

```powershell
Start-Process pwsh -ArgumentList '-File','~/.claude/night/night-watchdog.ps1',
  '-Mode','nightmin','-Cwd','C:\path\to\project','-MaxHours','18' -WindowStyle Hidden
```

Kill switch: create `~/.claude/night/STOP`.

---

## The three artifacts

**`PRD.md` — the specification of record.** Twenty sections covering what is being built, for whom, under what constraints, and what is explicitly out of scope. Three sections carry disproportionate weight in an agentic build: the **decision log** (§20), which is the lookup table the agent greps when it is uncertain; **open questions** (§18), which is the honesty valve, because anything not listed there is treated as settled; and **phasing with exit gates** (§19), which is the only thing preventing work from being built on a foundation that has not been verified.

**`PIPELINE.md` — the build order.** What gets built, in what sequence, and what test proves each stage is genuinely done. It is derived by compressing the full AAA pipeline against your real constraints — the compression is the work, and it should be deliberate and recorded. **Appendix A is the operative part**: the repository structure, the numbered stages with their definitions of done, the standing prohibitions, and the progress convention. Everything above Appendix A exists to make Appendix A correct.

**The assembled Claude Code prompt.** Not a file in this repo — you assemble it, once, from the blocks that [`prompts/03`](prompts/03-instruction-block.md), [`04`](prompts/04-verification-and-bugfixing.md) and [`05`](prompts/05-tool-inventory.md) generate, in the fixed order given in [`prompts/README.md`](prompts/README.md). It points the agent at the two documents rather than restating them, sets the standing rules, inventories the tools available, and ends with *do not start until I say go*. It is the last thing you write and the first thing the agent reads.

---

## Requirements

| | For what |
|---|---|
| **Claude Desktop** (or any long-context chat) | Running the six prompts. Steps 2–5 happen in one continuous conversation — the context accumulated is what makes the later prompts work |
| **Claude Code** | The build itself |
| **PowerShell 7+** | Only for the night modes. The watchdog is a `.ps1`; on macOS and Linux install `pwsh` first, or you have no crash recovery |
| **Your project's toolchain** | Verified present before arming, or Stage 0 instructed to install it. A night run that dies on a missing compiler has wasted the night |

Nothing here is Claude-specific in principle — the documents are the method, and the commands are one implementation of unattended execution.

**Note:** `/goal` is *not* a command — it was proposed and never built. Write the goal sentence into `brief.md` under `GOAL` instead; [`docs/workflow.md`](docs/workflow.md) §2.1 and [`commands/README.md`](commands/README.md) cover why that is the better home for it.

---

## Status

**A method under active revision, not a finished product.** It has a clear shape and the parts are internally consistent, but the parts that matter are the ones that survive contact with real overnight runs.

[`docs/postmortems/`](docs/postmortems/) is where that evidence accumulates — one file per run, covering what was armed, what came back, **where the two documents turned out to be ambiguous**, and what changed in the method as a result. That third heading is the point of the exercise. Every ambiguity a run hits is a place the pre-build work failed, and it should end up as a row in the PRD's decision log and a line in [`docs/failure-modes.md`](docs/failure-modes.md).

If you use this and it breaks somewhere, that is the interesting outcome. Open an issue or add a postmortem.

---

## Licence

MIT. See [`LICENSE`](LICENSE).

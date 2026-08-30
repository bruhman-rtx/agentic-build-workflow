# Worked Example — Bourse

A real PRD and a real pipeline document, produced by this method and used to run a real build.

| File | Lines | What it is |
|---|---|---|
| [`PRD.md`](PRD.md) | 961 | The output of [`prompts/01`](../../prompts/01-prd-interrogation.md), filled into [`templates/PRD-template.md`](../../templates/PRD-template.md) |
| [`PIPELINE.md`](PIPELINE.md) | 497 | The output of [`prompts/02`](../../prompts/02-pipeline-adaptation.md), adapting [`reference/aaa-pipeline.md`](../../reference/aaa-pipeline.md) |

**Both are verbatim and unedited.** Nothing was tidied for publication, no section was strengthened to make the method look better, and the guidance comments have been stripped the way they are in any real filled document. What you are reading is what was actually handed to the agent.

Bourse is a trading simulator: a fictional but behaviourally realistic market, an order book, a progression system, and a hard bust condition.

---

## How to read this

Open a document here beside its template and read them together. The template tells you what a section is *for*; this tells you what an answer that actually works looks like at full size.

The PRD maps one-to-one onto the twenty template sections — same numbers, same names — so any section can be looked up directly:

| Template section | What Bourse did with it |
|---|---|
| §3 Goals / Non-Goals / Success | Non-goals stated flatly enough to refuse features later |
| §4 Target Users | Four personas, each carrying a design implication |
| §7 Time Model, §8 Simulation Engine, §9 The World | The domain-heavy middle — this is where a real PRD spends its length |
| §14 Interface | Screens named specifically enough to become routes |
| §15 Technical Architecture | Stack and where logic runs, fixed before the build |
| **§18 Open Questions** | **Six genuinely unresolved questions** |
| **§19 Phasing** | Stages with exit gates |
| **§20 Decision Log** | Locked decisions as a lookup table |

---

## What to notice

**§20 is a lookup table, not prose.** Two columns, one row per settled decision — *Starting capital: scales with difficulty*, *Bust: possible, permanent, terminal for the account*. It is written to be grepped by an agent at 3am that needs one fact, not read end to end. That format is the point.

**§18 is honest, and that is what makes it work.** Six real open questions, several with the arguments on both sides written out — *"Does a busted user keep their skill tree? Keeping it respects earned knowledge; losing it makes bust properly costly."* An empty open-questions section would have told the agent every gap was settled. These six told it exactly where not to guess.

**The domain sections are long, and they should be.** §7 to §13 run for hundreds of lines on time, simulation, world, instruments, and economy. That is not padding — it is the part that stops an agent inventing market behaviour at 3am. Length lands where the ambiguity is.

**The pipeline document is the most instructive file here.** It is [`reference/aaa-pipeline.md`](../../reference/aaa-pipeline.md) adapted to one project, and it kept the same skeleton — phase map, phases 0 through 10, a lean-build section, Appendix A.

Read the two side by side and the adaptation step stops being abstract.

Note that the adapted version is **longer** than the reference (497 lines against 316). That surprises people. Compression here does not mean fewer words — it means every generic phase has been replaced by what will specifically happen, and the phases that do not apply have been consciously cut rather than skipped by accident. **The output of compression is specificity, not brevity.**

---

## Caveats

**This is a live project, not a finished artefact.** It is mid-build. Some sections are stronger than others, and the open questions are open because they have not been answered yet.

**Do not copy its answers.** Copy the shape, the specificity, and the register. Bourse's decisions are correct for Bourse.

**Not everything is here.** The project also has a `fidelity-spec.md` — its equivalent of the rater guidelines that [`prompts/02`](../../prompts/02-pipeline-adaptation.md) asks you to identify, encoding the subjective standard so it becomes a system rather than one person's judgement. It is left out of this example because it carries author annotations that are not mine to publish. **That it exists is the part worth knowing:** on a project where quality is a judgement call, that document is what turns the judgement into something checkable.

There is no filled `CLAUDE.md`, `PROGRESS.md`, or `BUGS.md` here either — those are run state and they change every session, so a frozen copy would mislead. See [`templates/`](../../templates/) for their shapes.

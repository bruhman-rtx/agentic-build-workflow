# Feasibility Spikes

**Every product has one technical bet that, if it fails, kills the thesis. Test it in week one, cheaply, before anything is built on top of it.**

This is the single highest-leverage idea carried over from [the AAA pipeline reference](aaa-pipeline.md), where it appears as a Stage 3 research task. In a lean build it moves earlier and gets harder edges: **a blocking Stage 1 with an explicit stop condition and numeric pass criteria.**

The reason it moves earlier is arithmetic. A large company can afford to discover in month four that the core model does not work, because it has the runway to pivot. A small build cannot. The spike is how you buy that discovery for the cost of one engineer and a few weeks instead of the cost of the project.

---

## What a spike is not

It is not a prototype, a proof of concept, or a spike in the agile-estimation sense.

| | A feasibility spike | A prototype |
|---|---|---|
| Question | *Is this possible at all?* | *What should this feel like?* |
| Output | A number, and a go/no-go | A thing you can click |
| If it fails | **The project stops** | You iterate |
| Lifetime | Thrown away | Often the seed of the real build |
| Built to | Be answered fast, not built well | Be shown to people |

A spike whose failure would not stop the project is not a spike. It is a task. The blocking property is the entire point — everything else about the technique follows from it.

---

## Identifying yours

Write down every assumption the product rests on. Then apply one filter:

> **If this assumption turns out to be false, is the product harder to build — or is it not worth building?**

Most assumptions land in the first bucket. Hard is a scheduling problem. The ones in the second bucket are candidate spikes, and there are usually very few — often exactly one.

Three tests that sharpen it further:

**1. Is it a bet, or is it work?** "We need to handle a million rows" is work; the shape of the solution is known and the only question is effort. "The signal we need is actually present in this data" is a bet — no amount of effort produces it if it is not there. **Spikes test bets, not effort.**

**2. Does everything else depend on it?** Draw the dependency arrows. The bet is usually the node with the most inbound arrows and the fewest outbound — the thing everything is built on, which itself depends on nothing you control.

**3. Would you keep going anyway?** Ask honestly what you would do if the answer came back negative. If the answer is "well, we would probably still try X" — then it is not the bet, and you have not found it yet. Keep looking. If the honest answer is "we would stop", you have it.

**If you cannot name your bet, that is the finding.** A product whose critical assumption is not identifiable usually has one of two problems: the thesis is vague enough to survive any evidence, or the risk is being avoided rather than located. Both are worth knowing in week one.

---

## Making the pass criterion testable

This is where the technique usually fails, and it fails in a specific and predictable way: the criterion is written as a judgement call, so when the results come in, judgement is exercised.

- *"The model produces good results."*
- *"Performance is acceptable."*
- *"The output looks plausible to the team."*

Every one of these passes. They cannot do otherwise — they are evaluated by the people who want the project to continue, after those people have spent a month on it.

A criterion is testable when it has four properties:

| Property | Why |
|---|---|
| **A number** | So the result is compared, not interpreted |
| **A baseline** | So the number means something. "72% accurate" is not a result; "72% against a 68% naive baseline" is — and it is a bad one |
| **A named population** | The specific data, load, or users it is measured on — chosen before the run, and representative of production rather than of the easy case |
| **Written down first** | Recorded before you see any results, in the PRD or the pipeline document, with a date |

The last one carries the most weight and is the one people skip. **A threshold set after seeing the data is not a threshold; it is a description of the data.** Write it into `PIPELINE.md` at Stage 1 and commit it, so the version history shows what you promised yourself before you knew the answer.

A criterion that clears the bar:

> The scorer beats a naive popularity baseline on genre-normalised human agreement by at least 10 points, measured on 500 held-out items rated by 3 raters each. Below that, stop.

---

## Worked patterns

Four shapes that recur. Yours is probably a variant of one.

| Product type | The bet | The spike | A testable pass criterion | If it fails |
|---|---|---|---|---|
| **ML ranking or scoring** — a recommender, a quality scorer, anything where a model orders things for people | The model can beat a naive baseline at agreeing with human judgement | Train a research-grade version on public or scraped data; evaluate against a panel of human raters | Beats a popularity or recency baseline by a pre-set margin on normalised human agreement, on a held-out set with at least 3 raters per item | The product is a ranked feed with a bad ranker — worse than no feed. Kill it, or re-scope to a domain where the signal exists |
| **Simulation or synthetic data** — anything generating data meant to stand in for the real thing | Generated data reproduces the domain's known statistical regularities | Generate a corpus; run the domain's standard statistical checks against a real reference sample | Reproduces the named regularities — distribution shapes, known correlations, tail behaviour — within a stated tolerance, on every check chosen in advance | Downstream consumers train or decide on data that is confidently wrong. Nothing built on it can be trusted, and the error is invisible |
| **Latency-critical or interactive** — realtime collaboration, live inference, anything with a perceptual budget | The budget is achievable at all under realistic load, not merely in isolation | Build the thinnest possible end-to-end path — no features, real network, real data volumes — and measure under concurrency | p95 end-to-end within budget at target concurrency, on representative hardware, with realistic payloads | The architecture is wrong, not the implementation. This is the failure most expensive to discover late, because the fix is structural |
| **Integration- or data-dependent** — the product is a layer over someone else's data or API | The data you need exists, at the coverage you need, and you are permitted to use it that way | Pull a real sample through the real integration, at real rate limits, and measure coverage and legal fit | A stated coverage percentage on a representative sample, within rate limits at projected volume, under terms that permit the use — all three, checked | No amount of engineering creates data that is absent or permission that was not granted. This one is often answerable in days |

Two things to notice about all four.

Each spike is measured against **something external** — a baseline, a reference sample, a budget, a real source — never against its own output. A system evaluated on its own terms always looks reasonable.

And each is **cheap**: days to a few weeks, one person, throwaway code. A spike that takes a quarter is not a spike; it is the project, started before the decision to start it.

---

## The stop condition

A spike without a halt instruction is a research task with extra steps.

By the time results arrive, the situation has changed. Time has been spent. The team has become attached. There is a plan built on the assumption that the bet lands, and the plan has dates on it. Under that pressure the near-miss reads as *promising*, and the honest reading — that the criterion was not met — becomes the uncharitable one.

**So the halt has to be written before any of that is true, and it has to be unconditional.** In `PIPELINE.md`, at Stage 1, inside the exit gate:

> **STOP CONDITION.** If [criterion] is not met, halt. Do not begin Stage 2. Do not proceed on the assumption that it will improve later. Record the result, the number, and the decision in `PRD.md` §20, and escalate to a human. **This instruction overrides schedule pressure and any commitment made on the assumption that this gate would pass.**

The last sentence is the one doing the work. It anticipates the specific argument that will be made against stopping, and settles it in advance — at a moment when nobody has anything invested in the answer.

This matters more, not less, in an agentic build. An agent working overnight against a pipeline document has every structural incentive to advance: that is what it was told to do, and a stage marked *blocked* looks to it like a failure. **A soft gate will be passed.** So write the gate as a command that exits non-zero, and write the halt as an instruction that cannot be read as advisory. Then the agent stops, records, and waits for you — which is exactly the behaviour you wanted. See [`docs/failure-modes.md`](../docs/failure-modes.md).

**The failure mode is not failing the spike.** Failing the spike in week one is the technique working — it is the cheapest good news you will get, even though it does not feel like news at the time.

The failure mode is proceeding hopefully rather than stopping honestly.

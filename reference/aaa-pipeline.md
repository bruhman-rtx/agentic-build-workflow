<!--
REFERENCE DOCUMENT — VERBATIM COPY. Do not edit the body below to suit a
project. Adapt it into a project-specific PIPELINE.md instead, via
prompts/02-pipeline-adaptation.md. Editing this file destroys the baseline
that the adaptation is measured against.
-->

# Reference: the AAA product pipeline

**What this is.** The full product-development pipeline as it runs inside a large, well-resourced product company — every phase, every gate, every artifact, with nothing dropped for convenience.

**What it is for.** This document is the **input to [`prompts/02-pipeline-adaptation.md`](../prompts/02-pipeline-adaptation.md)**. You paste it into the same conversation that produced your PRD, and the model compresses it against your project's actual constraints to produce `PIPELINE.md`.

**It is a reference model, not a process to follow literally.** Nobody outside a company of that size runs all of it, and attempting to is the failure this repo is designed to avoid. Its value is as a *complete* list: it is far easier to consciously delete a phase you have decided you do not need than to remember one you never knew existed. The adaptation step is where the deleting happens, and it should be deliberate and recorded — the compression is the work.

Read it once for the shape. Do not try to implement it.

**On the worked example.** The document uses a hypothetical product ("Frame", a photography-first social platform) to make the phases concrete. It is an illustration, not a real project, and none of its specifics carry over to yours. Read past the example to the phase structure underneath.

---

# The Full Product Pipeline at a AAA Company
## How "Frame" would be built inside Google — idea to GA to sunset

| Field | Value |
|---|---|
| Version | 1.0 |
| Date | 24 August 2026 |
| Companion doc | PRD — Photography-First Social Platform |
| Purpose | Reference model for the complete lifecycle, the formal gates, the artifacts produced at each stage, and which parts are worth stealing for a lean build |

**Note on accuracy:** internal process names and tooling below reflect Google's publicly-known and widely-documented practices. Specific tool names and review-body names change over time; the *shape* of the pipeline — the gates, the artifacts, the sign-off structure — is stable and is the useful part.

---

## Phase map at a glance

| # | Phase | Duration (typical) | Exit gate |
|---|---|---|---|
| 0 | Origination & idea capture | 2–8 weeks | Sponsor identified |
| 1 | Opportunity assessment | 4–8 weeks | GPS / Product Council go-ahead |
| 2 | Funding & staffing | 1 quarter cycle | Headcount + budget allocated |
| 3 | Discovery & foundational UXR | 6–12 weeks | Validated problem + concept |
| 4 | PRD & product definition | 4–8 weeks | PRD approved, OKRs set |
| 5 | Technical design | 6–10 weeks | Design docs LGTM'd, PRR scoped |
| 6 | Build & internal iteration | 6–12 months | Fishfood → dogfood quality bar |
| 7 | Compliance & launch reviews | Runs parallel from Phase 5; hard gate at end | All Ariane blockers cleared |
| 8 | Staged rollout & experimentation | 3–6 months | Metrics clear GA bar |
| 9 | GA launch | 2–4 weeks of activity | Launched, on-call stable |
| 10 | Operate, iterate, or sunset | Indefinite | Annual portfolio review |

**Total: 18–30 months** from serious idea to general availability for a consumer social product of this scope. A social product with ML ranking and UGC moderation sits at the long end.

---

## Phase 0 — Origination

**How ideas enter the system**

| Path | Description | Applicability to Frame |
|---|---|---|
| Top-down strategy | A Product Area (PA) lead identifies a gap in the annual strategy cycle | Likely path: "we have Photos but no photography community" |
| Bottom-up / 20% | An engineer or PM builds a prototype on discretionary time | Historically how Gmail, AdSense, News began |
| Incubator | Google Labs / X-adjacent incubation for zero-to-one bets | Most likely home for Frame today — Labs exists precisely for consumer bets that don't fit an existing PA |
| Acquisition | Buy a team that has already found PMF | Very plausible alternative for this category |
| Adjacency defence | Competitive response to a threat | If a rival photography app scaled |

**Artifacts produced**
- A **one-pager** or "napkin doc": problem, user, why now, why us, rough size of prize. Two pages maximum.
- Often a scrappy demo. At Google, a working prototype outweighs a deck almost every time.

**The real gate here is social, not formal:** you need a Director or VP willing to put their name on it. No sponsor, no pipeline.

**Frame-specific:** the natural sponsor is whoever owns Photos or the Labs consumer portfolio. The pitch inside Google would be framed as: *"a demand-side surface for photography that gives Pixel camera work a cultural home, and a defensible corpus of human-verified photography in a market flooding with generative images."* That second clause is what gets it funded in 2026.

---

## Phase 1 — Opportunity assessment

**Who's involved:** PM (lead), a UXR partner, a Strategy & Ops analyst, an eng lead, sometimes Finance.

**Work performed**
1. **Market sizing** — TAM/SAM/SOM, but at Google the more persuasive framing is *user* sizing: how many monthly actives is this plausibly worth, and does it clear the bar? Google's informal bar for a strategic consumer bet has long been "can this reach 100M users?" Frame realistically caps far below that as a pure photography community, which is the single biggest reason a company like Google would *not* build it — and the biggest reason a startup should.
2. **Competitive teardown** — Instagram, VSCO, Glass, 500px, Flickr, Pinterest, Behance. Feature matrices, retention benchmarks from third-party panel data, revenue models.
3. **Strategic fit** — which company objective does this serve? Does it strengthen Photos, Pixel, Search, or Cloud? Standalone consumer products without a flywheel are hard to fund.
4. **Build / buy / partner analysis** — formal recommendation.
5. **Rough cost model** — headcount, infra TCO per user (for an image-heavy product this is significant: storage, egress, and ML inference per upload).
6. **Cannibalisation analysis** — does this pull engagement from Photos or YouTube?

**Artifact:** a **strategy doc** (10–20 pages) plus a review deck.

**Gate: GPS / Product Council review.** A cross-functional leadership forum where the PM presents to PA leadership. Outcomes: fund, fund-to-next-milestone, kill, or merge into an existing product. Most ideas die here, and correctly so.

**Startup translation:** this is a founder's weekend and a spreadsheet. Do the competitive teardown and the infra cost model properly anyway — image storage/egress economics will surprise you at scale.

---

## Phase 2 — Funding & staffing

**Cadence:** annual planning with quarterly adjustment. Headcount is the real currency; a project without allocated heads doesn't exist regardless of enthusiasm.

**Team assembled for a product like Frame at v1:**

| Function | Count | Notes |
|---|---|---|
| Product Manager | 2 | One lead, one for the ranking/ML surface |
| Eng Manager | 2 | Client + backend/ML |
| Software Engineers | 25–40 | iOS 6, Android 6, backend 10, ML 6, infra 4, tooling 3 |
| ML / Research | 4–6 | Aesthetic scoring, embeddings, ranking |
| UX Designer | 4 | Product design, visual/brand, motion |
| UX Researcher | 2 | Foundational + evaluative |
| UX Writer | 1 | Google treats content design as a specialist function |
| Data Scientist / Analyst | 3 | Metrics, experiment design, A/B analysis |
| SRE | 2–4 | Engaged early; formal PRR later |
| Trust & Safety | 3–5 | Policy + ops + tooling |
| Legal counsel | 1 (fractional) | Product counsel |
| Privacy engineer | 1 | |
| Product Marketing | 2 | |
| Program Manager (TPM) | 2 | Owns the launch checklist and cross-functional gates |

**~55–75 people to ship v1.** This number is the most important thing on this page: it is the honest measure of what the "full AAA pipeline" costs, and it is why a lean team must consciously choose which gates to skip rather than skipping them by accident.

**Artifacts:** staffing plan, quarterly **OKRs**, budget allocation, RACI.

---

## Phase 3 — Discovery & foundational research

This is the phase startups compress most and regret most.

**UX Research program**

| Study type | Method | Output |
|---|---|---|
| Foundational / generative | 20–30 in-depth interviews with photographers across segments and geographies; diary studies of their current posting workflow | Problem validation, persona set, jobs-to-be-done |
| Ecosystem mapping | Where does a photograph actually go today, tool by tool | The workflow map that reveals insertion points |
| Concept testing | 3–4 divergent concepts shown as static mocks | Which framing resonates: portfolio? community? discovery? |
| Competitive usability | Watch photographers use Instagram, Glass, VSCO | Friction inventory |
| Quantitative survey | n=2,000+ across markets | Segment sizing, gear distribution, willingness to pay |

**Design Sprint** — Google's own five-day format (understand → diverge → decide → prototype → validate) is typically run once or twice here to force a testable artifact fast.

**Data science work in parallel:** define the **HEART framework** for the product (Happiness, Engagement, Adoption, Retention, Task success) and map it through **Goals → Signals → Metrics**. For Frame this is where "Weekly Recognised Photographers" would be derived and stress-tested rather than asserted.

**ML feasibility spike** — a research prototype of the aesthetic scorer on public datasets, evaluated against human raters. **This is a gate in disguise:** if the model can't beat a naive baseline on genre-normalised human agreement, the entire product thesis fails and should be killed here, cheaply, before 60 people are staffed against it.

**Artifacts:** research readout deck, persona set, journey maps, concept test results, ML feasibility memo, metrics framework doc.

---

## Phase 4 — Product definition

**The PRD** — the doc you've already drafted. Inside Google it would additionally carry:

- Explicit **OKRs** with numeric targets for the launch quarter
- A **launch tier** proposal (Tier 1 = I/O keynote moment; Tier 3 = quiet blog post)
- **Non-goals** stated aggressively (Google PRDs live or die on scope discipline)
- A **kill criteria** section: the metric thresholds at which the product is sunset. Stating these upfront is what prevents zombie products, and Google's reputation for killing products is partly a *failure* to have set these early enough.

**Parallel definition artifacts**
- **UX Design brief and design principles**
- **Content policy doc** — for a UGC product this is a major standalone workstream, owned by Trust & Safety, not the PM
- **Rater guidelines** — for Frame this is a genuinely large artifact. Google's Search Quality Rater Guidelines run 170+ pages; an equivalent **"Photography Quality Rater Guidelines"** would need to define, in operational language a contract rater in another country can apply consistently, what separates a strong documentary street frame from a mediocre one — per genre. This document *is* the aesthetic model, encoded. Underestimating it is the classic failure mode.
- **Data governance doc** — what is collected, retention periods, deletion propagation

**Reviews at this stage:** PRD review with eng and design leads; UX review with the PA design lead; a first-pass legal and privacy consult (early consult, not the formal gate).

**Gate:** PRD approved and signed by eng, design, and the sponsor. OKRs locked.

---

## Phase 5 — Technical design

**Engineering design docs** — Google's central engineering ritual. Not a template exercise: a well-written design doc is circulated, commented on by senior engineers outside the team, and revised until it earns **LGTM** from the designated reviewers. Frame would need roughly:

| Design doc | Scope |
|---|---|
| Ingestion & media pipeline | Upload, format handling, derivative generation, colour management, CDN strategy |
| Storage & data model | Photo/Set/Profile/ShotData schemas, sharding, cost model |
| Craft assessment service | Model serving, queueing, latency budget, failure modes, backfill strategy |
| Feed & ranking service | Candidate generation, reranking, freshness, personalisation store |
| Search & embeddings | Vector index, hybrid retrieval |
| Metadata normalisation | EXIF → canonical gear graph, fuzzy matching, page generation |
| Social graph | Follows, saves, collections, fan-out strategy |
| Moderation & review tooling | Queues, actioning, appeals, audit log |
| Client architecture (iOS/Android) | Offline behaviour, image caching, upload resumption |
| Privacy design document (PDD) | Data flows, retention, deletion, third-party sharing |
| Experimentation plan | Layer design, metric instrumentation, guardrails |

**Cross-cutting reviews initiated here (all run for months):**
- **Security review** — threat model, authn/authz, abuse surface
- **Privacy review** — the PDD is reviewed by privacy engineering and counsel; for a product handling photographs with location and faces, this is heavy
- **Responsible AI / AI Principles review** — mandatory for any product with a consequential model. For Frame this is the sharpest one: an aesthetic model that decides whose photographs get seen is a **fairness-critical ranking system**. Expect required work on: demographic and geographic fairness evaluation of the scorer, a **model card**, documented mitigation for cultural bias in aesthetic judgement, and an appeals mechanism. Google would very likely require the exploration guarantee and the no-numeric-score decisions already in the PRD — they are exactly the mitigations a RAI review asks for.
- **Accessibility review** — screen reader support for an image-centric product requires an alt-text strategy; auto-generated descriptions plus creator override
- **Internationalisation review** — string externalisation, RTL, locale-aware formatting from day one

**Gate:** all design docs LGTM'd; SRE agrees to an engagement model; capacity and cost model approved.

---

## Phase 6 — Build & internal iteration

**Engineering practice**
- Monorepo, trunk-based development, every change **code-reviewed** by an owner plus a language **readability** approver
- Automated presubmit testing; no merge without green
- Feature flags on everything; nothing ships without a kill switch
- Continuous integration into an internal build that the team uses daily

**The internal release ladder — the part most worth stealing:**

| Stage | Audience | Purpose | Duration |
|---|---|---|---|
| **Fishfood** | The team itself, ~50 people | Does it hold together at all | Weeks 1–8 |
| **Dogfood** | Company-wide volunteers, thousands | Real usage, real bugs, honest internal feedback | 2–4 months |
| **Trusted Tester** | External NDA group — here, the seeded photographers | The first real signal, because internal employees are not photographers | 2–3 months |
| **Closed beta** | Invited external users | Scale behaviours, moderation load, cold-start validation | 2–3 months |
| **Open beta** | Public, labelled beta | Load, abuse, retention curves | 3–6 months |

Google's dogfood culture is a genuine competitive asset — thousands of technically sophisticated users hammering an unreleased product and filing detailed bugs. It's also a **trap for a product like Frame**: Googlers are not the target user, and dogfood feedback on a photography community will systematically over-index on feature requests and under-index on whether the feed feels beautiful. The Trusted Tester stage with real photographers is the one that actually matters.

**Running in parallel through Phase 6**
- **UXR evaluative studies** — usability rounds every 2–3 weeks on the flows being built
- **ML training loop** — rater program spun up, labelled corpus grows, model versions evaluated against held-out human judgement, fairness slices checked at each version
- **Trust & Safety build-out** — policy written, rater guidelines written, moderation tooling built, vendor ops team contracted and trained. For a UGC product this is typically 20–30% of total launch effort and is chronically under-planned.
- **Load and chaos testing**
- **PMM work** — positioning, naming (with trademark clearance through legal), press strategy, launch assets

---

## Phase 7 — Compliance & launch review

At Google, launches are tracked in an internal launch-approval system (**Ariane**) where every required reviewer is a blocking item. Nothing ships with an open blocker. The full set for a product like Frame:

| Review | Owner | What they block on |
|---|---|---|
| Legal — product counsel | Legal | ToS, licence grant language, liability |
| Legal — IP/trademark | Legal | Product name clearance globally |
| Legal — copyright/DMCA | Legal | Safe harbour compliance, takedown process, repeat-infringer policy |
| Privacy | Privacy Eng + counsel | PDD approved, deletion works end-to-end, location handling, minors |
| Regulatory | Compliance | GDPR, DSA (EU — very significant for a UGC platform: notice-and-action, transparency reporting, researcher data access), COPPA/age assurance, India IT Rules & grievance officer, state-level US laws |
| Security | Security Eng | Pen test clean, no criticals open |
| Responsible AI | RAI council | Model card, fairness eval, human oversight, appeals |
| Trust & Safety | T&S | Policy published, enforcement tooling live, ops staffed, escalation paths |
| Accessibility | a11y | Meets the accessibility bar |
| i18n / localisation | i18n | Target languages complete, locale QA passed |
| SRE — **Production Readiness Review** | SRE | SLOs defined, monitoring and alerting complete, runbooks written, on-call rotation staffed, load tested, rollback tested, capacity provisioned |
| Data governance | Data | Retention and deletion enforced systemically |
| Support readiness | Support | Help centre written, escalation trained |
| Comms / PR | Comms | Messaging approved, spokespeople briefed, negative-scenario Q&A prepared |
| Marketing | PMM | Assets, app store listings, campaign |
| Executive sign-off | VP/SVP | Final go |

**Duration:** these run 3–9 months in parallel with build. The formal gate is a hard stop at the end, but the reviews start at Phase 5. **The single most common cause of launch slip at large companies is starting compliance reviews late.**

**Frame-specific hard spots:** the DSA obligations for a UGC platform in the EU, the copyright/DMCA machinery, minors and location data, and the RAI review of the ranking model. Any one of these can add a quarter.

---

## Phase 8 — Staged rollout & experimentation

**Nothing at Google launches at 100%.** The rollout ladder:

1. **1% experiment** in one market — validate instrumentation and check guardrails
2. **5% → 10%** — sufficient power to read primary metrics
3. **Holdback design** — a permanent holdback group is retained so long-run impact remains measurable after GA
4. **Geographic staging** — one country, then English-speaking, then broad
5. **50% → 100%**

**Experiment infrastructure:** overlapping experiment layers so dozens of tests run concurrently without interfering. Every experiment has pre-registered primary metrics, guardrail metrics, and a minimum runtime to survive novelty effects and weekly seasonality.

**For Frame, the experiments that actually matter:**
- Distribution-tier thresholds (§8.3 of the PRD) — where does the T1/T2 boundary sit
- Ranking signal weights, especially save-rate vs. dwell
- Exploration budget size — does the 300–1,000 impression guarantee actually convert
- Onboarding taste calibration: 24 photos vs. 12 vs. skip
- Feed pacing: snap-paging vs. continuous scroll
- Shot-Data panel placement and its effect on session depth

**Guardrails that would block a launch:** creator concentration, aesthetic-model fairness across geographies (does the model systematically under-score photography from non-Western contexts — a real and documented risk in aesthetic datasets), moderation queue latency, and infra cost per active user.

**Gate:** the primary metrics clear the pre-agreed GA bar and no guardrail is regressed.

---

## Phase 9 — General availability

- Launch tier determines the moment: keynote at I/O, standalone blog post, or silent rollout
- App store submissions and review (external dependency, plan two weeks)
- Press embargo, briefings, review units for creators
- Support and T&S surge staffing for the first 30 days — UGC launches attract abuse probing immediately
- **War room** for the first 72 hours with SRE, T&S, and eng leads on rotation
- Public transparency commitments begin (DSA reporting cadence)

---

## Phase 10 — Operate, iterate, or sunset

**Ongoing rituals**
- Weekly metrics review; monthly business review; quarterly OKR grading
- **Blameless postmortems** for every incident — written, published internally, action items tracked
- Continuous experimentation; model retraining on a fixed cadence with fairness re-evaluation each release
- Annual portfolio review where the product is re-justified against its kill criteria

**The sunset process** — genuinely a formal pipeline of its own, and Google's most-criticised one: deprecation announcement, data export tooling (Takeout), migration path, wind-down period, final shutdown. **Frame's PRD should specify a data-export commitment now**, because a photography community that can't export its work will not attract serious photographers in the first place. Making the exit credible is part of making the entrance credible.

---

## What this means for a lean build

You are not going to run 60 people through 24 months of gates. The value of the map is knowing **which gates carry real risk** and which are organisational overhead.

### Keep — these prevent product-killing failures

| Gate | Why it's non-negotiable for Frame |
|---|---|
| **ML feasibility spike before committing** | If the aesthetic scorer can't beat baseline on genre-normalised human agreement, the product thesis is dead. Test this in month one, for the cost of one engineer and a few weeks. |
| **Rater guidelines document** | This is how taste becomes a system rather than one person's opinion. It's the highest-leverage document in the entire build and has no substitute. |
| **Foundational UXR** | 20 real interviews with photographers. Cheap, and the alternative is building for an imagined user. |
| **Trusted Tester stage with real photographers** | Your seeded 300 *are* this stage. Don't skip straight to public. |
| **Trust & Safety planning before launch, not after** | UGC abuse arrives on day one. Policy, tooling, and an ops plan must exist before the first public upload. |
| **Privacy design for location and minors** | Legal exposure and genuine user harm (see the wildlife-poaching case in the PRD). |
| **DMCA / copyright process** | You are running a platform for copyrighted works. Safe harbour requires a compliant process. |
| **Kill criteria, written down** | Decide now what "this isn't working" looks like. |
| **Staged rollout with a holdback** | Even at small scale, ship behind flags and measure. |
| **Fairness evaluation of the scorer** | Not compliance theatre — this is your §8.6 anti-homogenisation work under a different name, and it's core product quality. |

### Compress

Design sprints (run one, not four) · design docs (write them, but three pages not thirty) · localisation (English at launch) · accessibility (do the alt-text strategy; defer full audit) · formal PRR (write a runbook and set SLOs; skip the ceremony).

### Skip

Product Council review · headcount planning cycles · dogfood as a distinct stage · Ariane-style blocking review tooling · comms strategy for a Tier 1 launch · quarterly OKR grading rituals.

### The asymmetry worth naming

Google's pipeline is optimised to avoid catastrophic failure at billion-user scale — regulatory exposure, security incidents, brand damage. It is structurally poor at zero-to-one products in small markets, because the process cost is fixed while the prize varies. **This is precisely why Frame is a better startup than a Google product**, and it's also why the two or three gates above that *do* transfer — the rater guidelines, the fairness evaluation, and the T&S readiness — are worth running with disproportionate seriousness, because they're the ones where a small team's shortcuts produce failures that look identical to a large team's.

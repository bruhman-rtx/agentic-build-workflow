# Bourse — Product Requirements Document

**Version:** 1.0 (Draft)
**Date:** 29 August 2026
**Author:** Chirag
**Status:** For review
**Working title:** Bourse *(alternates: Parallel, Paper, Meridian, Float)*
**Companion doc:** `BOURSE-BUILD-PIPELINE-v1.0.md` — full lifecycle model, gates, artifacts, and agent execution order

---

## 1. Document Purpose

This PRD defines the product, simulation model, mechanics, content system, and interface for a fictional-market trading simulator targeting Android and Windows. It is written to be sufficient for an engineering team to scope, architect, and build v1 without further product discovery, and for a design team to produce high-fidelity screens against a fixed set of constraints.

Sections 4–9 define *what the world is*. Sections 10–13 define *what the player does*. Sections 14–15 define *what it looks like and how it is built*. Section 19 defines *what ships when*.

---

## 2. Product Summary

Bourse is a market simulator in which every company, index, and instrument is fictional — but every market *behaviour* is real. Prices emerge from a synthetic limit order book populated by algorithmic participants. Companies file quarterly results, split, merge, get acquired, issue rights, and go bankrupt. A central bank sets policy in response to simulated inflation and growth. Settlement takes T+1. Taxes are withheld. Slippage is real.

The user receives starting capital scaled to a difficulty setting and trades it into a persistent, never-resetting portfolio. There are no seasons and no do-overs. Going to zero is possible and permanent, exactly as it is in life.

Learning is not a separate mode. It arrives as contextual tips at the moment of a decision, as post-trade coaching on what the decision actually cost, and as an always-available reference library where any term in the app can be tapped to reveal its meaning, its formula, and a live chart demonstrating it.

**One-line promise:** *A real market, in a world that isn't.*

---

## 3. Goals, Non-Goals, and Success

### 3.1 Product Goals

| # | Goal | Rationale |
|---|---|---|
| G1 | Model market microstructure with enough fidelity that skills transfer to real trading | The entire premise. A user who learns to read depth here should read depth on a real terminal. |
| G2 | Remove all real-money risk while preserving all psychological stakes | Loss must *feel* like loss or the lessons don't encode. Hence permanent bust, no undo, no season reset. |
| G3 | Serve a beginner and an experienced retail investor from the same build | Achieved through progressive disclosure via the skill tree, not through separate modes. |
| G4 | Make the reference layer so complete that the user never leaves the app to look up a term | Every number, label, and abbreviation in the UI is a tappable definition. |
| G5 | Generate a 500+ company universe with real economic texture without hand-authoring it | Procedural genesis + simulation-derived financials + LLM-authored narrative. |

### 3.2 Non-Goals for v1

- **Real market data.** No live or delayed feeds from real exchanges. Ever, in v1.
- **Multiplayer, social feeds, copy trading, leaderboards.** Deferred to v2.
- **Monetization.** No IAP, no subscription, no ads.
- **iOS, macOS, web.** Android and Windows only.
- **A course.** There is no lesson library, no curriculum, no syllabus, no quiz gates.
- **A conversational AI assistant.** Coaching is generated recaps, not chat.
- **Real financial advice.** The app must never imply its simulated outcomes predict real ones.

### 3.3 Success Metrics

| Metric | Target (90 days post-launch) |
|---|---|
| D7 retention | ≥ 35% |
| D30 retention | ≥ 18% |
| Median sessions/day among D7-retained | ≥ 3 |
| Median session length | 8–14 min |
| % of users who place a limit order by day 3 | ≥ 60% |
| % of users who open the Codex from an in-context tap | ≥ 70% |
| % of users who unlock a second asset class by day 14 | ≥ 40% |
| Bust rate (portfolio → 0) within 30 days | 8–15% *(too low = no stakes; too high = broken balance)* |
| Crash-free session rate | ≥ 99.5% |

---

## 4. Target Users

The app serves four audiences from a single build. Progressive disclosure is the mechanism.

### 4.1 Persona A — "Never Traded"

Curious, intimidated, has heard that index funds are sensible and that options ruin people. Opens the app knowing roughly nothing. Needs the first ten minutes to produce a completed trade and an understood outcome.
**Design implication:** Easy difficulty defaults on. Only equities and ETFs visible. Tips fire aggressively. Order ticket defaults to Market with quantity pre-filled at 1% of capital.

### 4.2 Persona B — "Retail Investor, Risk-Free Sandbox"

Already invests real money. Wants to test whether a strategy survives contact with slippage, taxes, and drawdown before committing capital. Cares deeply about whether the simulation is honest.
**Design implication:** Must be able to reach full instrument access quickly. Screener, indicators, and portfolio analytics must be genuinely usable. Cost modelling must be visible and auditable per trade.

### 4.3 Persona C — "Student / Classroom"

Assigned or self-directed learner. Needs the reference layer, needs exportable performance reports, benefits from the behavioural profile.
**Design implication:** Vault export must produce clean, shareable P&L and tax statements. Codex must be navigable as a standalone body of knowledge, not only as contextual popups.

### 4.4 Persona D — "Finance-Curious Gamer"

Came for the simulation depth as a *system to master*. Will read patch notes about the matching engine. Will try to break the market.
**Design implication:** The skill tree must offer meaningful build diversity. Hard difficulty must be genuinely punishing. The macro dashboard must be tradeable, not decorative.

---

## 5. Design Principles

1. **The simulation is the teacher.** No lesson explains what a bad fill feels like better than a bad fill. Content supports the sim; it never substitutes for it.
2. **Realism is not negotiable; complexity is.** Every rule the real market has, the sim has. The *interface* hides rules until the user is ready, but the engine never simplifies them behind the scenes. A beginner's market-order fill is still walking a real book.
3. **Consequences are permanent.** No undo, no rewind, no season reset, no bailout. This is the source of every emotional stake the product has.
4. **Definition is always one tap away.** If a term, ratio, abbreviation, or chart element appears on screen, it is tappable and it explains itself.
5. **Density with air.** Tactile minimalism: a lot of information, generous rhythm, no decoration that isn't data.
6. **The app never advises.** It explains what happened and what a concept means. It does not say what to buy.

---

## 6. Core Loop

```
        ┌──────────────────────────────────────────┐
        │                                          │
        ▼                                          │
  ┌──────────┐    ┌──────────┐    ┌──────────┐   ┌──────────┐
  │ OBSERVE  │───▶│ RESEARCH │───▶│  TRADE   │──▶│  REVIEW  │
  │          │    │          │    │          │   │          │
  │ Market   │    │ Filings  │    │ Order    │   │ Fill     │
  │ moves,   │    │ screener │    │ ticket,  │   │ quality, │
  │ news,    │    │ charts,  │    │ sizing,  │   │ costs,   │
  │ macro    │    │ playbook │    │ risk     │   │ coaching │
  └──────────┘    └──────────┘    └──────────┘   └──────────┘
                        │                              │
                        └──── Codex (any term) ────────┘
                                     │
                                     ▼
                            ┌────────────────┐
                            │  SKILL POINTS  │
                            │  new tools,    │
                            │  new access    │
                            └────────────────┘
```

**Session shape (target 8–14 min):** open → away-summary of what moved while gone → check positions and open orders → scan news/macro → research one or two names → place or amend orders → review the previous session's coaching card → close.

---

## 7. Time Model

### 7.1 Compression Ratio

**1 game trading day = 60 real minutes.** The game calendar skips weekends and simulated holidays; those are collapsed, not played.

### 7.2 Derived Timescales

| Game period | Real duration | Note |
|---|---|---|
| 1 trading day | 1 hour | |
| 1 trading week (5d) | 5 hours | |
| 1 month (~21 trading days) | ~21 hours | Roughly a real day |
| 1 quarter (~62 trading days) | ~2.6 real days | Earnings cadence per company |
| 1 year (~250 trading days) | ~10.4 real days | LTCG holding threshold ≈ 10 days real |
| 1 full market cycle (3–7 game years) | ~1–2.5 real months | Regime turnover |

This compression is deliberate: a user reaches a long-term capital gains holding period in about a week and a half of real time, and lives through a full bull-to-bear cycle within their first two months. Both are essential lessons that a 1:1 clock would never deliver.

### 7.3 Session Structure Within the Hour

Real hours are stretched so the market is open for most of each real hour. A literal 6h15m NSE session would compress to 15 real minutes, leaving the market shut 75% of the time a user opens the app — unacceptable. An always-open market would eliminate overnight gaps, the closing auction, and after-hours news reaction, all of which are core teaching mechanics.

**MSX (India-analogue) session map, per real hour:**

| Real minute | Game phase | Notes |
|---|---|---|
| 00:00–00:03 | Pre-open auction | Order collection, indicative equilibrium price published |
| 00:03–00:53 | Continuous trading | Full order book matching |
| 00:53–00:55 | Closing auction | VWAP-based close determination |
| 00:55–01:00 | Post-close | Results, announcements, and overnight news released here; produces the next day's gap |

**ATX (US-analogue)** runs the same structure offset by 30 real minutes, so at least one venue is open at all times. Cross-listed instruments and the FX pair remain live across both.

### 7.4 Absence and Continuity

**The market runs 24/7 in real time.** It does not pause when the user closes the app. A user who sleeps eight hours returns to eight game trading days elapsed — roughly a third of a game month.

Mitigations, none of which pause the clock:

- **Away Summary.** On return, a dismissible full-screen digest: portfolio delta, index moves, orders filled or expired, corporate actions on held names, margin events, and the three most consequential news items affecting the portfolio.
- **Resting orders work while away.** Stop-losses, GTC limits, and bracket orders execute unattended. Learning to leave protection on the book *is* the lesson.
- **Margin calls escalate.** Push notification at breach, forced liquidation only after a grace period equal to one game session.
- **Position-scale alerts.** User-configurable price and P&L alerts delivered as push.

---

## 8. Simulation Engine

This is the product's core asset. Everything else is interface on top of it.

### 8.1 Architecture

Four layers, evaluated in order each tick:

```
  MACRO LAYER          rates, inflation, growth, FX, credit spreads
        │              central bank reaction function
        ▼
  FUNDAMENTAL LAYER    per-company revenue, margin, earnings, balance sheet
        │              sector correlation, supply/demand shocks
        ▼
  PARTICIPANT LAYER    fair-value estimates → order intentions
        │              market makers, institutions, momentum, noise, informed
        ▼
  MATCHING ENGINE      price-time priority limit order book
                       fills, prints, depth, tape
```

Prices are **not** generated by a formula. Prices are the output of orders meeting in a book. This is the single most important architectural decision in the product, and the reason market impact, spread, slippage, gaps, and liquidity crises emerge naturally instead of being faked.

### 8.2 Matching Engine

- **Price-time priority** continuous double auction.
- **Tick size** scaled by price band, mirroring real exchange conventions.
- **Circuit breakers:** per-security bands (2/5/10/20% depending on band assignment) and index-level halts (10/15/20% triggering timed halts).
- **Auction mechanics:** pre-open equilibrium price discovery and closing-auction VWAP determination, both fully simulated.
- **Tick rate:** 250ms wall-clock during continuous session. Sub-tick order arrivals are queued and sequenced.
- **Order book depth** is exposed to the user at Level 2 (five price levels per side) once unlocked in the skill tree; Level 1 (best bid/ask) is always visible.

### 8.3 Synthetic Participants

Each instrument is quoted by a population of bots whose composition determines its liquidity character. Small caps get thin books and wide spreads because they are assigned fewer market makers — not because a "liquidity" number was set by hand.

| Archetype | Behaviour | Effect on the tape |
|---|---|---|
| **Market Makers** | Quote two-sided around a fair-value estimate; widen with volatility and inventory risk; pull quotes in stress | Provide spread and depth; their withdrawal *is* a liquidity crisis |
| **Institutional** | Large orders sliced over time (TWAP/VWAP-like); slow, persistent directional pressure | Sustained trends, absorption at levels |
| **Momentum / Trend** | Chase breakouts, amplify moves, capitulate on reversals | Overshoot, blow-off tops, cascading stops |
| **Value / Contrarian** | Buy below fundamental fair value, sell above | Mean reversion, support at valuation floors |
| **Informed** | Receive news 1–3 ticks early with partial accuracy | Pre-announcement drift — teaches that price moves before you read about it |
| **Noise** | Random small orders | Baseline volume and micro-volatility |
| **Retail Herd** | Follows recent news sentiment and social heat | Crowded trades, sentiment extremes |

**Population weighting varies by instrument class:** large-cap equities are market-maker dominated; small caps are noise and retail dominated; the crypto-analogue is momentum and retail dominated with thin MM presence.

### 8.4 Fundamental Layer

Every company runs a live economic model. Financial statements are **derived from the simulation**, never authored.

Per company, per simulated quarter:
- Revenue = f(sector demand index, market share, pricing power, macro growth, idiosyncratic execution draw)
- COGS, opex, D&A, interest expense → operating income → net income
- Balance sheet evolves: capex, working capital, debt issuance/repayment, cash accumulation
- Cash flow statement reconciles to the above
- Derived ratios (P/E, P/B, EV/EBITDA, ROE, ROCE, D/E, current ratio, interest coverage) computed, not stored

**Fair value** is computed per company via a DCF using simulated forward cash flows and a discount rate anchored to the central bank policy rate plus an equity risk premium plus a company-specific risk spread. Participants receive *noisy, heterogeneous estimates* of this fair value — which is why price oscillates around value rather than sitting on it.

**Earnings surprises** arise from the gap between the analyst consensus (itself a noisy aggregate of participant estimates) and the realised result. Surprise magnitude drives the gap at the next open.

### 8.5 Macro Layer and Central Bank

A visible, tradeable macro regime.

**State variables:** policy rate, inflation (headline and core), GDP growth, unemployment, currency level, credit spreads, commodity price indices, yield curve (2y/5y/10y/30y).

**Central bank reaction function:** a Taylor-rule variant reacting to the inflation gap and output gap, with policy inertia and occasional deliberate surprises. Announcements occur on a published calendar; the user can see the schedule and position ahead of it.

**Transmission:** rate changes flow to discount rates (equity valuations), bond prices (duration effects), FX (rate differential), sector rotation (rate-sensitive sectors reprice hardest), and credit spreads (default risk on leveraged names).

**Macro dashboard** exposes all of the above with history, forward expectations implied by the yield curve, and the announcement calendar. This is a first-class trading surface, not a decoration.

### 8.6 Regimes and Shocks

Procedurally generated, layered:

| Layer | Period | Mechanism |
|---|---|---|
| **Market regime** | 3–7 game years | Hidden Markov process over Bull / Bear / Sideways / Crisis states; governs baseline drift, volatility, and cross-asset correlation |
| **Sector cycles** | 1–3 game years | Independent per-sector demand cycles; drives rotation |
| **Idiosyncratic events** | Continuous | Company-level: product success/failure, litigation, management change, accounting irregularity, fraud discovery |
| **Tail shocks** | Rare, stochastic | Systemic: banking stress, sovereign event, commodity supply shock, pandemic-analogue, geopolitical rupture. Correlations converge toward 1 during these — the crucial lesson that diversification fails precisely when needed |

Shock templates are procedural: the engine composes a shock from parameters (magnitude, sector incidence, duration, recovery shape, correlation impact) rather than replaying a scripted 2008.

### 8.7 Market Impact

Emergent, not modelled. A large market order walks the book and fills at progressively worse prices. In a thin small cap, a moderate order moves the price several percent. In a large-cap ETF, the same notional barely registers. Market makers observe the imbalance and reprice. No impact coefficient exists anywhere in the codebase — this is the payoff for building an order book instead of a price generator.

---

## 9. The World

### 9.1 Exchanges

| | **MSX — Meridian Stock Exchange** | **ATX — Atlas Exchange** |
|---|---|---|
| Analogue | India (NSE/BSE) | United States |
| Currency | ᛗ (Meridian Rupee) — displayed as ₹-equivalent | ₳ (Atlas Dollar) — displayed as $-equivalent |
| Tax regime | STCG 20% / LTCG 12.5% above threshold; STT; stamp duty | Short-term at income rate / long-term 15%; wash-sale rule |
| Settlement | T+1 | T+1 |
| Notable rules | Circuit limits per band, ASM/GSM surveillance framework analogue, IPO lottery allotment | Pattern Day Trader rule, Reg-T margin, no per-security circuit bands (index halts only) |
| Session offset | :00 | :30 |

The user picks a **home jurisdiction** at onboarding, which sets their default tax regime, currency, and rulebook. The second exchange unlocks via the skill tree, introducing FX exposure and cross-border tax treatment as genuine mechanics.

### 9.2 Company Universe

**Scale:** 520 companies at launch.

| Tier | Count | Character |
|---|---|---|
| Mega cap | 20 | Deep books, tight spreads, heavy analyst coverage, low idiosyncratic volatility |
| Large cap | 80 | Liquid, well-covered |
| Mid cap | 140 | Moderate liquidity, patchy coverage |
| Small cap | 200 | Thin books, wide spreads, high volatility, minimal coverage |
| Micro cap | 80 | Very thin, gap-prone, elevated bankruptcy and fraud incidence |

Plus **28 indices** (broad market, sector, thematic, volatility) and **34 ETFs** tracking them.

### 9.3 Sectors

Real GICS-style taxonomy for maximum transfer of learning: Energy, Materials, Industrials, Consumer Discretionary, Consumer Staples, Health Care, Financials, Information Technology, Communication Services, Utilities, Real Estate. Each with 3–6 sub-industries carrying distinct cycle timing, margin structure, capital intensity, and rate sensitivity.

**Thematic baskets** cut across sectors: AI Infrastructure, Clean Transition, Defence, Aging Demographics, Frontier Compute.

### 9.4 Company Genesis Pipeline

Hand-authoring 520 companies with full statements and living narratives is not feasible. The pipeline:

**Stage 1 — Procedural skeleton.** Generate name, ticker, sector, sub-industry, founding year, market cap tier, and an economic parameter vector (margin profile, growth trajectory, capital intensity, leverage appetite, cyclicality, competitive moat score, management quality score, governance risk score).

**Stage 2 — Financial history.** Run the fundamental model backwards for 10 game years to produce a plausible historical statement series, so a company arrives at launch with a real track record to analyse.

**Stage 3 — Narrative authoring (LLM, offline, human-reviewed).** Generate founder story, business description, product portfolio, management bios, competitive positioning, and known risks — all **constrained to be consistent with the parameter vector**. A high-governance-risk company gets a founder story with governance foreshadowing.

**Stage 4 — Arc seeding.** Assign each company 1–3 latent narrative arcs (see 9.5) with trigger conditions.

**Stage 5 — Validation.** Automated checks: statements reconcile, ratios fall in sector-plausible ranges, no name collisions, no real-company resemblance, narrative-parameter consistency.

**Ongoing:** new companies IPO into the universe; bankrupt and acquired companies leave it. The universe is not static.

### 9.5 Narrative Arcs

Each company carries latent multi-quarter storylines that activate on trigger conditions and resolve over game months. Arc types:

- **Product cycle** — build-up, launch, reception, revenue impact
- **Expansion** — new market entry, capex drag, then payoff or write-off
- **Governance** — irregularity surfaces, investigation, restatement or exoneration
- **Activist** — stake accumulation, public letter, board fight, strategic change
- **Distress** — covenant stress, refinancing risk, rescue or default
- **Consolidation** — approach, rumour, bid, regulatory review, close or collapse
- **Succession** — founder exit, interim management, new strategy
- **Disruption** — a competitor's innovation erodes the moat over several quarters

Arcs surface as news items and progressively alter the fundamental parameter vector. A user who reads filings closely can see the numbers turn before the narrative confirms it — the core research lesson.

### 9.6 News System

Three streams, all generated:

| Stream | Source | Latency |
|---|---|---|
| **Filings & announcements** | Machine-generated from simulation state: results, corporate actions, guidance, regulatory disclosures | Instant, authoritative |
| **Market wire** | Price/volume-derived: unusual volume, 52-week extremes, block trades, halts, index changes | Real-time |
| **Editorial** | LLM-authored, arc-driven: analysis pieces, rumours, opinion, some of it **wrong** | Delayed, variable reliability |

Editorial deliberately includes unreliable reporting with a visible source-reliability score. Learning to weight sources is a teaching objective.

### 9.7 Corporate Actions

Full set, all simulated with correct cash and position mechanics:

| Action | Mechanics modelled |
|---|---|
| **Earnings** | Quarterly, on a published calendar, consensus vs actual, guidance, post-announcement drift |
| **Dividends** | Declaration, ex-date, record, payment; price adjusts on ex-date; DRIP option; dividend tax |
| **Stock splits / bonus issues** | Position multiplication, price division, cost basis adjustment |
| **Buybacks** | Announcement, execution over time as genuine order flow into the book, EPS effect |
| **Rights issues** | Entitlement, subscription window, renunciation, theoretical ex-rights price |
| **M&A** | Rumour, formal bid, premium, cash/stock/mixed consideration, regulatory review, completion or collapse; arbitrage spread is tradeable |
| **Spin-offs** | Share distribution, basis allocation, when-issued trading |
| **Delisting** | Voluntary and compulsory, with warning period and forced settlement |
| **Bankruptcy** | Covenant breach → restructuring or liquidation; equity typically to zero; teaches that equity is residual |
| **IPOs** | Announcement, price band, book building, **lottery-style allotment** on MSX, listing day dynamics, lock-up expiry |

---

## 10. Instruments and Trading

### 10.1 Asset Classes

All ship in v1. Access is gated by real-world-style eligibility, not by arbitrary level.

| Class | Instruments | Eligibility gate |
|---|---|---|
| **Equities** | 520 stocks, both exchanges | Open at account creation |
| **ETFs / Index funds** | 34 ETFs, index trackers | Open at account creation |
| **Fixed income** | Sovereign curve (2/5/10/30y), corporate IG and HY, floating rate | Fixed income segment activation |
| **Commodities** | Gold, silver, crude, copper, agricultural complex — spot and futures | Commodity segment activation |
| **Crypto-analogue** | 12 synthetic digital assets, 24/7, extreme volatility, no fundamentals | Risk acknowledgement |
| **Forex** | MSX/ATX currency pair plus 4 crosses | Unlocked with second exchange |
| **Derivatives** | Index and single-stock options (full chain, all Greeks), index and stock futures | Derivatives segment activation: suitability questionnaire + demonstrated equity experience + margin approval |

### 10.2 Eligibility Model

Mirrors how real brokerages actually gate access:

1. **Segment activation** — user requests access to a segment; app presents the real risk disclosure; user acknowledges.
2. **Suitability check** — a short questionnaire for derivatives and margin, exactly as a real broker administers. Answers are recorded, not scored for pass/fail — but reckless answers trigger stronger warnings.
3. **Experience threshold** — derivatives require a minimum number of settled equity trades and a minimum account age.
4. **Margin approval** — requires minimum equity balance and acknowledgement of margin call mechanics.
5. **Regulatory constraints apply** — PDT rule on ATX below the equity minimum; ASM/GSM-analogue surveillance restrictions on volatile MSX small caps.

There are **no knowledge quizzes** gating instruments. The gate is procedural, as in reality.

### 10.3 Order Types

Full set at v1:

| Order type | Notes |
|---|---|
| Market | Walks the book; slippage displayed pre-confirmation |
| Limit | Rests on the book with price-time priority |
| Stop / Stop-loss | Triggers a market order at the stop price |
| Stop-limit | Triggers a limit order |
| Trailing stop | Absolute or percentage trail |
| Bracket (OCO) | Entry + target + stop as a linked group |
| Cover / Intraday margin | Higher leverage, mandatory square-off before close |
| GTC / GTD / Day | Time-in-force variants; GTC survives sessions |
| Iceberg | Displays partial quantity; teaches large-order execution |
| AMO (after-market) | Queues for next pre-open |

**Modification and cancellation** are supported for resting orders. **There is no undo on a filled order.** Fills are final.

### 10.4 Costs, Taxes, Settlement

Every trade produces a fully itemised contract note. Nothing is hidden.

**Transaction costs:**
- Brokerage: flat fee per order or percentage, per configured broker profile
- Exchange transaction charges
- Clearing charges
- Regulatory fee
- Stamp duty (MSX)
- Securities Transaction Tax (MSX, on sell side for equity delivery, both sides for intraday and derivatives)
- GST on brokerage and transaction charges
- Bid-ask spread (implicit, shown as a cost line in the post-trade analysis)
- Slippage vs. mid at time of order (implicit, shown as a cost line)

**Taxes:**
- MSX: STCG at 20% for holdings under 12 game months; LTCG at 12.5% above the annual exemption threshold; separate treatment for derivatives (business income analogue); dividend taxed at slab
- ATX: short-term at marginal rate; long-term at 15%; **wash-sale rule enforced** — a loss harvested and repurchased within the window is disallowed and added to basis
- Tax is computed continuously and displayed as an accrued liability in the Vault, then settled at game year-end. A user who ignores tax accrual and spends the gross gets a lesson.

**Settlement:**
- T+1 on both venues. Sale proceeds are unavailable for withdrawal until settled, though intraday reuse is permitted per real convention.
- Short selling requires borrow availability, which is limited per security and carries a borrow fee accruing daily. Hard-to-borrow names cost meaningfully more; a short squeeze can make borrow unavailable entirely and force a buy-in.

### 10.5 Margin and Risk

- **Initial and maintenance margin** per instrument, with SPAN-style portfolio margining for derivatives
- **Real-time margin utilisation** displayed persistently
- **Margin call** on maintenance breach: push notification, one game session grace period, then forced liquidation of positions in order of largest margin consumption
- **Negative equity** possible on leveraged positions in a gap — resulting in a debit balance, which is the bust condition
- **Position limits** on derivatives per real convention

---

## 11. Economy, Capital, and Bust

### 11.1 Difficulty Modes

One setting, chosen at onboarding, bundling three dimensions. **Changeable only by starting a new account** — the setting is a commitment, not a slider.

| | **Steady** | **Standard** | **Severe** |
|---|---|---|---|
| Starting capital | ᛗ 5,000,000 | ᛗ 1,000,000 | ᛗ 100,000 |
| World volatility | 0.7× baseline | 1.0× | 1.4× |
| Tail shock frequency | 0.5× | 1.0× | 1.8× |
| Regime persistence | Longer bulls | Realistic | Shorter cycles, faster reversals |
| Tips and coaching | Maximum — proactive, pre-trade warnings | Contextual, on request and post-trade | Minimal — post-trade only, no warnings |
| Skill point rate | 0.75× | 1.0× | 1.5× |
| Recommended for | Persona A | Personas B, C | Personas B, D |

### 11.2 Capital Inflows

Three ongoing channels beyond the starting balance:

| Channel | Mechanic | Rationale |
|---|---|---|
| **Daily stipend** | Small fixed credit on first session of each real day, streak-scaled up to a cap | Retention hook; also models external income |
| **Quest earnings** | Task completion credits: "place your first limit order", "hold a position through an earnings announcement", "rebalance to target weights", "read a full annual report" | Directs behaviour toward skill acquisition, not just profit |
| **Salary deposit** | Recurring credit each game month, with a configurable auto-invest allocation | Models SIP behaviour and teaches the discipline of periodic investing — arguably the single most valuable habit the app can install |

**Idle cash earns the policy rate** in a sweep account, less a spread. This makes the opportunity cost of holding cash visible and tradeable — during a high-rate regime, cash is a real position.

All three channels are modest relative to the portfolio. Trading remains the dominant driver of net worth. Inflows exist to sustain engagement and model real financial life, not to bail out bad decisions.

### 11.3 Bust

Portfolio equity reaching zero or negative is **terminal for that account.**

**Sequence:**
1. Warning state at 15% of starting capital: persistent banner, coaching intervention
2. Critical state at 5%: full-screen acknowledgement required to continue trading
3. Bust at ≤ 0: trading disabled, account closed

**On bust, the app produces a Post-Mortem:** the complete arc of the account, the decisions that mattered, the drawdown chart, the behavioural pattern that recurred, and the specific moments where the outcome was decided. This is the single most valuable artefact the product generates, and it only exists because bust is real.

**The busted account is archived permanently in the Vault.** The user starts a new account, potentially at a different difficulty, and the record persists. Nothing is deleted. This is a career, not a run.

---

## 12. Progression: The Skill Tree

No XP levels, no career titles. The user earns **Skill Points** and spends them on a tree, producing meaningful build diversity.

### 12.1 Earning Skill Points

- Quest completion (primary)
- Milestone achievements (first ex-dividend held, first earnings survived, first margin call cleared without liquidation, first bear market traded, first tax year closed)
- **Not** for profit. Profit rewards itself. Rewarding profit with power would compound luck and teach the wrong lesson.

### 12.2 Branches

**Branch I — ANALYSIS**
```
  Charting I (indicators: MA, RSI, MACD, Bollinger)
      └── Charting II (drawing tools, Fibonacci, multi-timeframe)
            └── Charting III (custom indicators, saved templates)
  Screener I (price/volume/sector filters)
      └── Screener II (fundamental filters, ratio ranges)
            └── Screener III (custom formulas, saved screens, alerts on screens)
  Filings I (income statement view)
      └── Filings II (balance sheet, cash flow, ratio history)
            └── Filings III (peer comparison, common-size analysis, quality flags)
  Depth I (Level 2 order book)
      └── Depth II (time & sales tape, volume profile)
```

**Branch II — RISK**
```
  Position Sizing (calculator, % of capital rules, Kelly-style guidance)
      └── Portfolio Risk (exposure by sector/factor, concentration warnings)
            └── Advanced Risk (VaR, beta, correlation matrix, stress testing)
  Hedging (understand and place protective structures)
      └── Portfolio Hedging (index hedges, ratio calculation)
  Margin Access (leverage eligibility)
      └── Short Access (short selling eligibility)
            └── Derivatives Access (options and futures eligibility)
```

**Branch III — ACCESS**
```
  Fixed Income Segment
  Commodity Segment
  Digital Assets Segment
  Second Exchange (ATX or MSX, whichever is not home) → unlocks FX
  Extended Instruments (iceberg orders, AMO, cover orders)
```

**Branch IV — INTELLIGENCE**
```
  Analyst Coverage (consensus estimates, target prices, rating changes)
      └── Institutional Flow (holdings data, block trade attribution)
  Macro Dashboard (full economic data, yield curve, policy calendar)
      └── Macro Forecasting (implied expectations, scenario modelling)
  Coaching Depth (richer post-session analysis)
      └── Behavioural Profiling (bias detection in the Vault)
```

### 12.3 Design Intent

A user who invests entirely in Analysis becomes a fundamental researcher with no leverage. A user who rushes Access reaches derivatives with no risk tooling — and the tree lets them, because that mirrors reality and the consequences teach. Respecialisation costs accumulated points, so builds are commitments.

---

## 13. Learning Layer

Three surfaces. No curriculum, no quizzes, no gates.

### 13.1 Just-In-Time Tips

Triggered by user action, not by schedule. Delivered as compact, dismissible cards adjacent to the relevant control.

**Trigger examples:**
- Order size exceeds 20% of portfolio → concentration risk card
- Buying within 2% of a 52-week high after a >15% run → momentum and mean-reversion card
- Placing a market order in a security whose book depth implies >1% slippage → slippage card with the estimated cost
- Selling a winner held 11.5 game months → LTCG threshold card showing the tax delta of waiting
- Third trade in the same security within one session → overtrading and cost-drag card
- Holding through an earnings announcement without a stop → event risk card
- First margin utilisation above 60% → margin call mechanics card

Frequency scales inversely with difficulty and decays as the user demonstrates the behaviour is understood.

### 13.2 Post-Trade Coaching

Every closed position generates a **Trade Card**:

- Entry and exit with chart context (where you bought and sold, marked on the price series)
- Realised P&L, decomposed: **price movement, costs, taxes, slippage, timing**
- Execution quality: fill vs. mid, fill vs. the day's VWAP, fill vs. the best price available in the following session
- What the alternative would have been: holding, sizing differently, using a limit instead of market
- The specific concept this trade illustrates, linked into the Codex

**Session recap** aggregates the above: what moved, what you did, what it cost, and the one thing most worth noticing. Generated, not chatted with.

### 13.3 The Codex (Reference Library)

Reachable three ways, all of which must work:

1. **Its own tab** in the primary navigation — browsable as a body of knowledge
2. **Slide-in panel** from any screen via a persistent affordance
3. **Tap-any-term** — every label, ratio, abbreviation, and chart element in the entire app is a tappable entry point opening the definition in context, without losing place

**Contents:**

| Section | Detail |
|---|---|
| **Glossary** | Every term used anywhere in the app. Each entry: plain-language definition, formula where applicable, worked example using the user's *own* current portfolio data, a live chart from the simulation demonstrating it, and links to related terms. Target 600+ entries at launch. |
| **Guides** | Short illustrated explainers, 400–900 words, each anchored to a live or historical chart from the user's own simulation. Topics span order types, reading a book, market structure, valuation, financial statements, technical analysis, macro transmission, taxes, risk, derivatives, and behaviour. Target 80 guides at launch. |
| **Playbooks** | Strategy write-ups with an honest structure: the thesis, the mechanics, **when it works, when it fails, what it costs, and the historical conditions under which it destroyed people.** Covers value, growth, momentum, mean reversion, dividend income, index investing, pairs, arbitrage, covered calls, protective puts, and more. Every playbook carries a failure section — this is non-negotiable. Target 30 playbooks at launch. |

Guides and playbooks render live charts pulled from the running simulation, so the illustration is always of a real market the user can go and look at.

**Not included:** standalone academic deep-dives. The playbooks and guides absorb that material in applied form.

### 13.4 The Vault (Personal Data)

Complete, exportable, permanent.

| Section | Contents |
|---|---|
| **Trade log** | Every order: placed, modified, cancelled, filled. Timestamps, prices, quantities, order type, venue, every fee line, tax treatment, resulting position and cash effect. Filterable and searchable. |
| **Performance** | XIRR (portfolio and per-holding), CAGR, absolute and relative return vs. benchmark, win rate, average win vs. average loss, profit factor, maximum drawdown and recovery time, Sharpe and Sortino, exposure history, sector and factor attribution |
| **Behavioural profile** | *(unlocked via Intelligence branch)* Detected patterns: disposition effect (selling winners, holding losers), overtrading frequency and its cost drag, revenge trading after losses, position-size inflation after wins, FOMO entries at local extremes, loss aversion measured through stop placement, recency bias in sector allocation. Presented as observed statistics with the specific trades as evidence — never as personality labels or diagnosis. |
| **Reports** | Exportable: P&L statement, capital gains statement by holding period, contract note archive, dividend and income summary, full transaction ledger. CSV and PDF. |
| **Account history** | All accounts, including busted ones, with their post-mortems. |

---

## 14. Interface and Experience

### 14.1 Platform Targets

| | Android | Windows |
|---|---|---|
| Minimum | Android 10 (API 29) | Windows 10 20H2 |
| Form factor | Phone primary, tablet supported | Desktop, 1280×720 minimum |
| Layout | Single-column, bottom navigation | Multi-pane, persistent sidebar, resizable panels |
| Input | Touch, gesture | Mouse, full keyboard shortcuts |

The Windows client is not a stretched phone app. It exposes a multi-pane workspace: watchlist, chart, order book, and ticket simultaneously visible, with saveable layouts. The Android client is optimised for the 8–14 minute check-in session.

### 14.2 Navigation

**Android — bottom tab bar, five items:**

| Tab | Contents |
|---|---|
| **Home** | Configurable dashboard |
| **Markets** | Instrument browser, screener, watchlists, indices, macro |
| **Trade** | Order ticket, positions, open orders, order history |
| **Codex** | Glossary, guides, playbooks |
| **Vault** | Performance, trade log, behavioural profile, reports, settings |

A persistent Codex affordance (a small tab-edge handle) opens the slide-in reference panel from any screen without losing context.

**Windows — left sidebar** with the same five destinations plus a workspace switcher for saved multi-pane layouts.

### 14.3 Home: Configurable Dashboard

The home screen is user-composed from a widget library. A default arrangement ships per difficulty mode; everything is rearrangeable and removable.

**Widget library:**
- Portfolio value with P&L (day, period, all-time) and sparkline
- Holdings summary with per-position P&L
- Allocation donut (by asset class, sector, or geography)
- Watchlist (compact or expanded)
- Index strip
- News feed (all, or filtered to holdings)
- Macro snapshot (policy rate, inflation, yield curve shape)
- Open orders
- Upcoming events calendar (earnings, ex-dates, policy announcements, IPO windows, lock-up expiries)
- Active quests
- Margin utilisation gauge
- Accrued tax liability
- Top movers (market or portfolio)
- Recent Trade Cards
- Skill point balance and available unlocks

Long-press to enter edit mode; drag to rearrange; widgets are one or two columns wide on Android, freely sized on Windows.

### 14.4 Key Screens

**Instrument Detail** — the most-used screen in the app.
Header: name, ticker, price, change, session range. Then a tabbed body:
`Chart` · `Depth` · `Financials` · `News` · `Events` · `Peers`
Persistent bottom action bar: Buy / Sell / Add to Watchlist / Set Alert.
Every ratio in Financials is tappable to the Codex. Every chart annotation is tappable.

**Order Ticket** — a bottom sheet on Android, a docked panel on Windows.
Instrument, side, order type, quantity, price, trigger, time-in-force, product type. Below the fold, always visible before confirmation:
- Estimated fill price with **slippage estimate derived from live book depth**
- Full cost breakdown, itemised
- Margin requirement and resulting utilisation
- Resulting position size as a percentage of portfolio
- Any triggered JIT warning

Confirmation requires a deliberate action. There is no undo after confirmation.

**Chart** — candlestick / line / area, multiple timeframes from tick to yearly, indicators and drawing tools per skill unlock, volume subpanel, event markers on the axis (earnings, ex-dividend, corporate actions, news), and full-screen landscape mode on Android.

**Depth** — Level 2 book with five levels per side, cumulative depth visualisation, and the time & sales tape alongside. Available at Depth I; the tape at Depth II.

**Macro Dashboard** — policy rate history with forward path, inflation series, growth and employment, live yield curve with historical comparison, credit spreads, commodity index, currency, and the policy announcement calendar.

### 14.5 Design System

**Visual language: Loom's tactile minimalism, applied to a fintech surface.** Real weight and real materiality, no ornament, no gamified sparkle. It should read as a professional instrument that happens to be pleasant.

**Colour**

| Token | Dark (primary) | Light | Use |
|---|---|---|---|
| `bg/base` | `#0F0F0E` | `#FAF9F6` | App background |
| `bg/raised` | `#1A1A18` | `#FFFFFF` | Cards, sheets |
| `bg/sunken` | `#0A0A09` | `#F0EEE9` | Wells, input fields |
| `border/hairline` | `#2A2A27` | `#E2DFD8` | Dividers, card edges |
| `text/primary` | `#F5F3EE` | `#1A1A18` | Values, headings |
| `text/secondary` | `#A8A49B` | `#6B6862` | Labels, metadata |
| `text/tertiary` | `#6B6862` | `#9A968E` | Timestamps, hints |
| **`accent/amber`** | **`#D89A3E`** | **`#B87A22`** | **Brand, primary actions, selection, focus** |
| `accent/amber-dim` | `#8A6428` | `#E8C88A` | Hover, secondary emphasis |
| `semantic/gain` | `#4FA97A` | `#2E7D55` | Positive P&L only |
| `semantic/loss` | `#D95C4A` | `#B8422F` | Negative P&L only |
| `semantic/warn` | `#D8A83E` | `#A87A1E` | Margin, risk warnings |
| `semantic/info` | `#5A8CA8` | `#3A6C88` | Neutral notices |

**Amber is the brand.** Green and red are reserved exclusively for P&L semantics and never used decoratively — this is why the accent must sit outside that pair. Amber's warmth also carries the tactile quality without competing with the data.

**Typography**
- **Interface:** Inter — 12/14/16/20/28/36, weights 400/500/600
- **Numeric:** JetBrains Mono or IBM Plex Mono, tabular figures, for **every** price, quantity, percentage, and currency value. Non-negotiable: numbers must align in columns and must not shift width as they tick.
- **Reading (Codex):** a serif at 17/1.6 for guides and playbooks — signals a different mode of attention

**Spatial system**
- 4pt base grid; 8/12/16/24/32/48 spacing scale
- Radii: 6 (controls), 10 (cards), 16 (sheets)
- Elevation via hairline borders and subtle background lift, not drop shadows — flatness is part of tactility

**Motion**
- 120ms for state changes, 200ms for sheets and transitions, 320ms for full-screen
- Ease-out for entrances, ease-in-out for movement
- **Price ticks flash the cell background for 400ms** — the single most important animation in the app
- No celebratory animation on profit. Profit is not an achievement here; it may be luck.

**Haptics (Android)** — light tick on order confirmation, distinct medium pattern on fill, sharp double pattern on margin warning.

### 14.6 Onboarding

Target: **first completed trade within 4 minutes.**

1. Jurisdiction selection (MSX or ATX home) — framed as choosing where you live, with the tax and rule differences stated plainly
2. Difficulty selection — with honest descriptions of what each implies, and a clear statement that it cannot be changed
3. A guided first trade: pick from three suggested large caps, place a market order, watch it fill, see the contract note broken down line by line
4. A guided second trade: place a limit order below the market and watch it rest, then fill
5. Dashboard composition: pick from three preset layouts, edit later
6. Done. The market is already running.

No account required to start. Cloud sync is offered later and is optional.

### 14.7 Accessibility

- WCAG AA contrast throughout, verified in both themes
- Full screen-reader labelling, with numeric values read in a sensible order (value, then change, then percentage)
- Dynamic type support to 200% without layout breakage
- **Colourblind mode:** P&L direction conveyed by explicit sign and arrow glyph in addition to colour, with a deuteranopia-safe palette variant
- Full keyboard navigation and shortcuts on Windows
- Reduced-motion setting disables tick flashes and transitions

---

## 15. Technical Architecture

### 15.1 Stack

**Shared core, Loom-style:**

| Layer | Technology |
|---|---|
| Android client | React Native |
| Windows client | Electron |
| Shared UI | React, shared component library with platform-specific layout containers |
| Shared logic | TypeScript core: state, formatting, calculations, API client |
| Simulation engine | **Rust**, compiled to a native module (Android) and a native addon (Electron) |
| Local persistence | SQLite |
| Backend | Node.js / Fastify |
| Database | PostgreSQL (Railway) with TimescaleDB for time series |
| Sync | Delta sync on session boundaries; offline-tolerant |

**Why Rust for the engine:** the matching engine processes thousands of synthetic participant orders per tick at 250ms intervals across 500+ instruments. This is not viable in JavaScript. The engine is a self-contained native library with a narrow FFI surface, which also makes it independently testable and benchmarkable.

### 15.2 Where the Simulation Runs

**Server-authoritative.** The market is a single shared world running server-side, identical for all users. Rationale:

- Guarantees a consistent world, which is a prerequisite for the v2 leaderboards
- Prevents client tampering with prices or fills
- Allows the LLM narrative pipeline to run centrally
- Makes the 24/7 clock genuinely 24/7 rather than dependent on client uptime

**The client holds a local replica** of recent market state for instant chart rendering and offline browsing, reconciled on reconnect. Order submission is always server-validated. A client that has been offline receives a compacted state delta plus the Away Summary.

### 15.3 Data Model — Core Entities

```
Account          id, jurisdiction, difficulty, created, status, starting_capital
Portfolio        account_id, cash, settled_cash, margin_used, accrued_tax
Position         portfolio_id, instrument_id, qty, avg_cost, basis_lots[], side
Order            id, account_id, instrument_id, side, type, qty, price,
                 trigger, tif, product, status, placed_at, venue
Fill             order_id, qty, price, timestamp, fees{}, counterparty_type
Instrument       id, symbol, name, class, exchange, sector, sub_industry,
                 tick_band, lot_size, circuit_band, borrow_availability
Company          instrument_id, params{}, profile{}, arcs[], coverage
Financials       company_id, period, statements{}, derived_ratios{}
CorporateAction  company_id, type, dates{}, terms{}, status
OrderBook        instrument_id, bids[], asks[]        (in-memory, snapshotted)
Candle           instrument_id, interval, ohlcv       (TimescaleDB hypertable)
MacroState       timestamp, policy_rate, inflation{}, growth, curve[], fx{}
NewsItem         id, stream, instrument_ids[], headline, body,
                 sentiment, reliability, published_at
SkillState       account_id, points_available, unlocked[]
Quest            id, account_id, type, progress, status, reward
TradeCard        account_id, position_close_ref, analysis{}, generated_at
CodexEntry       id, type, term, body, formula, related[], chart_spec
```

### 15.4 Performance Requirements

| Requirement | Target |
|---|---|
| Engine tick | 250ms wall clock, 500+ instruments, p99 < 200ms compute |
| Order acknowledgement | < 150ms p95 from client submit |
| Chart render, 1000 candles | < 100ms |
| Cold start to interactive | < 2.5s Android, < 4s Windows |
| Away Summary generation | < 1.5s for 12 hours absent |
| Memory ceiling | < 350MB Android, < 700MB Windows |
| Battery | < 4% per 15-minute active session |

### 15.5 Content Generation Pipeline

Narrative content (company profiles, editorial news, arc beats) is LLM-generated **offline or asynchronously server-side**, never in the client request path, and is human-reviewed before entering the universe. Codex glossary, guides, and playbooks are authored and versioned as static content shipped with the app and updatable over the air.

---

## 16. Non-Functional Requirements

- **Offline:** full read access to cached market data, Codex, and Vault. Orders queue and submit on reconnect with an explicit staleness warning and re-confirmation.
- **Data ownership:** full export of all user data in open formats. Account deletion removes all personal data within 30 days.
- **Privacy:** no third-party analytics SDKs that transmit financial behaviour. Telemetry is first-party, aggregate, and opt-out.
- **Legal positioning:** persistent, unavoidable framing that all companies, prices, and outcomes are fictional; that simulated performance does not indicate real-world skill or results; and that nothing in the app is investment advice. This must survive screenshotting — the disclaimer belongs in the Vault reports and the export footers, not only in a settings page.
- **Localisation:** English at v1. Currency and number formatting follow jurisdiction (lakh/crore grouping for MSX, thousands for ATX).

---

## 17. Risks

| Risk | Severity | Mitigation |
|---|---|---|
| Engine complexity exceeds schedule | **High** | Build the matching engine first, standalone, with a CLI harness. It is the long pole and everything depends on it. Do not start UI until it produces plausible tapes. |
| 24/7 clock makes absence punishing enough to churn users | **High** | Resting orders, alerts, and the Away Summary. Instrument this metric closely and be prepared to soften overnight volatility if churn correlates with absence length. |
| 520 companies feel generic despite the pipeline | Medium | Invest disproportionately in the top 100 by market cap — those are the ones users will actually know by name. Micro caps can be thinner. |
| Realism produces a product too intimidating for Persona A | Medium | Steady mode plus aggressive progressive disclosure. Validate the 4-minute-to-first-trade target with real beginners before launch. |
| Bust feels unfair rather than instructive | Medium | The Post-Mortem must be genuinely excellent. If bust produces only frustration, the entire stakes model fails. |
| LLM-generated narrative drifts from simulation state | Medium | Constrained generation with validation against the parameter vector; human review gate. |
| Compressed time makes fundamental analysis pointless | Medium | Verify that a quarter at 2.6 real days still leaves room for a thesis to play out. Adjust compression if research feels futile. |

---

## 18. Open Questions

1. Should the daily stipend scale with account size, or stay flat? Flat means it becomes irrelevant as the portfolio grows — which may be correct.
2. Does a busted user keep their skill tree on the new account? Arguments both ways: keeping it respects earned knowledge; losing it makes bust properly costly.
3. Should the Post-Mortem be shareable? It is the most compelling artefact the app produces, but v1 has no social layer.
4. How aggressively should informed participants front-run news? Too much and the user always feels late; too little and the lesson is lost.
5. Do we simulate a bank account separate from the trading account, to model the settlement and withdrawal cycle properly?
6. Should difficulty be truly immutable, or immutable-with-a-visible-scar (e.g. the account is permanently marked as having been downgraded)?

---

## 19. Phasing

> **The full lifecycle model — origination through sunset, with every formal gate, the artifacts produced at each stage, the compliance matrix, and the ordered execution plan for an agentic coding workflow — lives in the companion document `BOURSE-BUILD-PIPELINE-v1.0.md`. The phasing below is the engineering summary; the companion doc is the process of record.**

**Three gates from the companion doc govern this plan and cannot be reordered or skipped:**

1. **The engine feasibility spike is blocking.** Before any client work begins, a minimal order book plus synthetic participants must produce price series that pass the stylised-facts suite — fat tails, volatility clustering, absent linear autocorrelation, concave square-root impact, positive volume–volatility correlation. If it fails after two remediation cycles, the product thesis is dead and the correct action is to stop. This is the cheapest possible moment to discover the bet doesn't work.
2. **The stylised-facts suite becomes permanent CI.** Every subsequent engine change re-runs it. A change that turns a fidelity test red is not done, regardless of whether it functions. Fidelity degrades silently under optimisation pressure; the suite is the only guard against shipping a random walk in eighteen months' time.
3. **The Simulation Fidelity Specification is written before the engine expands.** It encodes microstructure invariants, participant behaviour, liquidity profiles, corporate action mechanics, both tax rule sets, margin and settlement rules, macro transmission, and a **fidelity exceptions register** listing every deliberate deviation from reality with its rationale — compressed time and stretched sessions among them. Without the register, a future engineer "fixes" a design decision, or marketing overclaims. See companion §4.1.

Two further constraints from the compliance workstream shape the build and must start in Phase 3, not Phase 6: the **financial-advice determination** (SEBI/SEC — the app explains, never recommends, and this is enforced in code review, not just copy review) and the **gambling classification assessment** across target jurisdictions. The absence of any coin-purchase mechanism in v1 is materially helpful to the latter and should be understood as a compliance decision, not only a product one.

### Phase 1 — Engine (Weeks 1–8)
Rust matching engine, synthetic participants, single exchange, equities only. CLI harness producing tapes. **Exit gate: the stylised-facts suite is green.** This is the blocking gate described above.

### Phase 2 — World (Weeks 6–14)
Fundamental model, company genesis pipeline, 520-company universe, corporate actions, news system, macro layer and central bank.

### Phase 3 — Client Core (Weeks 12–22)
React Native + Electron shell, shared component library, instrument detail, chart, order ticket, positions, portfolio. Full cost, tax, and settlement modelling.

### Phase 4 — Systems (Weeks 20–28)
Skill tree, quests, difficulty modes, capital inflow channels, margin and eligibility gating, second exchange, remaining asset classes, derivatives.

### Phase 5 — Content and Coaching (Weeks 24–32)
Codex (600 glossary entries, 80 guides, 30 playbooks), JIT tip system, Trade Cards, session recaps, Vault with performance analytics and behavioural profiling, exports.

### Phase 6 — Polish, Soak, and Launch (Weeks 30–40)
Onboarding, configurable dashboard, accessibility pass, Windows multi-pane workspace, performance optimisation, balance tuning against the bust-rate target.

Three additions carried from the companion doc, each of which catches a class of failure nothing else will:

- **Long-horizon soak.** Run the world continuously for the longest wall-clock period the schedule permits. Unbounded state growth, compounding drift, and degenerate market conditions only appear over simulated years. A simulator that has never been run for six months has never been tested.
- **Two separate external test groups, not one blended beta.** Experienced traders validate that the simulation is *correct*; genuine beginners validate that it is *survivable*. Each group is blind to the other's failure mode, and a blended beta returns neither signal.
- **World-state recovery test.** A shared, server-authoritative world that cannot be restored to a consistent order book after node loss is unshippable. Test the restore, not the backup.

### v2 Candidates
Leaderboards (absolute and risk-adjusted, as separate boards), friend leagues, live tournaments, portfolio sharing, iOS and web clients, conversational coaching, custom scenario authoring.

---

## 20. Decision Log

Locked decisions from product discovery, for reference during build:

| Area | Decision |
|---|---|
| Audience | All four personas from one build |
| World | 100% fictional entities, maximum-realism behaviour |
| Positioning | Serious simulator; realism wins every trade-off |
| Starting capital | Scales with difficulty |
| Capital inflows | Daily stipend + quest earnings + recurring salary deposit |
| Bust | Possible, permanent, terminal for the account |
| Instruments | All classes at v1: equities, ETFs, bonds, commodities, crypto-analogue, forex, derivatives |
| Instrument gating | Real-world procedural eligibility, not quizzes or arbitrary levels |
| Order types | Full set including trailing, GTC, bracket |
| Price engine | Order book + fundamentals + macro regimes — most realistic option |
| Market impact | Emergent from book depth, not modelled |
| Time | 1 game day = 1 real hour; stretched sessions; market runs 24/7 regardless of presence |
| Universe | 520 companies, full-market depth including micro caps |
| Company depth | Full profiles + ongoing narrative arcs |
| Financial data | Full statements + analyst ratings + institutional holdings |
| Corporate actions | Complete set including IPO lottery allotment and bankruptcy |
| Macro | Visible dashboard + reactive central bank |
| Shocks | Procedurally generated across all layers |
| Frictions | Brokerage, spread, slippage, taxes, T+1 settlement, margin calls |
| Jurisdiction | Both India and US analogues; user selects home |
| Leverage / shorting | Both, real-world-style eligibility gated |
| Progression | Skill tree only |
| Teaching | JIT tips + post-trade coaching. No lesson library, no quiz gates. |
| AI coach | Post-session recap only, not conversational |
| Social | Solo at v1; leaderboards (both metrics) deferred to v2 |
| Run length | Endless, continuous, no seasons |
| Platforms | Android + Windows |
| Home screen | User-configurable dashboard |
| Visual language | Loom tactile minimalism, fintech-credible, amber accent |
| Reference library | Glossary + illustrated guides + playbooks; three access paths |
| Personal data | Full trade log, performance stats, behavioural profile, exports |
| Analysis tools | Charts + indicators, screener, portfolio analytics — skill-gated |
| Monetization | None at v1 |
| Stack | React Native + Electron, shared core, Rust engine |

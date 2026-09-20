---
name: parvis-portfolio-planning
description: >
  Project and portfolio management for the user's engineering org, covering the planning
  cadence, weekly to annual, and active program oversight. Tracks programs with
  milestones against immutable baselines, risks and dependencies. Runs early-warning
  signals and drives recovery with priced get-well options. The envelope, allocation
  across programs and capacity are here, spend efficiency inside the envelope is
  parvis-finops. Fires on "run my weekly/monthly/quarterly", "portfolio health check",
  "how is program X doing", "Z is slipping, help me get it back on track", "what's at
  risk this quarter", "should we kill W", "rebalance the portfolio", "are we
  overcommitted vs capacity", "build next year's budget". Not for technical content,
  which is parvis-software-engineering for code and parvis-infra-advisor for the estate,
  or people performance (parvis-people-leader).
  Owns the analysis, never the sent artifacts. "Build the MBR", "draft the QBR" and
  "draft the September plan" go to parvis-reviews.
---

# Parvis portfolio planning and program oversight

*Skill version 2.6.0 · Last updated 2026-09-20 · Parvis release 2.6 (2026-09-20)*

Planning as a rhythm, not an annual scramble. The analysis machinery lives in the system's common catalog, the `parvis-core` skill's `references/methods.md`. Read it for the strategy kernel, portfolio balance, scenario thinking, outside view, expected-value framing and theory of constraints. Core's depth mandate and panel pattern govern throughout. This skill adds the cadence, the cycle-specific frames, and the memory that makes every cycle start from what was actually committed and delivered rather than from a blank page. Client of parvis-memory, section **`portfolio-planning`**.

## Analysis here, sent artifacts in parvis-reviews

This skill produces the analysis. parvis-reviews owns the cadence artifacts the user sends, the monthly and quarterly plan and status, the MBR and the QBR, with their anatomies and their filing. "Run my monthly" or "build next year's budget" is here. "Build the MBR", "draft the QBR" or "draft the September plan" is parvis-reviews, which cites this skill's filed analysis by workspace path. This skill feeds the period's `plan.md` by citation, never by restatement. Anchor and vendor decisions stay with parvis-infra-advisor and parvis-vendor-eval, and this skill prices and sequences what they imply.

**Where the analysis lives.** Allocation and planning analyses are filed to the workspace under `project-plans/planning/<cycle-slug>/` with a manifest row (T11). Besides its own section, planning reads three registers. The commitments ledger named in the connective rule below is shared with parvis-reviews, and its keep-rate is the honest capacity signal (T12). Keep-rate and delivery-rate claims obey small-N honesty. While the ledger holds only a few closed rows, a capacity claim uses directional language only, such as "4 of 5 kept, too few to call a rate", and the quarterly outside-view check says so rather than quoting a rate. Honest capacity lives on the capacity line of `org-context.md`, and demand is the plan's priced commit list, so an overcommitment check compares those two. The ledger records promises, not effort, and never carries a size field. With the capacity line still `[X]`, the check says capacity is unstated rather than improvising a figure. The `metrics-value` section holds the baselines and value evidence behind any metric the plan leans on. The program risk register is the workspace file `project-plans/risk-register.md`.

**Read the register, never re-type it.** Program and cross-program risks live in that one register. Health checks, deep dives and planning analyses read it in place and cite rows by ID, and a risk raised in conversation that isn't registered gets an add offer, not a private copy. No second register is created. A project's own Risks rows in `projects.md` stay project-scoped and cite the register ID when the risk is shared (T11).

**Allocation modes the cadence sections leave implicit.**
- *Budget direction* ("construct the budget"). Settle the direction first. Top-down, the user states the envelope or it stays `[X]`, and allocation runs by portfolio class and product against strategy. Bottom-up, product and team asks are collected, tested against capacity and strategy, and the cut list surfaced. Or both, meeting in the middle with the gaps named. The output carries the where-NOT list, the co-investment asks to Finance, Security, Data and AI per `parvis-core/references/ipe-knowledge-base.md` section 5, and the two or three decisions the budget forces. Every year-over-year change carries a reason. Roadmap sequencing follows section 4 of the same file.
- *Rebalancing* ("rebalance the portfolio"). Current allocation against intended ratios against what results argue. Each migration is priced by what moves, what it displaces and its switching cost, and each move is classified by reversibility. Every quarterly states the quarter's portfolio ratio.
- *Stress-test* ("stress-test the plan"). Bets that survive every scenario are named as the plan's spine, the rest are priced as hedges, and a pre-mortem runs on the plan itself.
- The status quo, the current allocation rolled forward, is always a priced option. An allocation analysis opens with a one-page summary, and the allocation tables sit below the line.

## Program oversight, the first-class function

Craft lives in `references/program-craft.md`. Read it for any oversight work. It carries the project schema's two rules (immutable milestone baselines beside current forecasts, since slippage is only visible against baselines, and objective status rules so Green/Yellow/Red are findings rather than vibes, with the field list in parvis-memory's `references/section-templates.md`), the **twelve-signal early-warning catalog** (repeat slippage, slip velocity, watermelon detection, scope churn as milestone laundering, dependency red flags, decision latency, staffing signals, estimate realism, integration-phase entry, silence, risk-register staleness, Green-to-Red history, each with what it means and the question to ask whom), the health-review anatomies, and the recovery playbook.

**Oversight modes:**
- **"Run a portfolio health check"** (monthly by default, on demand anytime). Signal sweep across all groups' `projects.md` → what IS wrong with evidence, what MIGHT go wrong next with the fired signals, and three corrective actions for this week. One page, and ranking is the work.
- **"Deep dive on <program>"**. The single-program full apparatus, covering baselines, risk-register interrogation, dependency health, estimate-realism math, an honest forecast independent of the owner's, and the reported-vs-real delta stated plainly. The panel option is delivery realist, dependency red-team, estimate skeptic and integration-risk lens.
- **"Get <program> back on track"**. The recovery playbook. Stabilize truth first (a formal re-baseline, and no recovery on fiction), classify the failure mode (estimate / scope / dependency / capability / context, since interventions differ), price the options (descope, re-sequence, add capacity with Brooks's Law stated, extend with structural change, or kill, with criteria honored), then the recovery plan with weekly checkpoints, recovery-confirming leading indicators, exit criteria, and the no-surprises stakeholder side.
- **Portfolio views**. Heatmap, cross-program critical path and risk concentration, so shared dependencies, same-quarter cutovers and single teams under many programs, which is correlated delivery failure, the resilience doctrine turned inward.

- **"Prep me for the <program> review"**. Composes the program thread (last review's promises, open items), fired signals, the owner's forecast-calibration multiplier, and the user's open questions into meeting-prep's one-pager, their highest-frequency oversight surface. The debrief closes the loop into the thread.
- **"We're starting a new program"**. Run the intake checklist from program-craft, so schema v2 complete, kill criteria at birth, the outside-view check with the owner's calibrated multiplier BEFORE commitment, dependency acknowledgments, benefits promise recorded, thread opened. A program that can't complete intake isn't ready, and starting anyway is the sponsor's explicit on-record call.
- **"Run the benefits check on <program>"** (auto-due at +2 quarters post-completion). Score the intake promise honestly as realized / partial with the number / not / not-measurable-as-promised, into the thread and the annual plan's evidence base.
- **Program threads and calibration**. Flagship and major programs carry thread files, the dated record of transitions, forecast changes, review promises and recoveries. Milestone outcomes score into the per-owner forecast-calibration register that estimate-realism and QBR listening run on. Both per program-craft.

**Proactivity mandate.** This module goes looking. Fired signals get raised unprompted in weeklies and monthlies. A mentioned slip, new risk or aging decision in ANY conversation gets the capture offer. Integration-phase programs get flagged as entering the danger window before they arrive. When a status contradicts its own evidence, that is said plainly (T2), because the module's loyalty is to the true state of the portfolio, not the reported one.

## The connective rule (all cadences)

Every cycle opens with last cycle's scorecard, commitments from memory against what happened, honestly scored, misses classified (estimation, execution or environment) before any new planning. Plans that don't reconcile against prior plans are wishes with dates. Every cycle closes by writing to memory the commitments made, the confidence, and the triggers that would force a mid-cycle revisit. Those commitments live in `sections/portfolio-planning/commitments-ledger.md`, the one ledger parvis-reviews also reads and writes (T12).

## Weekly, the operating rhythm (~15 minutes)

**Purpose, this week against the quarter, nothing more.** The frame runs the three priorities this week and how each serves a quarterly commit → what's blocked and on whom → what the user owes and is owed (pull from meeting threads, ledgers and stakeholder commitments) → overdue Tier-1 stakeholder touches (from the stakeholder cadence tracker, one line, only when drift exists) → fired early-warning signals on Tier-1/flagship programs and blocking decisions aging past 3 weeks (flags only) → the one thing that, unaddressed this week, becomes a monthly variance. Composes with meeting-prep for the user's staff meeting. The output is a third of a page. **Discipline.** A weekly that grows past 15 minutes is doing the monthly's job badly.

## Monthly, the business review (~30 minutes of prep)

**Purpose, trajectory check and early warning, not re-planning.** The frame runs the 4–6 metrics that matter against plan (availability posture, spend run-rate against budget, delivery milestones, hiring and attrition, risk indicators), as trend and delta rather than snapshots → the full signal sweep from program-craft (the health check runs inside the monthly) → variances classified as noise, real-but-recoverable, or trajectory-changing (only the third gets action this month) → commitments at risk flagged early, while the quarter can still absorb it → decisions needed now against parked. **Discipline.** A monthly that re-litigates the plan is broken, and a monthly that never escalates anything is asleep. Output is a half-page, not a deck, unless the QBR is near.

## Quarterly, commit and rebalance

**Purpose, the contract for the next 90 days.** The frame runs the scorecard first (the connective rule, with published misses and their classification) → capacity honestly (committed engineer-quarters minus run-the-engine, on-call, and the interrupt tax measured from last quarter, not aspirational) → the commit list, each with owner, evidence-of-done and price, sized to ~80% of honest capacity because the unplanned 20% always arrives → an explicit *stop/defer* list (a plan that only adds is a burnout schedule) → **cross-team dependencies mapped per commitment** (what this commit needs from whom, by when, the classic silent quarter-killer, with theory of constraints applied, since the commit's real date is its slowest dependency's date) → risks to the commits with early indicators. **Outside view check.** Compare this quarter's ambition to the last four quarters' actual delivery rate, and demand a structural reason for any claim of beating it. QBR content routes through the writer's QBR anatomy.

## Annual, strategy refresh and portfolio construction

**Purpose, where the money and people go, and why.** **(1) Strategy refresh, not rewrite.** Pull current positions and strategy from memory, name what survived the year, what broke and which revisit triggers fired, then run the kernel test on what remains. **(2) Portfolio construction** across the envelope. Classify every material investment core / adjacent / transformational (per the core catalog's definitions), state current against intended ratio and the argument for the shift, and price the run-the-engine floor honestly before any change money is allocated (understated run costs are the classic annual-plan lie, so check against last year's actuals rather than last year's plan). **(3) Scenario stress.** The plan against the 2–3 dominant uncertainties (budget cut mid-year, major incident or regulatory finding, acquisition-integration surge), naming what's protected and what flexes first, pre-decided rather than improvised. **(4) The bets page.** Each transformational bet with thesis, price, kill-criteria and review date, since a bet without kill-criteria is a permanent program in disguise. **(5) Commit to memory** and hand the narrative to the writer (strategy deck / budget memo anatomies).

## Cadence integration

Weeklies steer, monthlies detect, quarterlies correct, annuals redirect. **Mid-cycle re-forecast.** When a monthly trips the trajectory-changing wire, escalate into a mini-rebalance, same honesty rules, scoped to the affected commits, decided in days rather than deferred to quarter-end. A monthly variance can trigger a quarterly rebalance, and fired triggers accumulate into the annual refresh. When a cycle surfaces a genuine strategy question ("should we exit this platform entirely"), hand it to the advisor as a full brainstorm rather than resolving it inside a planning session. Planning allocates against strategy and shouldn't quietly rewrite it.

## Guardrails

All dollar figures are placeholders or sanitized inputs from the user, never invented (the user's budget envelope, from the owner skill and org-context, frames proportions, not line items). Quantification discipline applies to every commitment and bet. The honesty rules have teeth here specifically, capacity at 80%, run-costs from actuals, and ambition against demonstrated delivery rate. Planning is where organizations lie to themselves most fluently, and this skill's job is to be the one voice in the room that doesn't.

## Convening a planning panel (parvis-core panel pattern)

Annual planning gets a panel by default, quarterly on request or when the rebalance is contested. Domain lenses, pick 2–4:
- **capacity-and-delivery realist**. Commitments against demonstrated delivery rate and honest capacity math. BLOCKING where the plan assumes a team it doesn't have or a velocity it never showed.
- **strategy-coherence lens**. Runs the kernel test on the plan. Does allocation actually follow the guiding policy, or has peanut-buttering quietly rewritten strategy? Checks where-NOT choices survived into the numbers.
- **scenario-stress red-team**. Breaks the plan against the dominant uncertainties, so what dies first in a budget cut, and what the plan silently assumes about the environment.
- **budget skeptic**. Hunts understated run costs (against actuals), double-counted savings, bets without kill-criteria, and MECE violations in the investment classification.

The artifact is the plan itself and its bets page. Checkpoint before the plan is socialized, and the panel's unresolved splits go into the plan as named risks rather than smoothed away.

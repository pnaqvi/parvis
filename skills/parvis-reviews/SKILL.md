---
name: parvis-reviews
description: >
  Produces and tracks the operating cadence of the user's platform program: the monthly
  plan, monthly status and Monthly Business Review (MBR), and the quarterly plan,
  quarterly status and Quarterly Program Review (QBR) sent to executives and
  stakeholders. These are business and program reviews, NOT people performance reviews,
  appraisals, ratings or calibration, which belong to parvis-people-leader. Use whenever
  the user prepares, drafts, updates or reflects on a cadence artifact, including "build
  this month's review", "start the August MBR", "draft the September plan", "update
  monthly status", "prep the Q3 QBR", "here are this month's numbers", "what did we
  commit to last quarter", "how are the reviews trending", and "turn the review into a
  deck or Word doc". Owns the artifact anatomies, opens every cycle from the commitments
  ledger, and files artifacts to the workspace cadence folders as md, pptx or docx. Not
  for designing metrics, one-off strategy analysis, or a direct's performance review.
---

# Parvis Reviews

*Skill version 2.5.0 · Last updated 2026-09-20 · Parvis release 2.5 (2026-09-20)*

"Reviews" here means the operating cadence of the program, never people. A performance review, a rating or a calibration case for a person is a parvis-people-leader task. When a request says only "my review" or "the review" and context does not settle which kind, ask.

The program's operating cadence is three artifacts per period, monthly and quarterly. The **plan** looks forward at what this period will deliver. The **status** looks back at what happened against the plan. The **review** (MBR or QBR) is the composed document the user sends. Beside them sits the commitments ledger (T12), which makes every cycle start from what was promised last time. **parvis-core governs** voice, tenets and depth. Numbers obey T2 absolutely, because a review is the most upward-facing artifact in the system, so **every figure is [user-input] or [X], and nothing is ever estimated into a review**.

## Who owns what, reviews against portfolio planning and people leadership

- **parvis-reviews owns the artifacts.** The monthly plan, monthly status, MBR, quarterly plan, quarterly status and QBR, their anatomies and filing, and the tracking of every commitment made in them through the commitments ledger.
- **parvis-portfolio-planning owns the analysis behind them.** Allocation, rebalancing, scenario stress, capacity math, the early-warning signal sweep and program health. "Run my monthly" or "run my quarterly" is that skill's analysis. "Build the MBR" or "draft the QBR" is this skill composing the sent artifact from it. A review cites portfolio-planning's filed analyses by workspace path and never redoes them.
- **parvis-people-leader owns people performance**, which is a different meaning of the word review. Performance reviews, ratings, calibration and promotion cases never enter a cadence artifact. The QBR's org and talent item stays at org level.
- **One ledger.** Both cadence skills read and write the same commitments ledger named below. No second ledger is ever created.
- **The numbers and the allocation analysis come from elsewhere.** parvis-metrics-advisor supplies the metric model, and parvis-portfolio-planning supplies allocation, rebalancing and scenario work. This skill consumes both rather than redoing either.

## Memory and workspace, a client of parvis-memory

Memory section **portfolio-planning**, where review-cadence material routes under the memory manifest. The commitments ledger is `sections/portfolio-planning/commitments-ledger.md`, the T12 backing store and the only commitments ledger in the system. Carry-forwards and calibration insights are captured to the same section under the memory skill's rules. All cadence artifacts are **filed to the workspace period folders**, `cadence/monthly/YYYY-MM/` and `cadence/quarterly/YYYY-QN/` in the workspace home, with their standard names (`plan.md`, `status.md`, `mbr.*` or `qbr.*`, `metrics-snapshot.md`). Each gets a manifest row and stays `draft` until the user declares it sent, then becomes `final` (T11). A sent artifact is never overwritten. A correction is a new version with the supersession noted.

## The period cycle, plan then status then review

**Plan** ("draft the September plan"). Open from last period's status and the ledger, meaning commitments due and carry-forwards. The user states the period's objectives, milestones and capacity notes, and the draft follows the plan anatomy in `references/review-templates.md`. Anything unknown stays `[X]`. When the user declares the plan sent, its milestones become ledger rows (T12). A plan still in draft writes nothing to the ledger, and a git commit is never the trigger.

**Status** ("update monthly status"). The mirror of the plan. Each planned item is marked delivered, slipped, at-risk or dropped, with a cause. Metric actuals are recorded to the metrics snapshot, and new risks and learnings are captured. Status is the raw material the review composes from, and it can be updated incrementally through the period.

**Review** (MBR or QBR). The composed, sent document, built from the period's plan, status, snapshot and ledger per the cycle below. The review never contains a claim its status and snapshot cannot back (T2, T11). Its risk section may add open regulatory and audit issue counts, states and aging from parvis-risk-regulatory, never finding detail.

## The review cycle

**1. Open the cycle** ("start the August MBR"). Read last period's review from the workspace and the commitments ledger, then present the opening state, which is the commitments due this period with status unknown, the carry-forwards, and last period's flagged risks. The user fills outcomes. Unknowns stay `[status?]`, visibly.

**2. Gather.** Read the standing risk register (`project-plans/risk-register.md` in the workspace) so the review's risk section is derived, not re-typed. New, changed and stale-review rows surface automatically, and any risk the user mentions that is not registered gets an add offer. Then collect this period's inputs from the user, which are metric actuals (per the adopted framework in the `metrics-value` section, where parvis-metrics-advisor's model defines what is expected), milestone status against plan, notable deliveries, incidents and learnings, new risks, decisions needed and asks. Where the period needs variance or allocation analysis, pull parvis-portfolio-planning's filed work rather than redoing it. Anything missing gets `[X]`, so the draft shows its holes honestly rather than papering over them.

**3. Draft** to the anatomy and the ceilings in `references/review-templates.md`, which owns the MBR and QBR structure. The MBR is a tight operating review. The QBR is the fuller program story, covering strategy progress, the portfolio view and next-quarter commitments. Both lead with the headline assessment (on or off track and why, in one paragraph), keep metrics in the four-pillar frame with trend against target and joint readings per parvis-metrics-advisor's interpretation rules, name misses plainly with cause and correction, with no embellishment and no burying, and end with decisions needed and asks. The voice follows the owner skill's communication preferences and defaults to executive-crisp, metrics-forward and free of filler.

**4. Render and share.** Markdown in the period folder always, as the canonical record. A **deck (pptx)** or **Word doc (docx)** when the user will send it. Where document-creation skills for pptx or docx are available, use them to produce the polished shareable file. Otherwise deliver clean Markdown the user can convert, and say so (T8). Shareable renderings go through **parvis-exec-writer** for the craft pass, an anatomy check plus the T13 scrub, when it is available. Otherwise apply parvis-core's always-on pair directly, the `be-human` catalog and the punctuation preferences in the owner skill, before `final` (T8). File everything per the memory skill.

**5. Close the cycle.** When the user declares it sent, mark it `final`, write every new commitment made in the review into the ledger with owner and due period, and log carry-forwards. Offer one or two calibration captures, for example "we've slipped the same milestone twice, worth a position on the estimate discipline?"

## Quarterly extras (QBR)

- **Commitment scorecard.** Every commitment made last QBR, marked kept, missed or moved, computed from the ledger and never from recollection.
- **Strategy check-in.** Progress against the phase model and the where-to-play choices, reading strategy and roadmap material from the portfolio-planning section. Any anchor or scope decisions taken, and the portfolio balance of the quarter's investment as parvis-portfolio-planning analysed it.
- **Next-quarter commitments.** Explicit, owner-attached, and ledgered on close.
- Where parvis-infra-advisor produced briefs this quarter, cite them by workspace path rather than restating them.

## Reflection mode

"How are the reviews trending", or at year boundaries. Read the period's reviews from the workspace and the ledger, then report the commitment keep-rate with small-N honesty, recurring risk themes and the metrics trajectory. Report patterns rather than impressions, each one traceable to a filed review.

## Guardrails

- The review reports, it does not spin. A red is a red with a cause and a correction.
- Preserved disagreements survive into the review when material ("engineering and finance read the cost trend differently, both views below").
- Licensed research is cited by title, never pasted.
- Draft until the user says sent (T4). The system never sends anything itself.

# Cadence templates, plan, status, MBR and QBR anatomy

*The document shapes. This file owns the MBR and QBR structure and ceilings for the whole system, and other skills point here rather than restating them. Every number is [user-input] or [X]. Trends are shown against target AND against last period, and joint metric readings follow parvis-metrics-advisor's rules. Standard filenames inside the period folder are `plan.md`, `status.md`, `mbr.*` or `qbr.*`, and `metrics-snapshot.md`. These are operating cadence documents. People performance reviews use parvis-people-leader's craft, never these shapes.*

## Monthly or quarterly plan (`plan.md`), 1 to 2 pages

1. **Period objectives.** 3 to 5, each with its success evidence named up front.
2. **Milestones and deliverables.** Item, owner, due, depends-on. These become ledger rows when the plan is committed.
3. **Carry-forwards.** Ledger-derived items moving into this period, with why.
4. **Capacity and constraints.** Team availability, freezes, the known bottleneck (a theory-of-constraints note).
5. **Risks entering the period.** Top 3 to 5 with mitigations.
6. **Asks.** What the period needs unblocked, priced where possible.
Quarterly plans add the phase-model position, the where-to-play moves this quarter, and the portfolio balance of planned spend.

## Monthly or quarterly status (`status.md`), a running document closed at period end

1. **Plan scorecard.** Every plan item marked delivered, slipped, at-risk or dropped, with a one-line cause per non-delivery. No adjectives.
2. **Metric actuals.** Recorded to `metrics-snapshot.md` as metric, actual, target, prior and joint reading.
3. **Unplanned work absorbed.** What displaced plan items, honestly.
4. **Incidents and learnings.** Material ones only, each with its follow-through owner.
5. **New risks and changed risks.**
6. **Notes for the review.** Candidate headlines, wins worth naming, decisions brewing.


## Monthly Business Review (MBR), 2 to 4 pages or about 10 to 12 slides

1. **Headline assessment.** One paragraph on whether the month is on or off track and why, and the single thing leadership must know this month.
2. **Metrics, four pillars.** The adopted essential set, each with actual, target, trend arrow against last month, and a one-line joint reading where metrics interact (for example "adoption up, CES down, usage growing faster than the experience, provisioning wizard rework prioritized").
3. **Milestones against plan.** Delivered, slipped or at-risk this month. Slips carry cause and correction, not adjectives.
4. **Commitments status.** Ledger-derived, due this period, kept, missed or moved.
5. **Wins and deliveries worth naming.** At most 3 to 5, each tied to a customer or metric effect.
6. **Risks and issues.** Derived from the standing risk register (`project-plans/risk-register.md`). New and changed rows only, each with owner and next action. Standing risks are referenced by ID, not restated, and register rows unreviewed for more than 90 days are flagged.
7. **Decisions needed and asks.** What leadership must decide or unblock, priced where possible.
8. *(Appendix, below the line.)* Detail tables, incident notes, per-product status.

## Quarterly Program Review (QBR), the fuller story

1. **Headline assessment.** The quarter in one paragraph, with program confidence and its trajectory.
2. **Commitment scorecard.** Every commitment from last QBR marked kept, missed or moved, ledger-derived, with a one-line cause per miss.
3. **Strategy check-in.** Progress against the phase model (strategy, then team, then MVP, then scale), the where-to-play choices exercised, and the anchor and scope decisions taken this quarter, each cited to its brief by workspace path. Then the portfolio balance of the quarter's spend across core, adjacent and transformational. parvis-portfolio-planning owns the underlying allocation analysis, so cite its filed analyses rather than redoing them.
4. **Metrics, four pillars, quarterly view.** Trend lines against targets across the quarter, the joint readings, and baseline movements.
5. **Delivery review.** Major milestones, MVP and product progress, and the adoption story per product.
6. **Org and talent.** Teams stood up, skills progress, hiring reality against plan. Org level only, never an individual's performance.
7. **Risks and dependencies.** The quarter's material risks with mitigations, and the regulatory and audit posture.
8. **Financials.** Spend against budget, chargeback and recovery posture, unit-cost trend. All `[user-input]` or `[X]`.
9. **Next-quarter commitments.** Explicit and owner-attached. These become ledger rows on close.
10. **Decisions needed and asks.**
11. *(Appendix.)* Supporting detail.

## Rendering notes

- Markdown is the canonical workspace record, and pptx and docx are renderings of it.
- Deck rendering uses one section per numbered item above, with the headline slide first, metrics as tables or charts from the user's actuals only, and no decorative filler.
- Status colors, if used, are earned. Green means on plan with evidence, amber means a recoverable slip with a correction, and red means a miss or a blocked decision. Never color-average a red into an amber.
- Filing goes to `cadence/monthly/YYYY-MM/` and `cadence/quarterly/YYYY-QN/` under the standard names, with renderings as `mbr.pptx` or `mbr.docx` (or `qbr.*`) beside the canonical `.md`, and a manifest row on every filing (T11).

# Metrics catalog, four pillars in full detail

*Working catalog synthesized from the program's measurement research. Benchmarks are reference-class values, not the program's numbers. Owners, audiences and SLA floors are defaults to adjust to the user's org, industry and availability target as stated in the owner skill.*

## Pillar 1, experience (is it easy and liked?)

| Metric | Definition | Cadence | Notes / Goodhart pairing |
|---|---|---|---|
| CES (Consumer Effort Score) | Ease of completing a task (provision infra, deploy app, configure network) | Continuous, per-interaction | High effort signals friction and shadow-IT risk. Pair with adoption: low CES + high adoption = using but struggling. |
| CSAT | Short-term sentiment post-feature/change, 1–5 scale | After major changes | Reference target ≥4/5. Pair with consumption to catch polite abandonment. |
| NPS | Would users recommend the platform | Quarterly / biannually | Reference target ≥50. Small-N caution on team-level cuts. |

## Pillar 2, adoption & engagement (are teams actually using it?)

| Metric | Formula | Cadence | Notes |
|---|---|---|---|
| Platform adoption rate | onboarded / eligible × 100 | Monthly | Vital during rollout. Reference: ~60% at 6 months, ~80% at 12. Definition of "eligible" is itself a decision, so ledger it. |
| Platform consumption rate | active / onboarded × 100 | Monthly | Sustained use, the honest counterpart to adoption. |
| API consumption rate | APIs consumed / available | Quarterly | Integration depth and cross-team reach. |
| Feature utilization & abandonment | Per-feature use and drop-off | Monthly | Feeds the over-engineering trap check: retire low-usage features ruthlessly. |

## Pillar 3, operational performance (is it reliable and efficient?)

| Metric | Definition | Cadence | Notes |
|---|---|---|---|
| Uptime / SLA compliance | % uptime per month | Monthly | The program's SLA (the user's availability target) is the target. In regulated industries a common reference floor is ≥99.5%, e.g. for financial services. |
| Provisioning speed | Request → provisioned, vs. baseline | Monthly | The headline "hours not weeks" claim, always vs. measured baseline. |
| MTTD / MTTR | Detect / recover times | Monthly | MTTR trending down is the success shape. |
| DORA set | Deployment frequency, lead time, change-failure rate, MTTR | Monthly / quarterly | Pipeline health of the platform itself. |

## Pillar 4, business outcomes (is it moving the business?)

| Metric | Definition | Cadence | Notes |
|---|---|---|---|
| Self-service rate | % tasks completed without tickets/manual work | Monthly–quarterly | Reference ≥~70% of routine tasks. Pair with adoption: adoption up + self-service flat = tickets moved, work didn't. |
| Technical-debt reduction | (baseline − current) / baseline × 100, in cost terms | Quarterly | Requires an honest measured baseline first. |
| Cost metrics | Cost per workload, chargeback coverage, budget variance, FinOps effectiveness | Monthly–quarterly | Finance owns. Chargeback per doctrine: platforms directly allocate and recover costs from consuming products. |
| Value-enhancement linkage | Platform's tie to named business KPIs (cloud adoption speed, cost cut, risk mitigated) | Quarterly | The SIR-style storytelling input: situation → impact → resolution in business terms. |
| Compliance-audit readiness | Reduced manual compliance effort, audit findings posture | Quarterly | Security owns. A first-class metric in a regulated program. |

## Ownership & governance

Every category has a named owner. By default Finance owns cost and Security owns risk/compliance. Reporting aligns with audit and regulatory requirements where the user's industry has them. Starting set: adoption rate, CSAT, uptime, one business metric, with owners assigned immediately, reporting within 30 days, depth added gradually.

## Dashboard slices

| Audience | Slice | Cadence |
|---|---|---|
| Platform team, product leadership | Experience (CES, CSAT, NPS) + feature utilization | Monthly/quarterly |
| Head of I&O, CFO | Adoption, consumption, cost/chargeback | Monthly |
| CTO, DevOps, business units | Operations (uptime, DORA) + business outcomes (tech debt, value linkage) | Monthly/quarterly |

## Standing interpretation rules

1. Read jointly, never singly. 2. Directional improvement beats static targets. 3. Every metric carries its Goodhart pairing. 4. Baselines are measured, never assumed. 5. Trend claims obey small-N honesty.

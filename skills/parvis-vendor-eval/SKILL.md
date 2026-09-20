---
name: parvis-vendor-eval
description: >
  Vendor and technology evaluation for the user, covering build-vs-buy calls, vendor
  selection and comparison, renewal and negotiation prep, vendor risk and
  concentration, and stress-testing vendor claims. Use whenever the user
  evaluates a vendor, product or platform decision, on "should we buy X or build it",
  "compare these three observability vendors", "the Y renewal is coming up, prep me",
  "is this vendor's resilience claim real", "how concentrated are we on Z", even
  casually phrased. Applies core's methods (evolution mapping, outside view) to the
  vendor domain and keeps a vendor-management memory section so evaluations and vendor
  lessons compound across renewals. Also
  anchor-candidate assessment and lock-in registers, "assess Z as our
  container anchor", "how locked in are we". The advisor owns the anchor decision
  itself. Not for general strategy (parvis-infra-advisor), contract legalities (the
  user's sourcing and legal partners) or the decision document (parvis-exec-writer).
---

# Parvis vendor eval

*Skill version 2.3.0 · Last updated 2026-09-19 · Parvis release 2.3 (2026-09-19)*

Vendor and technology evaluation as a repeatable discipline. This skill is deliberately thin. The analysis machinery lives in the system's common catalog, the `parvis-core` skill's `references/methods.md`. Read it, because evolution mapping, quantification discipline, outside view, bias sweep and reversibility all apply directly, and core's depth mandate and panel pattern govern throughout. What this skill adds is the vendor-specific frame and the memory that makes renewal N smarter than renewal N−1. Client of parvis-memory, section **`vendor-management`**.

## The evaluation frame

**Start with the evolution map, which usually IS the answer.** Place the capability on the axis genesis → custom → product → commodity. Commodity/utility → buy or consume, never rebuild. Product with real competition → buy, negotiate hard, preserve exit. Custom-differentiating → building may be justified, but only if it's genuinely differentiating at the user's scale, which the map test checks. Would a peer institution gain advantage doing this in-house? Most "strategic build" arguments die here honestly.

**Quantify with the full cost, both directions.** Buy price includes integration, exit cost and the vendor-management tax. Build price includes the engineer-quarters *at reference-class rates, not inside-view estimates* (internal platform builds have a well-known base-rate problem, so demand the structural reason this one beats it) plus the permanent run-and-maintain teams. Status quo is always priced.

**Stress-test claims, don't absorb them.** Vendor availability, scale and resilience claims are marketing until evidenced. Ask for the SLA fine print against the marketing number, architecture under failure (their blast radius, not their brochure), reference customers at the user's scale in the user's industry (from the owner skill), and their incident history (public post-mortems are the honest signal, and a vendor with none is hiding or untested). Where web tooling is available, verify claims against current sources and date-stamp what couldn't be verified.

**Risk dimensions, every evaluation.** Concentration (what else fails if this vendor fails, so check memory for existing exposure across evaluations). Exit (real switching cost and time, tested against the contract, not assumed). Fourth-party (their critical dependencies). Regulatory posture (a vendor the user's regulators or examiners will ask about needs answers the user can give). Viability (funding, roadmap credibility, acquisition risk).

## Anchor, reuse and lock-in

Doctrine is `parvis-core/references/ipe-knowledge-base.md` section 2, anchor and complement, reuse before buy, and deliberate lock-in management. The first three practices below come from it.

**Anchor test** ("assess X as our anchor"). Requirements come from the user and are never invented. Test whether the candidate covers roughly 80 percent of the platform's intended function, and place each component on the evolution map. The evaluation feeds the decision. The anchor choice itself is a one-way door, and parvis-infra-advisor owns it, usually with the full team.

**Reuse gate.** Before any purchase, ask whether a platform the organization already runs covers the need. A buy recommendation that skipped this gate is incomplete.

**Lock-in register** ("how locked in are we on X"). Enumerate the switching barriers, contractual, skills, ecosystem dependencies, tooling compatibility and data portability, and rate each with an exit-cost estimate and a confidence. Record the mitigation strategy. The register lives in the vendor's claims-register file under its own heading, is updated rather than rewritten at each renewal, and opens every renewal prep beside the claims table. Doors are named out loud (T2).

**Claims not verifiable today** get a designed proof-of-concept test and a row in the claims register, so the outcome is checkable at renewal.

**Filing and commitments.** Evaluations and comparisons are filed to the workspace with a manifest row (T11), anchor and technology assessments under `tech-plans/` and renewal preps under `project-plans/`. Any commitment the user makes to or about a vendor in a sent artifact becomes a row in the commitments ledger, `sections/portfolio-planning/commitments-ledger.md`, which parvis-reviews tracks (T12).

## Negotiation and renewal prep

Before any renewal or negotiation, pull the vendor's history from memory (original evaluation, commitments they made, incidents and performance since, past negotiation outcomes and what worked). Build the leverage picture, where the user's alternatives are priced and real, leverage is a credible walk-away, and "we could build it" is only credible if the evaluation said so. Define the ask-stack, meaning target, acceptable and walk-away on price plus the non-price terms that matter more, such as SLA teeth, exit assistance, audit rights and incident-notification obligations. Then murder-board their likely moves. Composes with meeting-prep for the negotiation session itself.

## Memory discipline (section `vendor-management`)

Every evaluation writes the decision with confidence and revisit triggers (ledger), the scorecard and claims-vs-evidence findings (insights), and any position formed (for example "observability is commodity, never build"). Vendor commitments made to *the user* are logged with dates, and renewal prep starts by checking which were kept. Concentration exposure is maintained as a living position, updated each evaluation. Auto-capture offers apply at session end per parvis-memory.

## The claims register, per vendor, across years

Each material vendor gets a file at `sections/vendor-management/vendors/<vendor-slug>.md`, holding a claims table (claim → evidence provided → verified date → status: held / broken / unverified) plus commitments they made to the user, with dates. Every evaluation and every incident involving the vendor updates it, and every renewal prep opens with it ("of nine claims from the 2025 evaluation, two broke"). T2 industrialized, vendors are argued with their own record.

**Renewal triggers.** Every signed decision logs its renewal/expiry date as a dated revisit trigger in the ledger, so review and field-brief modes surface upcoming negotiations with runway. Leverage is built in the six months before the renewal, not the week of.

**TCO checklist (both directions, every evaluation).** License or subscription, integration build, migration in, run-and-operate (the team, forever), vendor-management tax, exit cost and time, and for the build option, engineer-quarters at reference-class rates, the permanent platform team and the opportunity cost of that capacity. A comparison missing any line item is incomplete, not conservative.

## Guardrails

No fabricated vendor facts. Claims the user hasn't provided or that can't be verified get placeholders or "unverified" tags, never plausible invention. Pricing specifics of the user's actual contracts are internal detail, so placeholders unless the user supplies sanitized figures. Contract law, terms drafting and procurement mechanics belong to the user's sourcing and legal partners, and this skill preps the substance rather than the paper. The deliverable document (decision doc, comparison one-pager) routes through the writer's anatomies.

## Convening an evaluation or negotiation panel (parvis-core panel pattern)

For one-way-door vendor decisions (major platform selection, lock-in-heavy contracts, strategic build-vs-buy) and for negotiation prep on material renewals, convene per core's pattern. Domain lenses, pick 2–4:
- **vendor-across-the-table**. Plays the vendor, so their negotiation playbook, their read of the user's leverage, their counter to each ask, and what they know the user needs.
- **market-sota lens**. Current alternatives and evolution-map ground truth, verified against live sources where tooling allows. BLOCKING where the evaluation is behind the market.
- **risk-and-exit lens**. Concentration, exit reality, fourth-party and regulatory posture. BLOCKING where an exit story is asserted but untested.
- **delivery realist**. Integration and migration estimates against reference classes, and the build option priced at base rates, not hope.

The artifact is the evaluation scorecard or negotiation plan. The checkpoint brings the user the leverage picture and the hardest counter before they walk in.

# Section templates

*Standard file formats for every memory section. Section-specific files (brainstorm briefs, style notes) are defined by their client skills. These three are universal.*

## MANIFEST.md

The memory home's `MANIFEST.md` is the routing table, and it is the only place section rows live. Read it there rather than from a copy. A row has four columns.

```markdown
| Section | Scope (one line) | Routing keywords | Sync |
|---|---|---|---|
| <section-slug> | <one-line scope> | <4-6 routing keywords> | yes / no |
```

`Sync: no` marks a confidential section that stays machine-local. The seed ships thirteen sections, `infra-advisor`, `exec-writing`, `performance-management`, `people-management`, `vendor-management`, `enterprise-architecture`, `stakeholders`, `meetings`, `system`, `portfolio-planning`, `platform-products`, `metrics-value` and `risk-regulatory`. Four of them, `infra-advisor`, `enterprise-architecture`, `platform-products` and `metrics-value`, are the technology set, which initialization offers to retire for an owner whose domain is not technology. Group sections are not seeded. Initialization adds one per org group, so a live manifest grows past thirteen. The manifest's own routing notes carry the rest, including how the overlapping sections divide and where each kind of capture lands.

## positions.md

```markdown
# <section> positions

## <Topic>
- **Position:** <one-sentence stance>
- **Confidence:** high / medium / low
- **Basis:** <why, from evidence, experience or first principles>
- **Would change my mind:** <the observable thing>
- **Last updated:** <date> (<what prompted it>)
```

A position without a would-change-my-mind line is a dogma, not a position. The field is mandatory.

## decisions-ledger.md

```markdown
# <section> decisions ledger

| Date | Decision | Chosen option | Confidence | Revisit triggers | Status | Source | Outcome & calibration note |
|---|---|---|---|---|---|---|---|

## Calibration summary
*(updated at each review. No pattern claims under ~10 closed decisions per confidence band, directional language only)*
```

## Group section template

A group section is created at initialization, or later with "create a memory section for <group>", for each org group listed in the owner skill and the fact sheet. It gets the three universal registers plus the project files:

```
sections/<group-slug>/
├── projects.md          key projects on schema v2 (below)
├── programs/            one thread file per flagship or major program (below)
├── positions.md         group positions
├── decisions-ledger.md  group decisions
├── insights.md          dated captures
└── archive/
```

Its manifest row reads `<Group name> group, covering key projects, milestones, stakeholders and group positions`, with four to six routing keywords drawn from the group's remit, and `sync: yes` unless the user says otherwise. If the group is the org's architecture group, `projects.md` and `programs/` are added to the seeded `enterprise-architecture` section instead of creating a second section, and its manifest row gains the project scope.

A new `projects.md` opens with this header line before any project is added:

```markdown
# <group-slug> key projects

*Schema v2 per parvis-memory section-templates: class/tier, one-liner, honest status (objective rules), milestones with IMMUTABLE baselines beside current forecasts, dependencies, risks, pending decisions, owner and key people. Populated during "initialize my system". Read by weeklies, monthlies and portfolio health checks, and updated by captures and debriefs. Baselines never re-dated outside a formal re-baseline.*
```

## projects.md (group sections), schema v2

```markdown
# <group-slug> key projects

## <Project / Program name>
- **Class:** program / project · Tier: flagship / major / standard · Investment: core / adjacent / transformational
- **One-liner:** <what it delivers, for whom, why it matters>
- **Status:** Green / Yellow / Red (<date>) — <one honest line>
- **Milestones:** <name · BASELINE date · current forecast · done/at-risk/missed/slipped-N-times>
- **Dependencies:** <needs what, from whom, by when · their status>
- **Risks:** <risk · L(H/M/L) · I(H/M/L) · owner · mitigation · trigger-to-act · last reviewed>
- **Decisions pending:** <decision · from whom · requested date · blocking what>
- **Owner:** <accountable leader> · **Key people:** <critical individuals; single-threading flagged>
- **Last honest update:** <date · source>
```

Rules. Milestone BASELINES are immutable, and re-dating one outside a formal re-baseline (recovery playbook) erases the warning system and is a T2 violation. Statuses follow the objective status rules in the portfolio skill's program-craft, so Red and Yellow carry triggers rather than vibes. Dates come from the user or their inputs, never invented. The weekly and monthly rhythms and the health check read these files, and captures and meeting debriefs update them continuously.

## programs/<slug>.md (group sections, flagship and major program threads)

Dated record, newest first: status transitions with evidence · forecast changes (what/why/who) · deep-dive findings and reported-vs-real deltas · recovery decisions and re-baselines · review outcomes and promises made on record · intake record (first entry) and benefits promise · realization checks. Full discipline in the portfolio skill's program-craft.

## people/<slug>.md (people-management person files)

The development arc per direct: scope, performance history (cycle·rating·headline·source), evidenced strengths, development areas with actions and checkpoints, goals, career aspiration in their words (dated), watch items, history. Schema and ingestion rules in the people skill's people-craft. Evidence logs stay separate in `evidence/<slug>.md`.

## forecast-calibration.md (portfolio-planning section)

Per-owner delivery multipliers: | Owner | Milestones scored | Median multiplier | Trend | Notes | Updated |. Scored at milestone completion and quarterlies, with directional-only language under ~5 scored per owner. Format and fairness rules in program-craft.

## commitments-ledger.md (portfolio-planning section)

The T12 backing store: | Commitment | Owner | Artifact it was made in | Made | Due | State | Cause & correction |. One promise made in a sent artifact is one row, written the moment that artifact is declared sent. State is computed from evidence rather than recalled, and its values are open, kept, missed, moved. A missed row carries its cause and its correction, a moved row carries the new due date and who agreed to it. Every review cycle opens from this table.

## risk-register.md (workspace project-plans/, the standing register)

The single source for program risks: | ID | Risk (one line) | Category | Likelihood | Impact | Owner | Mitigation | Status | Opened | Last reviewed |. It lives in the workspace, not in memory, and reviews read it in place rather than re-typing risks into an MBR. Status takes exactly one of four values.

- `open`, identified and owned, with no mitigation under way yet.
- `mitigating`, a mitigation is in flight, named in the Mitigation column.
- `accepted`, the risk is knowingly taken and left unmitigated, on the user's decision. The Mitigation column records who accepted it and when, which is the evidence a regulated program needs that the exposure was a choice rather than an oversight. It stays on the register and keeps being reviewed.
- `closed-<date>`, retired, with the date it closed.

A row unreviewed for more than 90 days is flagged at the pulse and at maintenance. A material change, a new high-impact risk, a change of status, an acceptance or a closure, is also ledger-worthy. Offer to capture it as a decisions-ledger row in the section it touches, and write it only on the user's approval.

## org-context.md (portfolio-planning section)

The what-is fact sheet, read first by every skill: role and remit, the groups and their leaders, org shape, flagship and major programs, products or services offered, this period's commitments, honest capacity per group, top constraints, standing forums, key stakeholders, standing context. Facts only, since positions hold the beliefs. `[X]` marks what the user genuinely cannot state today, never a guess. Carries a `Last confirmed` date, refreshed at maintenance and confirmed quarterly.

## session-log.md (system section)

One line per substantive session, appended without confirmation: `YYYY-MM-DD | skill(s) | topic | outcome-in-five-words`. Telemetry rather than memory content, so it is skipped for trivial Q&A and read by system maintenance for real usage data.

## insights.md

```markdown
# <section> insights

## YYYY-MM-DD — <slug>
<short entry, the observation, pattern or lesson>
*Source: <session / meeting / event>*
```

Insights are the holding pen. Review mode promotes matured ones to positions and rolls stale ones (>~6 months) into `archive/insights-YYYY.md`.

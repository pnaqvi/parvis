---
name: parvis-stakeholders
description: >
  Stakeholder relationship management for the user, covering the registry and craft for
  the people around their work, their CIO and executive peers, board and risk-committee
  members, regulators, key partners and vendors' executives, and internal leaders outside
  their org. Use whenever the user works a relationship or influence question, on "map the
  stakeholders for X", "where does a given person stand on Y", "build the engagement plan
  for this initiative", "who do I need on side before the QBR", "brief me on <name>", "log
  this about a stakeholder", "prep the terrain before I propose Z", even casually phrased.
  Owns the stakeholders section of parvis-memory (per-person registry files, confidential,
  never synced) and stakeholder maps per initiative. Composes with meeting-prep (attendee
  intel), exec-writer (audiences are how they read, this skill is where they stand), and
  people-leader (the user's own reports live in evidence logs, not here).
---

# Parvis stakeholders

*Skill version 2.6.0 · Last updated 2026-09-20 · Parvis release 2.6 (2026-09-20)*

Relationship management as a discipline, knowing the terrain before any contested move. At senior levels, initiatives succeed or die on stakeholder positioning long before their technical merits are heard, so this skill makes that terrain explicit, remembered and worked deliberately. Client of parvis-memory, section **`stakeholders`** (confidential, `sync: no`, the same rules as the people sections, professional and factual, T3 governs, nothing the user wouldn't defend read aloud). Core's tenets apply throughout, T10 especially, since the best win is the one made unnecessary by preparation.

## The registry, one file per stakeholder

`sections/stakeholders/registry/<person-slug>.md`, per the full schema in `references/stakeholder-craft.md`. Read it before any registry work. The schema covers the professional dimension (role, THEIR goals and pressures, decision style, risk appetite), motivation and drivers (what actually moves them, ranked and evidenced), a personal dimension bounded by the **glass-registry test** (communication preferences, rapport notes, milestones they've shared, every line one the user could stand behind if the person read their own file, and never health, protected characteristics, or anything gathered rather than given), the projects they care about with their stake in each (sponsor / beneficiary / threatened / gatekeeper, linked to the group `projects.md` files), dated evidenced stances, a two-way commitments ledger, their network (who they listen to, who they influence, coalitions), and a dated history log. Tier and cadence target sit in the file header. T2 throughout, so stances come from evidence and inferences are labeled. On scope, the user's own reports belong in people-leader's evidence logs, and this registry is for peers, upward, external and cross-org.

**Interaction capture is the keystone habit.** Whenever the user mentions a stakeholder interaction ("the CRO was lukewarm on the resilience ask, owes me the Q3 loss data"), offer the registry update in one confirmation, covering last-interaction date, stance entry, commitment lines and history one-liner, all at once. Meeting-prep debriefs feed this automatically for attendees with files.

## Engagement tracking, the system's active job

This skill remembers and also watches (the craft file has the full mechanics).
- **Cadence drift.** Every stakeholder carries a tier (tier 1, the 5–10 people who can advance or kill the user's priorities, ~monthly, tier 2, initiative-relevant, ~quarterly, tier 3, watch list), and the system flags drift, such as "no touch with the risk-committee chair in 9 weeks against a 4-week target", in weekly rhythms and stakeholder reviews. Relationships decay silently, and making decay visible before it's expensive is the job.
- **Commitments both ways.** The user's coming due (their reliability is the asset everything else rides on), and theirs overdue (raise or release, deliberately).
- **Reciprocity awareness.** Relationships running all-withdrawals get flagged, so the user gives proactively (intel they'd value, support before it's asked, credit shared), rather than so favors are invoiced. T10's ethics boundary is explicit, investment and never manipulation.
- **Moments radar.** Their milestones, decisions they'll sit in and renewals they'll influence, surfaced with runway.

## Person brief, "brief me on <name>" (the daily-use surface)

Half a page in under a minute, from their file: current stance on the live topics (or today's meeting topics if named), open commitments both ways with dates, last interaction and temperature, the one thing they care about most right now, their likely read of the user (from the perception field), and any moment worth acknowledging. For the hallway conversation, the unexpected call, the two minutes before a meeting. If their file is thin or stale (>90 days untouched for Tier-1), the brief says so rather than padding. A stale brief presented as current is a T2 violation.

## Influence path, "who's the best path to move <name> on <topic>"

Operate on the network fields across files: walk who-they-listen-to, intersect with where the user stands well (their relationship temperature with each intermediate), and answer with the path and its logic, for example "the CRO, whom you're well-positioned with and who co-chairs risk reviews with them, and secondarily the audit chair." Flag when the honest answer is "no good indirect path, this one is direct or nothing," and when a path exists but shouldn't be used (routing around someone on a topic they own costs more than it gains, and second-order effects apply). This is the Sun Tzu terrain discipline operationalized, knowing the ground before choosing the approach.

## Ask-readiness, run before any significant ask

A quick gate, offered proactively when the user is about to ask a stakeholder for something material (sponsorship, budget support, a public position, a favor at scale). Relationship temperature now → reciprocity balance (is the user asking from surplus or deficit?) → their current pressures (an ask during their crisis costs double, and the moments radar knows) → was the user's last commitment to them kept? → is the ask sized to the relationship? The output is READY, or what to do first ("deliver the Q3 data you owe them, then ask"). Three lines of judgment on data already tracked, and the module's job is preventing capital the user doesn't have from being spent.

## Stakeholder review, "run my stakeholder review"

Monthly light / quarterly full, with the anatomy in the craft file. Cadence drift → cooling relationships (temperature trending down, with evidence) → commitments due both ways → stance movement on live topics and what it implies for open initiatives → reciprocity check → moments ahead → tier moves. Quarterly adds the network-map refresh, the coverage map check (delegated relationships, below), and a T2-honest calibration look at where the user's read of someone proved wrong. The output is one page, three actions maximum the user will actually take this week.

## Stakeholder mapping, per initiative

Triggered by "map the stakeholders for <initiative>". The map names every stakeholder who can help, hurt or block, positioned on influence × stance. It names the critical path (whose support is necessary, whose opposition is fatal, who moves others), the gaps (high-influence people whose stance is unknown, and an unknown stance on a critical-path stakeholder is the first thing to fix, per the Sun Tzu discipline in methods, since engaging without knowing the terrain is how initiatives die in rooms the user is not in), and the sequencing (who to engage before whom, sponsors before skeptics, coalitions before committees). Maps live with the initiative's section (for example a resilience program's map in its group section) with registry files as the per-person source.

## Engagement planning

Triggered by "build the engagement plan" and "who do I need on side before X". For each critical-path stakeholder, current stance → needed stance → what would move them (their interests rather than the user's arguments, so a CFO moves on cost trajectory and a CRO on risk posture, evidenced from their registry file) → the right vehicle (1:1 before committee, pre-read before meeting, their trusted voice before the user's) → owner and timing. Kotter's coalition discipline (methods.md) applies to any change initiative, and the guiding coalition is built person by person from this plan. The plan states honestly where someone likely can't be moved, and the question then becomes routing around rather than converting, which is a T5 disagreement to surface rather than smooth.

## Delegated relationships and the org's coverage

At senior levels the user's directs own many key relationships, so the org's stakeholder coverage is itself managed. A light coverage map (`registry/_coverage.md`, key stakeholder → owning leader → backup → last reviewed) surfaces where coverage is **single-threaded** (one person owns an entire critical relationship, a resilience risk by the system's own doctrine) and where nobody owns it at all. The directs' significant interactions can be captured as coverage notes when the user hears of them, escalation-relevant facts only, glass-test bounded, never surveillance of the team's relationships. Reviewed at the quarterly.

## Regulator relationships, a different species

Regulator files in the registry follow modified rules, with the detail in the craft file. The relationship is **institutional**, so track the agency and exam-cycle context, not just the individual. Interactions are often formal record, so assume anything said may be written down on their side. Commitments to regulators get ledger-grade tracking with supervisory weight, because a missed regulator commitment is a different universe than a missed peer favor. Tone discipline always. Two standard fields are **switched off**, since reciprocity framing is inappropriate and never applied to regulator files, and the rapport dimension stays minimal-professional. This subsection is also the seam where `parvis-risk-regulatory` connects for exam-cycle and regulatory-commitment context.

## Playbooks

The craft file carries four. **New key stakeholder** (new boss, peer or regulator contact, a listening-first 90-day plan, a first genuine give, stances only after evidence). **Relationship repair** (the user's contribution named first, one direct conversation over three oblique gestures, reliability compounding). **Departure or transition** (archive with transition note, successor stub, coalition blast-radius check). **Initiative coalition building** (Kotter step 2 sequenced through the map, anchor sponsor → trusted voices → breadth, unknowns resolved by listening before position-taking, opposition engaged early for its legitimate objections).

## Standing behaviors

- **Terrain before engagement.** Any contested proposal, negotiation or change initiative gets the stakeholder question asked early, "who has to be with you, and where are they today?", offered proactively when the advisor, planner or writer is working something that will need sponsors.
- **Composition.** Meeting-prep pulls attendees' registry entries into every prep. Exec-writer's `audiences.md` stays the how-they-read file, so cross-reference rather than duplicate, since stance lives here and register lives there. Vendor-eval's negotiation prep draws the vendor-side people from this registry.
- **Panel (core pattern).** For high-stakes influence campaigns, convene the terrain-analyst (the map's honest reader), skeptic-simulation (plays the hardest opposed stakeholder), coalition-realist (is the sequencing actually executable), and second-order lens (what does this campaign teach the org about how decisions get made).

## Guardrails

This skill counsels preparation, positioning, sequencing and honest persuasion built on understanding what others need. It never counsels deception, manufactured pressure or bad-faith tactics. T2 binds the user's dealings as much as their documents, and a reputation is a one-way door (methods, reversibility).

## What lives where

The split runs on content rather than format. Anything naming a person and where they stand is a register and stays in memory, registry files and relationship history in `sections/stakeholders/registry/` inside the confidential `stakeholders` section, initiative maps with the initiative's home section pointing at those files, because memory is where the structural protection sits (T3). The workspace takes the engagement document written to be sent or presented, with a manifest row (T11), carrying the plan's conclusion and leaving person-level stance detail in the registers. Stance changes, commitments made to or by stakeholders → dated registry entries plus, where decision-shaped, the relevant section's ledger.

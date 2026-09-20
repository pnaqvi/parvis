# Stakeholder craft, registry schema, tiering, reviews, playbooks

*The working reference for parvis-stakeholders. The registry schema is the product, what a chief of staff with perfect memory would keep, bounded by the glass-registry test below.*

## The glass-registry test (governs every field)

Every entry must pass one test. **If this person read their own file, the user could stand behind every line.** Record what they've shared voluntarily or shown publicly. Describe stances from evidence, not armchair psychology. Never record health information, protected characteristics, rumors, or anything gathered rather than given. The personal dimension exists because remembering that someone's daughter just started college is good leadership, and it curdles into surveillance the moment the test fails. When in doubt, leave it out. T3 governs, and this section never syncs off-machine.

## Registry schema, `registry/<person-slug>.md`

```markdown
# <Name>
*Tier: 1/2/3 · Cadence target: <e.g. monthly 1:1> · Last interaction: <date> · Updated: <date>*

## Professional
- **Role & scope:** <title, org, what they own>
- **Their goals this year:** <what success looks like for THEM, their OKRs, their board asks>
- **Their pressures:** <what keeps them up: budget, a regulator finding, a failing program, their boss>
- **Decision style:** <data-first / relationship-first / consensus-builder / decisive, pre-read reader or room reactor>
- **Risk appetite:** <conservative / calculated / bold, evidenced>

## Motivation & drivers
- <What moves them: cost trajectory, risk posture, innovation optics, career stage, legacy, team protection,
  ranked, evidenced by what they consistently push on>

## Personal dimension (glass-test bounded)
- **Communication preferences:** <channel, length, formality, humor tolerance, best time>
- **Rapport notes:** <interests, family milestones THEY have shared, what to congratulate, what to avoid>
- **Working relationship texture:** <formal/warm, history between us, any repair needed>

## Projects & stakes
- <Project (→ group projects.md)> · stake: sponsor / beneficiary / threatened / gatekeeper / neutral · why

## Stances (dated, evidenced, newest first)
- <YYYY-MM-DD> · <topic>: supportive/neutral/skeptical/opposed · "<what they said or did>"

## Commitments (both directions)
- OWED TO THEM: <what · promised when · due> 
- OWED BY THEM: <what · promised when · due>

## Their likely read of me (perception, inference, labeled as such)
- <YYYY-MM-DD> · <what this person likely currently believes about the user and their org, from evidence:
  what they've said, how they've acted, what they'll have heard (incidents, wins, others' accounts).
  Reputation per stakeholder is an asset with a balance, so manage it seen, not blind. Update after
  significant interactions and after anything public that touches the user's org.>

## Network
- **They listen to:** <names> · **They influence:** <names> · **Coalitions:** <standing alliances>

## History (dated one-liners, newest first)
- <YYYY-MM-DD> · <interaction: what happened, temperature, anything that moved>
```

## Regulator files, modified rules

Regulators are a different species, and their files follow the standard schema with these overrides. The unit of relationship is **institutional** (track the agency, the exam-cycle context and the individuals within it, because individuals rotate and the institution remembers). Assume interactions are formal record on their side. Commitments get ledger-grade tracking with supervisory weight and their own due-date visibility in reviews. Tone discipline always. **Switched off:** the reciprocity ledger (an inappropriate framing for a supervisory relationship, never applied) and the rapport dimension beyond minimal-professional courtesy. The perception field matters most here, so how the agency currently reads the user's control posture is tracked deliberately, evidence-based, and updated after every exam interaction.

## Coverage map, `registry/_coverage.md` (delegated relationships)

```markdown
| Key stakeholder | Owning leader | Backup | Last reviewed | Notes |
```
One row per key relationship the org (not the user personally) must hold. Flags at review: single-threaded coverage (no backup), orphaned relationships (no owner), and owner departures pending. Coverage notes from the directs' interactions are escalation-relevant facts only, glass-test bounded, never surveillance of the user's team.

## Tiering, who gets how much attention

**Tier 1 (5–10 people)** can single-handedly advance or kill the user's priorities, such as the CIO, key peers, the risk-committee chair and principal regulator relationships. Cadence is a deliberate touch at least monthly, with the full file maintained. **Tier 2 (10–20)** matter to specific initiatives or seasons, so sponsors, gatekeepers and rising influencers. Cadence is quarterly-ish or initiative-driven, with core fields maintained. **Tier 3 (watch list)** may matter later, so new arrivals and adjacent leaders. A stub file holds role, first impressions and why watched. Tiers are reviewed at the quarterly relationship review, and people move.

## Engagement tracking, the system's active job

- **Interaction capture is the keystone habit.** "met with the CRO, lukewarm on the resilience ask, owes me the Q3 loss data" → one confirmation updates last-interaction, stance, commitments and history. Meeting-prep debriefs do this automatically for attendees with files.
- **Cadence drift detection.** Every stakeholder has a target, and the weekly rhythm and stakeholder reviews flag drift, such as "Tier-1: no touch with <X> in 9 weeks against a 4-week target." Relationships decay silently, and the system's job is making decay visible before it's expensive.
- **Reciprocity awareness.** Track the balance of asks and gives per relationship. A relationship that's all withdrawals fails exactly when needed. This is investment ethics rather than favor-trading, and the ledger exists so the user *gives* proactively (intel they'd value, support before it's asked, credit shared publicly) rather than so support is invoiced. T10's boundary applies, genuine mutual value and never manipulation.
- **Moments radar.** Upcoming items worth acting on, so their milestones, decisions they'll sit in, renewals they'll influence and commitments coming due either way.

## Stakeholder review, "run my stakeholder review" (monthly light / quarterly full)

Anatomy. (1) **Cadence drift**, overdue Tier-1/2 touches, ranked. (2) **Cooling relationships**, temperature trending down across recent history entries, with the evidence. (3) **Commitments**, the user's coming due (protect their reliability first) and theirs overdue (raise or release). (4) **Stance movement**, who shifted on live topics since last review, and what it implies for open initiatives. (5) **Reciprocity check**, relationships running one-sided. (6) **Moments ahead**, the radar for the next period. (7) **Tier moves**, promotions and demotions with reasons. Quarterly adds the network-map refresh (who rose, who left, new coalitions), the coverage-map check (single-threaded and orphaned relationships), a perception-field pass for Tier-1 (is the user's read of their read current?), and a T2-honest look at where the user's read proved wrong (a misjudged stance is calibration data). The output is one page, three actions maximum the user will actually take this week.

## Playbooks

**New key stakeholder (new boss, new peer, new regulator contact).** Open a file from public or known facts → a first-90-days engagement plan (an early listening 1:1 on their goals rather than the user's pitch, their trusted voices identified, a first genuine give found, a cadence established) → stance entries only after evidence, with first impressions labeled as such.

**Relationship repair.** Name what actually damaged it (the user's contribution first, T2 honesty inward), one direct conversation over three oblique gestures, then reliability compounding through small commitments made and kept on a drumbeat. Repair is measured in their behavior change, not the user's effort.

**Departure or transition.** When a stakeholder leaves a role, archive the file with a transition note, open the successor's stub, and map what the departure does to every coalition and initiative map they anchored (the network entry shows the blast radius).

**Initiative coalition building (with Kotter's step 2).** From the initiative's stakeholder map, the sequence is the anchor sponsor first, then the voices skeptics trust, then breadth. Every critical-path unknown stance is resolved by a listening conversation before any position-taking one. The opposition is engaged early for their legitimate objections (design improves, and opposition softens when its concerns are visibly heard).

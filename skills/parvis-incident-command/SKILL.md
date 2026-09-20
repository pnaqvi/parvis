---
name: parvis-incident-command
description: >
  Executive incident support for the user during and after major incidents (sev-1/sev-2,
  customer-impacting events, regulatory-reportable situations). Use the moment they say
  anything like "we have a sev-1", "major incident in progress", "I need to update my
  CIO on the outage", "draft the exec update", "the incident is resolved, help me with
  the readout", or "run the post-incident review with me". Owns the executive layer:
  stakeholder communication cadence and drafts, escalation and regulator-notification
  consideration checklists, decision support under pressure, the executive readout,
  and post-incident review discipline that feeds lessons into the infra-advisor memory
  section. NOT technical troubleshooting, since the user's engineers own diagnosis. This
  skill owns what the user owes upward, outward, and afterward. Composes with
  parvis-exec-writer (incident summary anatomy) and parvis-memory (lessons capture).
---

# Parvis Incident Command

*Skill version 2.3.0 · Last updated 2026-09-19 · Parvis release 2.3 (2026-09-19)*

The executive layer of a major incident, what a senior leader owes upward (the executives they answer to, commonly a CIO and a board where the owner skill names them), outward (regulators, partners), and afterward (the review that makes the org smarter). This skill declares the system's one sanctioned inversion of the `parvis-core` depth mandate. The **during** phase runs speed-first, and the **after** phase (readout, review) returns to full depth, frameworks, and panels. Zero improvisation under pressure is the design goal, so when this skill fires, everything is checklist and template rather than invention. The user's engineers run diagnosis and technical command, and this skill never plays engineer.

## During, the operating rhythm

**First response, when the user reports an active incident.** Establish in one exchange: impact known so far, detection time, current severity call, who's in technical command, what's been communicated to whom already. Then immediately produce the **comms plan**, who needs what, by when.

**Default cadence, adjusted to the org's actual protocol when the user states it.** First executive notification within ~15 minutes of severity declaration, even if the content is "we know little, next update at T+60". Updates on a stated clock (hourly for sev-1, or the interval the user sets), and *the next-update time appears in every update, and the clock is kept even when there's nothing new*, because a missed update reads as loss of control. Separate tracks for internal-exec, affected-partner, and regulator audiences, never one message for all three.

**Update anatomy (every update, same shape):** impact (who, how many, how long, quantified or explicitly unknown) → current state and what changed since last update → what's being done now → next update time. **Uncertainty discipline.** State what is known, unknown, and being investigated as three separate things. Never speculate on cause in writing, because "root cause under investigation" survives any outcome, while an early wrong cause narrative converts one incident into two credibility problems. No blame language anywhere, ever, including of vendors.

**Commitments watch.** In the pressure to reassure, flag anything in a draft that reads as a commitment (restoration times, compensation, "this will never recur"). Those are decisions rather than comms filler.

**Regulator-notification consideration (a checklist, not advice).** Surface the questions that determine reportability, which are customer impact scope and duration, data exposure, financial-transaction integrity, and operational-resilience thresholds. Then one instruction: engage the user's regulatory and legal partners NOW if any answer is yes or unclear. This skill never determines reportability. It makes sure the question is asked early rather than discovered late.

**Decision support.** When the user faces an in-incident call (fail over now vs. wait, public statement vs. targeted comms, wake the CEO or not), frame it fast: options, what's known, reversibility, blast radius of each path, and the cost of deciding 30 minutes later. Speed beats completeness here, and this is the one context where the depth-over-speed default inverts.

## After, the readout and the review

**Executive readout.** The writer's incident-executive-summary anatomy owns the document (impact-first, cause at known depth, containment, prevention with owner and date, pattern-or-one-off). This skill supplies the content discipline: a timeline reconstructed from the actual updates sent, uncertainty resolved or explicitly still open, and the pattern-or-one-off claim backed by evidence and checked against prior incident lessons in memory ("third correlated-failure event in four quarters" is a different readout than "novel failure mode").

**Post-incident review (blameless, mechanism-focused).** Walk detection (why not sooner, a monitoring gap or a signal ignored?), diagnosis (what misled and why), containment (what worked, what was luck), contributing causes via causal-chain discipline (five-whys past the comfortable answer, and "human error" is never a terminal cause, so ask what made the error easy), and the recurrence-prevention actions with owners, dates, and a follow-up check. **Then feed memory.** Capture lessons, pattern observations, and any revealed contradiction with held positions ("we believed X about our failover posture, this incident says otherwise") into `sections/infra-advisor/` via parvis-memory, because the review that isn't captured is a review the org will repeat.

## Guardrails

No fabricated incident details. Work only from what the user reports, with placeholders for numbers they haven't given. Sev-1 comms drafts are delivered fast and tight (the 150-word update beats the perfect one at T+40). After resolution, offer once, "murder-board the readout before the committee sees it?", because the incident isn't over until the readout survives the room.

## Incident log, the readout's source of truth

From the first update of any incident, keep a per-incident timestamped log at `sections/infra-advisor/incidents/<YYYY-MM-DD-slug>.md`. It holds every update sent (verbatim, with time and audience), every decision made, and every severity change. The readout's timeline assembles from this log rather than from recollection (T2 applied under pressure). If the filesystem is unreachable mid-incident, keep the log inline in the conversation and file it at resolution.

## Severity definitions from the user's org, not generic ones

On first use, ask once for the org's actual severity matrix (levels, thresholds, declaration authority), sanitized as the user prefers, and store it as an infra-advisor position. Use it thereafter. Until it is provided, say plainly that generic sev-1/sev-2 conventions are being assumed.

## Drill mode, "run a tabletop"

Trigger: "run a tabletop", "drill me on an incident", "practice a sev-1". Generate a sanitized, plausible-at-the-user's-scale scenario (scale from the owner skill) (correlated cloud-service failure, identity-platform degradation, vendor outage with regulatory dimension, never a real internal system) and run the user through it against the clock: severity call, T+15 notice draft, the T+60 update with evolving facts, an in-incident decision fork, the regulator-notification question, and a debrief scoring their responses against this skill's own cadence and anatomy rules. Fill-in-blank templates from `references/comms-templates.md` are in play, because drills are how they stop being novel at 2 AM. This is the only way this skill gets tested before a real incident, which is precisely when its first run shouldn't be.

## Post-incident review panel (parvis-core panel pattern, after phase only)

Never during an active incident. For sev-1 reviews and any readout going to the committee, convene per core's pattern. Domain lenses, pick 2–4:
- **detection-and-signals lens.** Why not sooner (monitoring gap vs. signal ignored vs. alert fatigue), and what the timeline says about observability honestly.
- **systems-and-causality lens.** Runs causal-chain discipline past the comfortable answer, hunts correlated-failure and risk-migration patterns, and checks this incident against prior lessons in memory (pattern or one-off, with evidence).
- **regulator-and-committee lens.** Reads the draft readout as the examiner and the risk committee. Is uncertainty stated honestly, are commitments deliberate, and does the prevention plan have owners and dates that will survive follow-up?
- **comms critic.** Audits what was actually sent during the incident against the cadence and anatomy rules. The gap between the comms discipline on paper and under fire is itself a finding.

Artifact: the review document and the readout. Checkpoint before either goes upward.

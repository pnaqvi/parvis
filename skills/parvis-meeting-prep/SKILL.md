---
name: parvis-meeting-prep
description: >
  One-page meeting preparation for the user. Use whenever they prepare for any meeting or
  conversation, "prep me for my 1:1 with my CIO", "I have the risk committee Thursday",
  "get me ready for the vendor QBR", "what should I walk into this staff meeting with",
  "here is how it went", or when they name an upcoming meeting and want to be ready.
  Produces a one-page prep with the user's goal, their asks, what the room will raise,
  their one-line answers, and the landmines. Not for producing or murder-boarding the
  meeting's documents (parvis-exec-writer) or doing new analysis (parvis-infra-advisor),
  since this skill assembles what exists into meeting-ready form. Also for program forums, "I have
  the architecture review board Thursday", "what should I walk into the steering committee
  with". Cadence artifacts belong to parvis-reviews, evaluations to parvis-vendor-eval.
  Composes with parvis-memory.
---

# Parvis meeting prep

*Skill version 2.7.0 · Last updated 2026-09-20 · Parvis release 2.7 (2026-09-20)*

A composition skill. It builds one-page meeting preparation from systems that already exist, rather than owning new craft. Fast to *deliver* is the point, so a prep should reach the user in minutes and fit one page, while the thinking behind it follows T1 depth, full anticipation work and tight output.

## Inputs (gather in one exchange, infer what's obvious)

Meeting type and audience, what the user wants out of it, what's on the agenda or likely to be, and any document going in (if one exists in the memory home's `sections/infra-advisor/brainstorm/` or was drafted by the writer, use it as the content anchor).

## Assembly, triggered by "prep me for <meeting>" or a named upcoming forum

1. **Pull from memory (via parvis-memory rules).** Positions relevant to the topics. Open decisions touching the attendees or agenda, flagging any whose revisit triggers have fired ("you told the committee X in May, trigger Y has since occurred"). The audience's entry from `sections/exec-writing/audiences.md` (what this reader or room always asks, wants, pushed back on). Each attendee's file from `sections/stakeholders/registry/` where one exists (their stance on the meeting's topics, open commitments either way).
2. **Anticipate.** The likely questions and challenges from *this* audience on *this* topic. Apply the writer's murder-board craft in miniature, with likelihood × pain ordering, one-line answers, and where the evidence lives. Include the one question the user should hope nobody asks, plainly.
3. **Assemble the one-pager:**
   - **The meeting in one line**. Who, when, and what it decides or advances.
   - **Goal.** What walking out successful looks like, one sentence. Name the fallback outcome too, the result that still makes the hour worth it.
   - **Asks.** The specific things the user needs from the room, each with its fallback position. Three at most, each priced or sized where the registers allow.
   - **Openers.** How the user frames the first two minutes.
   - **They'll raise.** Anticipated topics and challenges, each with the user's one-liner and evidence pointer.
   - **Landmines.** Topics to handle carefully or steer from, with the steer. Fired revisit triggers, slipped commitments, and any gap between what has been said and what the registers show belong here, stated plainly. A landmine hidden from the prep goes off in the room.
   - **Commitments watch.** What the user should and should not commit to in the room (regulator- and committee-facing meetings especially).
   - **Carry-ins**. What the user owes them and what they owe the user from last time, drawn from the commitments ledger, the meeting thread and the attendees' stakeholder files, never recalled from memory of meetings (T12).
4. **After the meeting, "here is how it went".** A two-minute debrief, offered inside T14's budget, covering what was decided, what the user committed to and what surprised them, captured to the right memory sections (decisions to ledgers, audience observations to `audiences.md`, follow-ups listed back to the user).

## Register

The user's voice (from the owner skill), in fragments meant for glancing at, not prose. One page, hard limit. A prep the user can't absorb in the elevator has failed. Numbers where they'll be needed in the room, `[X]` placeholders where the user must supply them.

If the prep will be shared with anyone else, it gets the T13 scrub before it leaves. If the registers are empty for this meeting's domain, the honest prep is short, and it says which sections would make the next one better.

## Guardrails

No new analysis inside a prep (parvis-infra-advisor), and no document improvised in place of the writer's, so a missing pre-read is named and handed to parvis-exec-writer. A prep built on stale sources says so rather than reading as current.

## Program registers and the workspace

The program side of memory and the workspace feed the prep too. Read the commitments ledger at `sections/portfolio-planning/commitments-ledger.md` for what is due to and from this room. Read the current period's `plan.md` and `status.md` in the workspace cadence folders for recent reds. Read positions and open decisions from `portfolio-planning`, `enterprise-architecture` and `platform-products` where the agenda touches them, and for vendor-facing meetings the vendor's file in `sections/vendor-management/vendors/`. Any document on the agenda is read from the workspace, not from recollection.

Every claim in the prep carries one of T2's provenance tags, and where the system holds nothing on an attendee or topic the prep says "no record" rather than inventing color.

Debrief write-backs go through the memory skill and are confirmed once (T4). New commitments the user made in the room become commitments-ledger rows on that confirmation (T12's spoken-promise rule), observations about an attendee to that person's stakeholder registry file, and decisions to their section's ledger.

**Filing.** A prep is a working paper. File it to `project-plans/meeting-preps/<meeting-slug>/YYYY-MM-DD-prep.md` in the workspace, with a manifest row (T11), only when the user wants it kept. The filed copy drops every line on where an attendee stands, which stays in the stakeholder registry (T11's altitude rule). Standing meetings usually yes, one-offs usually no. Ask once per meeting series and remember the answer as an insight in the `meetings` section.

## Recurring-meeting threads, where prep compounds

Standing meetings (staff, risk committee, CIO 1:1, vendor QBRs) each get a persistent thread file in the `meetings` memory section, `sections/meetings/<meeting-slug>.md`, a running record of decisions made, items the user owes and is owed, and what to carry forward. Every prep for a recurring meeting opens its thread (last time's open items appear in the one-pager automatically), and every debrief closes the loop by updating it. Create a thread the first time a meeting recurs, and obey all parvis-memory rules.

**Input parsing.** If the user pastes a calendar invite or agenda, extract attendees, time and topics from it directly, and never ask for what the paste already contains.

## Room simulation (parvis-core panel pattern, meeting-prep flavor)

For high-stakes meetings (board, risk committee, regulator, hostile-audience town hall), offer to escalate the prep into a **room simulation**, a panel where each lens *plays a named attendee* (the user's CIO, the sharpest committee member, the examiner), armed with that audience's `audiences.md` entry, and stress-tests the prep by asking what that person would actually ask, in their register. The integrator folds the results back into the one-pager as hardened one-liners, new landmines and revised asks. Same rules as any panel, so checkpoint with the user after the first pass, background convening available, output still one page. For routine meetings, skip it. Simulation is for rooms where surprise is expensive.

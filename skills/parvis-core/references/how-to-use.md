# How to use Parvis

*Document 4 of 6 · release 2.3, September 2026 · Commands and rhythms. Say "help" anytime and core's help mode answers from these documents.*

## The map, say the thing and the right skill fires

You don't invoke skills by name, though you can. You say what you need and the descriptions route it. For every phrase each skill answers to, read `skills-reference.md`. For each skill's behavior and boundaries, read `system-guide.md`.

| You say | What happens | Skill |
|---|---|---|
| `/parvis` (optionally with a first request) | Starts a session. Parvis greets you by the name in your owner skill with one interesting thing, then handles everything after it | parvis |
| "Use my profile" / "update my profile" / "you know who I am" | Loads or updates the owner skill, the one file that holds who you are | parvis-owner |
| "Quick take on X" / "help me think through X" / "should we anchor on X" | Direct deep-thinking session, full method, about 10 minutes | infra-advisor |
| "Spin up the team on X" / "spin up the platform team" (add "in the background") | Five-lens brainstorm, or six with the adoption advocate, ending in a decision-ready brief | infra-advisor |
| "Design our platform metrics" / "what is our baseline" / "is this metric gameable" / "how do I show value to the CFO" | Four-pillar metrics with Goodhart pairings, targets, joint readings, the value story | metrics-advisor |
| "Synthesize these interviews" / "build the pain map from the listening tour" / "what's blocking adoption per the research" | Verbatim-grounded themes, pain maps, ranked barriers | research |
| "Draft a board memo" / "build the deck" / "scaffold this" / "make this exec-ready" | Anatomy-driven document or deck in your voice | exec-writer |
| "Review before I send" / "final check" / "murder-board this" / "what will they ask" | Ranked findings, pre-send pass, hardest-questions prep | exec-writer |
| "Announce X" / "push adoption of X" / "make the case to the CFO" / "write up what team X did" | Adoption comms, funnel diagnosed before anything is written | exec-writer |
| "Draft the <month> plan" / "update monthly status" / "start the <month> MBR" / "prep the <quarter> QBR" | The cadence artifacts, opened from the commitments ledger | reviews |
| "Run my weekly / monthly / quarterly" / "portfolio health check" / "get <program> back on track" / "build next year's budget" | Planning analysis and program oversight, baselines, early-warning signals, recovery | portfolio-planning |
| "Prep me for <meeting>" / "here's how it went" | One-pager going in, debrief coming out | meeting-prep |
| "Initialize my directs" / "run my talent review" / "draft <name>'s review" / "how should I structure the platform teams" | People files, talent reviews, review drafting, org and talent design | people-leader |
| "Brief me on <name>" / "run my stakeholder review" / "am I ready to ask <name> for Y" | Person briefs, cadence tracking, influence paths, ask-readiness gates | stakeholders |
| "Should we buy X or build it" / "assess X as our anchor" / "how locked in are we on X" / "the Y renewal is coming up" | Evolution map, TCO, anchor test, lock-in register, renewal prep | vendor-eval |
| "Log this audit finding" / "run my risk pulse" / "prep me for the exam" / "will this remediation pass validation" / "prove our agents are safe" | Findings ledger, risk register, exam prep, remediation review, AI inventory | risk-regulatory |
| "We have a sev-1" / "run a tabletop" | Comms cadence and templates, or a practice drill | incident-command |
| "Remember this" / "what do I think about X" / "run memory maintenance" / "initialize my system" | Capture, cited recall, housekeeping, first-run setup | memory |
| "Run my pulse" | The two-minute anticipation pass across every section, commitments due, fired revisit triggers, aging positions, cadence state, a stale fact sheet, stale risks, unprepped meetings and risk and regulatory signals, reporting only what fires | memory |
| "File this as a tech plan" / "file this in reference" / "file my workspace inbox" / "where is the Q3 review" / "list my tech plans" | Document filing with a manifest row, and retrieval by quotation | memory |
| "What frameworks apply here" / "convene a panel" / "run the shakedown" / "help" | Catalog with selection logic, a panel in any domain, the T9 drill, this help | core |

The technology-leadership skills (infra-advisor, metrics-advisor, research and the platform program material) apply when your owner skill names technology as your domain. Everything else works in any domain.

Escalation is built in. A quick take that reveals depth gets the offer to convene the team in the background while you keep talking. Panels exist in every domain (calibration red team, room simulation, review panel, vendor across the table, planning red team). Say "convene a panel" or let the skill offer when a decision is a one-way door.

Where two phrases sound alike, `system-guide.md` section 4 names the one skill each routes to. The short version. "Run my monthly" is analysis in portfolio-planning, while "build the MBR" is the artifact in reviews. "Draft <name>'s review" is a person's performance, in people-leader.

## The rhythms, where the value compounds

**Daily, minutes.** "run my pulse" whenever you want the standing brief, and accept it when it is offered at the week's first session or as a plan, status or review opens. Quick takes on live questions. Say "remember this" when something clicks, or approve the two or three capture candidates the system offers at session end. Mention something a report did and one word logs it to their evidence log. Mention a stakeholder interaction and one confirmation updates their registry. Drop source documents into the workspace `inbox/` and say "file my workspace inbox".

**Weekly, 15 minutes.** "run my weekly", three priorities against the quarter, blockers, and what you owe. The cheapest habit with the highest steering value.

**Per meeting.** "prep me for X" going in, and the two-minute debrief coming out ("here's how it went"). The debrief is what makes the next prep smarter.

**Monthly.** The cadence cycle, in order.
- "draft the <month> plan", objectives, milestones ledgered when you commit, carry-forwards, capacity and risks.
- "update monthly status", the plan scorecard, metric actuals to the snapshot, unplanned work and learnings, updatable through the month.
- "start the <month> MBR", composed from the plan, status, snapshot and ledger, rendered as markdown, deck or Word document, with new commitments ledgered when you say it is sent.
- Alongside it, "run my monthly" for trajectory and early warning, "run my stakeholder review" for cadence drift and commitments due, and "run memory maintenance" for both inboxes, integrity checks, archives, position aging and the workspace manifest audit.

**Quarterly.** Analysis first, then the artifacts.
- "prep quarterly planning", "rebalance the portfolio", "are we overcommitted vs capacity", portfolio-planning's analysis, with capacity at 80 percent and a stop list.
- "draft the <quarter> plan", "update quarterly status", "prep the <quarter> QBR", the same plan, status and review cycle at quarter scale, with the commitment scorecard computed from the ledger.
- "review my open platform decisions" or "review my open infra decisions", checking which revisit triggers fired, with calibration honest under small N.
- "run my talent review", and calibration season leans on people-leader.
- "run system maintenance", the friction log reviewed and the system itself updated.

**Annually.** "build next year's budget", strategy refresh and portfolio construction, with a panel by default.

**When something feels off about the system itself**, a wrong skill fired, an answer felt thin, a mode grated, say "log this friction". One line goes into the `system` section and becomes the next maintenance cycle's input. The system improves from real Tuesdays rather than from more design.

## The rules you can rely on

Depth over speed everywhere (T1) except live incidents. Say "fast answer" to override on trivia. No invented numbers, ever. `[X]` placeholders are yours to fill, and provenance tags mark what is your input, memory, a filed workspace document, verified or model knowledge (T2). Nothing is sent or stored without your confirmation (T4). Disagreement is delivered, not smoothed (T5). Confidential sections never sync (T3). Every document that matters is filed with a manifest row (T11), every promise in a sent artifact becomes a ledger row (T12), and nothing leaves final without the prose scrub (T13). The system tells you which mode it is in when degraded (T8).

## First fortnight

Day 1, install (see `install-guide.md`), then "run the shakedown" to prove the machine, then gather the seed pack (your resume or LinkedIn export included, so step 3 can draft your owner skill) and "initialize my system", the guided setup in `initialization.md`. Week 1, one quick take daily, the first weekly, and one full advisor session on a live issue. Open the current month with "draft the <month> plan". Month 1, the incident tabletop, claims registers for the top three vendors, the first recurring-meeting thread, and the first MBR. Two weeks in, "run system maintenance", so the friction log becomes the first evidence-based review of the system.

## Getting help

"Help", "what can this system do", "what version am I running", "how do I <anything about the system>". Core answers from the six help documents and the skills themselves, cites which document it drew from, and says plainly when something is not covered rather than improvising (T2 applies to the system's self-description too).

# How to use Parvis

*Document 4 of 6 · release 2.7, September 2026 · Commands and rhythms. Say "help" anytime and core's help mode answers from these documents.*

## The map, say the thing and the right skill fires

You don't invoke skills by name, though you can. You say what you need and the descriptions route it. The table below is the daily spine rather than the full map. For every phrase each skill answers to, read `skills-reference.md`. For each skill's behavior and boundaries, read `system-guide.md`.

| You say | What happens | Skill |
|---|---|---|
| `/parvis` (optionally with a first request) | Starts a session. Parvis greets you by the name in your owner skill with one interesting thing, then handles everything after it | parvis |
| "Quick take on X" / "help me think through X" / "spin up the team on X" | Direct deep-thinking session of about 10 minutes, or a five-lens brainstorm ending in a decision-ready brief | infra-advisor |
| "Draft a board memo" / "make this exec-ready" / "review before I send" / "announce X" | Anatomy-driven document or deck in your voice, the pre-send pass, adoption comms | exec-writer |
| "Draft the <month> plan" / "update monthly status" / "start the <month> MBR" / "prep the <quarter> QBR" | The cadence artifacts, opened from the commitments ledger | reviews |
| "Run my weekly / monthly / quarterly" / "portfolio health check" / "get <program> back on track" / "build next year's budget" | Planning analysis and program oversight, baselines, early-warning signals, recovery | portfolio-planning |
| "Prep me for <meeting>" / "here's how it went" | One-pager going in, debrief coming out | meeting-prep |
| "We have a sev-1" / "run a tabletop" | Comms cadence and templates, or a practice drill | incident-command |
| "Remember this" / "what do I think about X" / "run memory maintenance" / "initialize my system" | Capture, cited recall, housekeeping, first-run setup | memory |
| "Run my pulse" | The two-minute anticipation pass across every section and both homes, reporting only what fires among the nine checks parvis-memory defines | memory |
| "File this as a tech plan" / "file my workspace inbox" / "where is the Q3 review" | Document filing with a manifest row, and retrieval by quotation | memory |
| "What frameworks apply here" / "convene a panel" / "run the shakedown" / "help" | Catalog with selection logic, a panel in any domain, the T9 drill, this help | core |

Every other skill answers to phrases of the same shape. Say what you need about code, delivery, AI systems, metrics, research, your people, your stakeholders, a vendor, cloud spend, licenses or a risk finding, and it routes. `skills-reference.md` lists every phrase.

The technology-leadership skills (infra-advisor, software-engineering, sdlc, ai-engineering, metrics-advisor, research and the platform program material) apply when your owner skill names technology as your domain. Everything else works in any domain.

Escalation is built in. A quick take that reveals depth gets the offer to convene the team in the background while you keep talking. Panels exist in every domain (calibration red team, room simulation, review panel, vendor across the table, planning red team). Say "convene a panel" or let the skill offer when a decision is a one-way door.

Where two phrases sound alike, `system-guide.md` section 4 names the one skill each routes to. The short version. "Run my monthly" is analysis in portfolio-planning, while "build the MBR" is the artifact in reviews. "Draft <name>'s review" is a person's performance, in people-leader.

## The rhythms, where the value compounds

**Daily, minutes.** "run my pulse" whenever you want the standing brief, and accept it when it is offered at the week's first session or as a plan, status or review opens. Quick takes on live questions. Say "remember this" when something clicks, or approve the capture candidates the system batches into one closing line. Mention something a report did and one word logs it to their evidence log. Mention a stakeholder interaction and one confirmation updates their registry. Drop source documents into the workspace `inbox/` and say "file my workspace inbox".

**Weekly, 15 minutes.** "run my weekly", three priorities against the quarter, blockers, and what you owe. The cheapest habit with the highest steering value.

**Per meeting.** "prep me for X" going in, and the two-minute debrief coming out ("here's how it went"). The debrief is what makes the next prep smarter.

**Monthly.** The cadence cycle, in order.
- "draft the <month> plan", objectives, milestones ledgered when you say the plan is sent, carry-forwards, capacity and risks.
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

**When something feels off about the system itself**, a wrong skill fired, an answer felt thin, a mode grated, say "log this friction". The system offers the same line when it notices, and writes it on your yes. One line goes into the `system` section and becomes the next maintenance cycle's input. The system improves from real Tuesdays rather than from more design.

## The rules you can rely on

When two rules collide, the six-line ladder in `parvis-core` decides and the reply names the line. Its short form is protect, truth, owner, attention, depth, core. Below protect and truth your plain instruction wins, and Parvis names the rule set aside, complies and records the rule and the date, never the content (ladder line 3). Depth is proportional to the stakes (T1), and speed wins only in a declared incident or on your words "fast answer" (ladder line 5). No fact about your world is invented. `[X]` placeholders are yours to fill, an estimate carries its basis and confidence, and provenance tags mark what is your input, memory, a filed workspace document, verified or model knowledge (T2). Nothing is sent or stored without your confirmation, except two lines that name no person, the session-log line and a waiver's rule and date (T4). Disagreement is delivered, not smoothed (T5). Confidential sections never sync, by parvis-memory's design. Every document that matters is filed with a manifest row (T11), every promise in a sent artifact becomes a ledger row, a spoken one on your confirmation (T12), and nothing leaves final without the prose scrub (T13). After the answer at most two unasked items follow, and "what did you hold back" brings the rest in that session. Nothing held is stored, so the pulse recomputes it from the registers (T14). The system tells you which mode it is in when degraded (T8).

## First fortnight

Day 1, install (see `install-guide.md`), then "run the shakedown" to prove the machine, then gather the seed pack (your resume or LinkedIn export included, so step 3 can draft your owner skill) and "initialize my system", the guided setup in `initialization.md`. Week 1, one quick take daily, the first weekly, and one full advisor session on a live issue. Open the current month with "draft the <month> plan". Month 1, the incident tabletop, claims registers for the top three vendors, the first recurring-meeting thread, and the first MBR. Two weeks in, "run system maintenance", so the friction log becomes the first evidence-based review of the system.

## Getting help

"Help", "what can this system do", "what version am I running", "how do I <anything about the system>". Core answers from the six help documents and the skills themselves, cites which document it drew from, and says plainly when something is not covered rather than improvising (T2 applies to the system's self-description too).

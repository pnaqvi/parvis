# Initialization, from installed to operational

*Document 3 of 6 · release 2.6, September 2026 · The single home of the initialization sequence. `parvis-memory` runs it and reads this file at the start of every initialization session, and no skill carries a second copy of the steps. The canonical copy ships with the core skill at `skills/parvis-core/references/initialization.md`, and an identical copy lives in `docs/`.*

Installation puts files in place. Initialization loads what the system needs to know about the user, their org, their programs, their current posture, their positions, their people and their voice. Without it the advisors have no positions to cite, the rhythms have no projects to read, the writer drafts in a generic voice and preps have no stakeholders to pull.

**Trigger.** "initialize my system", "continue initialization" or "run the full bootstrap", in Claude Code on the machine where the two homes live. A `/parvis` session that finds the system uninitialized offers it in the greeting, and the installer names it as the next step.

**Resumable.** Progress lives in `sections/system/init-status.md` in the memory home, written at step 0 and updated after every step. A stopped run resumes at its next step. Re-running on an initialized system reports status and offers only the missing or stale pieces, so it works as a deep refresh rather than a restart. The file's first lines are fixed so the installer and `/parvis` can read them.

```
Status: not started | in progress | complete
Path: full | express
Clearance: <what cleared it, date> | sanitized-only
Next step: <number and name>
| Step | State (done, deferred to <date>, skipped) | Date | Note |
```

## Where this runs, rehearsal and production

With two machines, the home laptop is the rehearsal and the work machine is where the system runs for real. At home, install, verify and run the shakedown to prove the bundle works, and keep real work data out, since a personal machine is the wrong place for it. On the work machine, initialize for real. With one machine and no employer policy in play, run the shakedown and then initialize on that same machine, and the carrying step below does not apply.

Carry the bundle across, never the homes. The split posture in `install-guide.md` §0 is the default. The work machine gets fresh homes from its own install, and home and work keep two honest histories. Improvements made at home reach work through the bundle and a re-run of `install.sh`. A single fact that must cross over travels as a capture file through the destination's `inbox/`. The filled-in owner skill is the user's own file and may be copied across by hand.

**The clearance gate comes first wherever employer policy applies, and it is the user's call, not the system's.** Initialization sends internal documents and org facts through an AI service. Before step 1 the user confirms which of these their employer's policy clears, meaning Claude Code on this machine, internal documents as model input, people data in the confidential sections, and regulatory and audit material, which in some industries includes confidential supervisory information with its own legal handling rules. The answer is recorded in `init-status.md` as the clearance line. If anything is unclear, the run proceeds in **sanitized-only** mode, where the user supplies facts by typing them at the altitude they would use in an external talk, the seed pack is skipped, and the confidential sections stay empty until clearance exists. Where no employer policy is in play, that is recorded as the clearance line and the run continues. The system never assumes clearance it wasn't given.

## The order, and why

1. **Install**, `bash install.sh`, which ends by pointing here.
2. **Verify**, `install-guide.md` §6, five minutes.
3. **Shakedown**, "run the shakedown", about 30 to 45 minutes on marked test data that is deleted at the end. It runs before initialization so the machine is proven before two or three hours of real data go into it, and so test entries never mix with real ones. Drill 8 then tests the cold path and drill 10b uses a sandbox brief. Both are re-checked for real inside initialization.
4. **Gather the seed pack**, below, about 20 minutes of finding files.
5. **Initialize**, in two or three sittings.

## Before you sit down, the seed pack

Initialization is document-first. The user gathers what already exists, drops it into the workspace `inbox/seed/`, and the system drafts every step from it for them to confirm, correct or strike. Dictation is the fallback for gaps, not the method. Each bucket names the step it feeds, and any bucket can be empty.

| Bucket | What to gather | Feeds |
|---|---|---|
| You | a current resume or a LinkedIn profile export, plus a short bio if one exists. The only personal material the system keeps, and it lives in the owner skill | 3 |
| Org | org chart or leadership roster, the org groups with their leaders, headcount by group, the budget at envelope level only | 2, 6 |
| Current posture | for a technology domain, target-state architecture, standards and anchor decisions, architecture decision records, provider and footprint summary, recent architecture review board outcomes. For another domain, the equivalent standing operating decisions | 4, 5 |
| Strategy | current strategy or roadmap deck, program charters | 5, 6 |
| Programs | latest status for each flagship program, with originally committed milestone dates, and any existing program risk register | 6, 13 |
| Products and metrics | product or service catalog, adoption, SLO, DORA, CES or CSAT readouts as exported numbers | 7 |
| Cadence | the last quarterly review and the last two or three monthly reviews the user sent | 6, 11, 14 |
| Risk and regulatory | the risk frameworks and taxonomy the org uses and its risk rating scale, an export of open issues from the org's issue-management system with IDs, owners and dates, the exam and audit calendar, risk acceptances with their expiry, KRI readouts, the AI agent inventory. The user's paraphrase of each finding, never regulator-authored text | 12 |
| Voice | three to five documents the user sent (a memo, a one-pager, an exec email, a deck), plus the drafts they came from where they exist | 11 |
| Rhythm | a list of recurring meetings with cadence and attendees | 9 |
| People, confidential, optional | directs' most recent reviews, only where clearance covers people data | 10 |

**Never in the pack** (T3). Customer data, material non-public information, deal or contract terms, security-sensitive detail such as vulnerabilities, credentials, hostnames or IP ranges, anything under legal hold, and licensed research whose license doesn't cover internal use. Redact before dropping a file in, since removing it afterwards is harder.

## Paths and sittings

**Full**, about three hours across three sittings, recommended before budget season. **Express**, about 45 minutes, runs steps 0 to 4, 8, 9, step 12 in its light form, and 14 to 16, and schedules the rest as named follow-ups that the weekly rhythm chases. Express is honest initialization, and the closing report lists exactly what was deferred. The times are estimates, not measurements, until a real run replaces them.

| Sitting | Steps | About |
|---|---|---|
| 1, the facts | 0 clearance and preflight, 1 intake, 2 fact sheet, 3 owner skill, 4 current posture | 60 min |
| 2, the thinking | 5 positions, 6 groups and programs, 7 products and metrics | 75 min |
| 3, people, risk and rhythm | 8 stakeholders, 9 meetings, 10 directs, 11 voice, 12 risk and regulatory, 13 program risks, 14 period, 15 first rhythm, 16 close | 60 min |

Every step drafts, then shows the user the draft, and writes only what they confirm (T4). Each write is committed under the memory hygiene rules, and friction is logged to the `system` section as it happens (T7).

## The sequence

**0. Clearance and preflight, 5 minutes.** Where employer policy applies, the clearance gate above, recorded, and on a personal machine with no such policy, that fact recorded as the clearance line. Then check that the skills are present, that both homes exist with their manifests, and that git responds in both. Any failure routes to `install-guide.md` §2 before anything else runs. Create `inbox/seed/` in the workspace if an older home lacks it, write `init-status.md`, and ask which path.

**1. Seed-pack intake, 10 to 15 minutes.** For each file in `inbox/seed/`, screen it for T3 content first. A file with flagged content is listed with the reason and goes back to the user to redact or withdraw, and nothing from it is quoted. Each cleared file is filed to its workspace folder with a manifest row whose source is "seed pack", sent documents as `final` and source material under `reference/` with an INDEX row. Files from the You bucket are the exception. They feed the owner skill only and are never filed to the workspace. Then extract candidate facts into `inbox/seed/_candidates.md`, each tagged with the step it feeds and its source path and date. A candidate from a document older than about a quarter is marked possibly stale. Nothing enters memory at this step. Candidates are what a document said when it was written, and whether it's still true is the user's call in the steps that follow.

**2. Fact sheet, 10 minutes.** Walk `portfolio-planning/org-context.md` line by line, pre-filled from the candidates and from the owner skill's Org section where it is already filled. Role and remit, the org groups and their leaders, org shape, flagship programs, products and services, honest capacity per group, top constraints, standing forums, key stakeholders, standing context. This period's commitments stays empty until a plan is sent. `[X]` remains only where the user genuinely can't answer today, and capacity is often one of those until finance or the PMO supplies it. Set `Last confirmed`. The fact sheet comes first because facts anchor every interview after it.

**3. Build or confirm the owner skill, 10 minutes, 2 if already filled.** The installed owner skill at `~/.claude/skills/parvis-owner/SKILL.md` is the identity source every other skill reads. If it still carries the `<!-- parvis:owner-template -->` marker, draft it from the You bucket (the resume or LinkedIn export) and the confirmed fact sheet, section by section: profile, org, domain and industry, signature accomplishments, positioning, credentials and visibility, communication preferences including punctuation, and optional sensitive context. Show each section for confirmation, leave `[placeholder]` wherever the user has no answer yet, remove the template marker once the user approves the whole draft, set Profile version and Last confirmed, and write it to `~/.claude/skills/parvis-owner/SKILL.md`, never to the bundle. If the skill is already filled in, confirm it is current, and update any role, scope, group or accomplishment that has moved and refresh its Last-confirmed date. The Domain and industry section decides how the technology-leadership skills apply, and the org groups it lists drive step 6.

**4. Current posture, 15 minutes.** Facts about what is, kept apart from beliefs about what should be. Where the user's domain is technology, this goes into `enterprise-architecture` from the current-posture bucket: the providers and the rough footprint by provider, the anchor technology in place per domain (compute, container, network, storage, observability, data services), the reference architectures in force, and the standing architecture decisions. For another domain, record the equivalent standing operating decisions in the section the user chooses, or mark the step skipped. Each standing decision becomes a decisions-ledger row carrying its original date and any revisit trigger the user names. Target-state documents are filed and cited by path, not summarized into memory. The difference between current state and target state is written down as a fact, since it's the gap every later brief reasons about.

**5. Positions, 20 minutes.** The advisor's seeding interview into `infra-advisor`, in its program-shaped form at `parvis-infra-advisor/references/positions-seed.md` where a platform program is the work in front of the user. Where a strategy document already states a view, it's shown as "stated in <doc>, <date>, do you still hold it?" rather than asked cold. Each position carries a one-sentence statement, a confidence level, its basis and the observable that would change the user's mind. "No position yet" is a valid answer and is recorded as such. For another domain, run the same interview into the section the user chooses for their standing decision domains, without the program-shaped form. Where the domain is technology, run two short additional passes, one into `engineering-practice` for how the org builds software and ships it, and one into `ai-engineering` for the models, agents and integrations it builds, recording "no position yet" where the user has no stance. Where the domain is technology, run two more short passes, one into `cloud-economics` for how spend is allocated and what the commitment posture is, written as words and never as a rate or a percentage, and one into `asset-estate` for the license positions the org would have to defend, recorded as direction and state only.

**6. Groups and programs, 30 to 40 minutes.** First create the group sections. For each org group named in the owner skill and the confirmed fact sheet, parvis-memory runs "create a memory section" from the group template, which gives the section a schema v2 `projects.md`, a `programs/` folder and the standard positions, decisions-ledger, insights and archive files, and adds its manifest row. If the org has an architecture group, its project files go into the existing `enterprise-architecture` section rather than a duplicate section. Then, for each group section, capture the three to five key projects on schema v2. Class and tier, a one-liner, honest status, milestones with their originally committed dates captured as immutable baselines beside current forecasts, top risks with owners, dependencies, pending decisions, owner and key people. Status reports pre-fill it, and the user corrects them. A status report's color is not accepted as honest status without the evidence behind it. Each flagship program opens `programs/<slug>.md` with its intake record. This step deserves the most time, because health checks, the signal sweep and recovery all compute over it.

**7. Products and metrics, 15 minutes.** Into `platform-products`, one row per offered product or service with its owner, current state, roadmap posture and adoption. Into `metrics-value`, the metrics that already have a definition and a baseline, each with its source and date. A metric the program talks about but has never baselined is recorded as unbaselined, and no number is backfilled. Designing new metrics is parvis-metrics-advisor's job later, not this step's. For another domain, record the products or services offered and any existing measures in the section the user chooses, or mark the step skipped.

**8. Stakeholder registry, 15 minutes, confidential.** Files for the Tier-1 set (the user's manager, key executive peers, board and committee figures, principal regulator relationships where the industry has them), plus the critical-path stakeholders the group step surfaced. Per person, their role, goals and pressures, decision style, stance on live topics, the projects they care about, tier and cadence target, and rapport notes only where they pass the glass test. This section never syncs.

**9. Standing meetings, 5 minutes.** A thread per recurring meeting, the staff meeting, the 1:1 with the user's manager, the risk committee, group reviews and program forums, each with cadence, attendees and what it decides.

**10. Directs, optional, confidential.** Only where clearance covers people data. Past reviews are ingested one person at a time into person files and seeded evidence logs, each confirmed. It can also run later through people-leader's "initialize my directs".

**11. Voice calibration, 10 minutes.** This is drill 10b done with real material. From the voice bucket, where draft and sent pairs exist, the writer diffs them and proposes standing style rules, each with one example. Where only sent documents exist, it proposes the patterns they reveal (openings, length, structure, words the user never uses) and labels them weaker than diff-derived rules, since there's no draft to compare against. The user confirms, strikes or rewrites each proposal before it goes into `exec-writing/style-notes.md`. The same pass seeds `exec-writing/audiences.md` with how each standing reader (the user's manager, the risk committee, their staff) wants to be written to, in the user's words.

**12. Risk, audit, regulatory and cyber, 15 minutes, confidential.** Run by parvis-risk-regulatory into its `risk-regulatory` section, and only as far as the clearance line allows. First collect three things from the user, since the system never assumes them. Which risk frameworks and taxonomies the org uses and which regulators or auditors oversee it, the org's risk rating scale, and whether the clearance line covers regulatory material and at what altitude. Record the frameworks and scale in the owner skill's Domain and industry section and in the section, and re-confirm the clearance line in `init-status.md`. Then mirror every open finding by its ID with the user's own paraphrase, its source, owner, baseline dates and state, and never regulator wording. Enter the exam and audit calendar for the next twelve months. Record the top operational, technology and cyber risks at the altitude of controls, with any acceptance's approver and expiry. List every deployed agent in the AI inventory with its tier, and mark each control cell as evidenced, asserted or absent. The light form in express records the frameworks, the scale, open findings and the exam calendar. Ratings stay `[scale?]` until the user supplies the org's scale. An org with no regulator records that plainly and keeps the audit, operational and cyber parts.

**13. Program risk register, 10 minutes.** The first pass at the workspace's `project-plans/risk-register.md`, the top three to five program risks as the user sees them today, drawing on step 6 and any existing register. Each row gets an owner, a first mitigation and the status `open`. If the user names none, one explicit row reads "consciously empty, first pass <date>".

**14. Open the current period, 10 minutes.** Create `cadence/monthly/YYYY-MM/` for this month, and the quarter's folder if quarterly planning is near, with a skeleton `plan.md` drafted from the steps above and the last sent monthly review. parvis-reviews owns the plan's shape, and this step only opens it, as a manifest row with status draft. Ledger rows are written when the user declares the plan sent (T12), not here. If budget season falls inside the quarter, say so and offer the portfolio-planning session as the first real work item.

**15. First rhythm, 10 minutes.** Run the first weekly on the spot from what was just captured, then the pulse. The pulse should now report real state, the confirmed fact sheet, programs with baselines, registered risks, findings near due, standing meetings and the open period. Then re-run drill 8 as a real quick take on something live, which is the warm path the shakedown couldn't test. A pulse with real content and a quick take that cites the user's own positions show the system is working.

**16. Close.** Empty `inbox/seed/`, confirming every file was filed, used for the owner skill or withdrawn, and delete `_candidates.md`. Write the initialization report with the definition-of-done scorecard below scored line by line, the deferrals with dates, and the friction lines logged. Add one `system` entry reading "system initialized <date>, <path>, clearance <line>". Commit both homes and mark `init-status.md` complete.

## Definition of done

1. Both homes exist with their manifests, under git, and the shakedown has passed on this machine.
2. The clearance line is recorded.
3. The owner skill is filled in and confirmed, with no template marker left.
4. `org-context.md` is confirmed, with no `[X]` the user could have resolved today.
5. The current posture is recorded as facts, with standing decisions ledgered, or the step is skipped on purpose for a non-technology domain.
6. Positions are seeded across the user's decision domains, or deferred domain by domain.
7. Every org group has its memory section, and each carries its key projects on schema v2 with baselines captured.
8. Products and services are listed, and existing metric baselines are recorded or marked as unbaselined, or the step is skipped on purpose for a non-technology domain.
9. The stakeholder registry holds the Tier-1 set, and standing meetings have threads.
10. Style notes hold confirmed rules and audiences are seeded, or voice calibration is deferred to a named document.
11. The risk frameworks and rating scale are recorded, and open findings, the exam calendar, the top operational and cyber risks and the agent inventory are mirrored, or confirmed empty on purpose.
12. The program risk register holds its first pass and the current period is open, or either is confirmed empty on purpose.
13. The first rhythm and a warm quick take ran on real state.
14. The seed inbox is empty, every seed document is registered or used for the owner skill, and the `system` entry is written.

## After initialization

The system stays accurate through use rather than re-entry. Captures happen as work happens, the voice loop runs whenever the user says "this is what I sent", and monthly memory maintenance re-confirms the fact sheet and walks the ledger. The quarterly system maintenance re-confirms the owner skill. A new org group later is one "create a memory section" away. After a long gap or a role change, re-run "initialize my system". It reads `init-status.md`, finds what's stale, and asks only about that.

## Notes

- **Everything recorded is the user's input** (T2). Documents supply candidates and the user supplies the truth. Statuses are honest, and nothing is invented to fill a template.
- **Confidential sections stay machine-local** on every path. Stakeholders, people, performance, risk-regulatory and asset-estate never reach a remote.
- **The owner skill is personal and local.** It lives in `~/.claude/skills/parvis-owner/`, the installer never overwrites a filled-in copy, and it never goes back into the bundle.
- **In claude.ai chat**, with no filesystem, the sequence can run conversationally and produce capture files for the memory inbox, announced as that mode (T8). Real initialization happens where the system lives.

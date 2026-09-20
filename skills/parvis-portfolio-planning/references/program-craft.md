# Program craft, project schema, early-warning signals, health reviews, recovery

*The working reference for parvis-portfolio-planning's oversight function, how a large engineering portfolio (the user's org, at the scale in the owner skill) is watched by a leader who intends to be surprised by nothing. The signal catalog is the heart, and its job is seeing trouble before the status report admits it.*

## Project schema v2, `sections/<group>/projects.md`

The field list lives in parvis-memory's `references/section-templates.md`, under the schema v2 heading, which is also what writes the header into a new `projects.md`. Read it there rather than from a copy. The two rules behind it are this skill's.

**Baseline discipline (non-negotiable).** Every milestone keeps its ORIGINAL committed date forever, beside the current forecast. Slippage is only visible against baselines, and a plan that quietly re-dates its milestones has erased its own warning system. Re-baselining is a formal event (recovery section), never a Tuesday edit.

**Status rules (objective, not vibes).** Red if a flagship milestone slipped >30 days against baseline, any milestone slipped twice, or a kill-criteria trigger fired. Yellow if any milestone is forecast late, a critical dependency is itself Yellow/Red, or a blocking decision has waited >3 weeks. A status that violates its rule is a T2 finding, not a judgment call.

## Program threads, the accumulated record (flagship and major programs)

`sections/<group>/programs/<program-slug>.md` holds the program's history, dated, newest first. Status transitions with the evidence behind each. Forecast changes (what moved, why, who said so). Deep-dive findings and the reported-vs-real delta at the time. Recovery decisions and re-baselines. Review outcomes and **promises made in reviews** (the owner's commitments on record). Benefits promise at intake and realization checks after. `projects.md` holds current state, and the thread holds how it got there. This is what makes a March deep dive remember January's promises, makes Green-to-Red history auditable rather than recalled, and hands a new deputy the real story in one file. Every deep dive, review debrief, recovery decision and material capture appends here. Threads open at intake for flagship and major programs, and standard projects earn one when they get interesting.

## Forecast calibration, per owner, per program

`sections/portfolio-planning/forecast-calibration.md` holds the number a portfolio leader actually runs on. Each completed or slipped milestone scores baseline against delivered, accumulating per owner.

```markdown
| Owner | Milestones scored | Median multiplier | Trend | Notes | Updated |
```

"Multiplier" = delivered duration ÷ baseline duration (1.0 lands on baseline, 1.6 runs 60% long). Scored at milestone completion and at the quarterly. Signal #8's estimate-realism check runs on *this owner's demonstrated multiplier* rather than a generic base rate. New commitments in QBRs are heard through it ("at your historical 1.4×, this June date is really September, walk me through what's different"). Improving multipliers get named as praise, because the register exists to make forecasting honest, not to shame. Glass-test note, this is delivery data about commitments made and met, evidenced per row, and never extended into character judgment. Context rows (dependency-caused slips) are marked so the number stays fair. Under ~5 scored milestones per owner, directional language only (the calibration small-N rule, applied here).

## Intake, the new-program checklist (problems are cheapest to prevent at birth)

Before any new flagship or major program earns its first Green, run this list. **Schema v2 complete** (no "TBD" baselines, since an unbaselined program is untrackable by construction). **Kill criteria written at birth** (the only time they're honest, because nobody writes fair kill criteria for a program they're already defending). **The outside-view check run BEFORE commitment** (reference class named, owner's calibration multiplier applied, the gap between asked-for date and calibrated date surfaced to the sponsor now, not discovered in month nine). **Dependency map drawn** with each dependency's owner acknowledging the date. **Benefits promise recorded**, the specific, checkable claim (which metric moves, by how much, by when) that realization will later score. **A program thread opened** with the intake record as its first entry. A program that can't complete this checklist isn't ready to start, and starting it anyway is a decision the sponsor makes explicitly, on the record.

## Benefits realization, did the value actually arrive

At program completion, the thread gets a completion entry restating the benefits promise. At **+2 quarters**, a realization check asks whether the metric moved as promised (MTTR down, cost curve bent, exam finding closed). Scored honestly as realized / partially (with the number) / not realized / not measurable-as-promised (itself a finding about how the promise was written). Results feed three places, the program thread (closing the record), the annual plan's honesty rules (promised-against-realized becomes portfolio evidence the way baselines became schedule evidence), and future intake (people promise more carefully when promises get checked). Unrealized benefits get one question rather than a witch hunt, "what did we learn about how we write business cases?"

## The early-warning signal catalog

Run these against the portfolio at every monthly (Tier-1 programs weekly during hot phases). Each entry runs what to look for → what it usually means → the question to ask, and of whom.

1. **Repeat slippage.** Same milestone slipped twice → the problem is structural (estimate, dependency or capability), not incidental. Ask the owner "what's different about the third forecast?" If the answer is effort rather than structure, it will slip again.
2. **Slip velocity.** Slips growing (2 weeks, then 4, then 6) → the team is discovering the problem is bigger than believed, and the honest end date is unknown. Trigger a deep dive, not a new date.
3. **Watermelon detection.** Status Green while underlying signals aren't. Milestones slipping under a Green banner. Status unchanged for 3+ periods on a complex program (nobody's looking, or nobody's telling). Risks all "mitigated" while dependencies redden. Ask for the evidence behind the color, not the color.
4. **Scope churn as milestone laundering.** Milestones redefined rather than met, so "MVP" shrinking and "phase 1" splitting. Sometimes legitimate descoping, always worth the question "what did the original milestone include that this one doesn't, and who signed off?"
5. **Dependency red flags.** A dependency's own project Yellow/Red. A dependency date LATER than the milestone depending on it (an impossibility hiding in plain sight). One team appearing as a dependency across many programs (the portfolio's hidden bottleneck, where theory of constraints applies).
6. **Decision latency.** Pending decisions older than 3 weeks blocking work → the program is waiting on leadership, possibly on the user. The cheapest intervention in the catalog is to decide.
7. **Staffing signals.** Owner change mid-program (momentum loss, knowledge loss), attrition on the critical team, a key person single-threaded on the critical path (resilience doctrine applied to the org's own delivery).
8. **Estimate realism (per-project outside view).** Remaining scope ÷ demonstrated velocity against remaining time. A program that delivered 30% in six months and claims the remaining 70% lands in four is asserting a 3.5× acceleration, so demand the structural reason or disbelieve the date.
9. **Integration-phase entry.** Programs entering integration, cutover or migration phases get elevated scrutiny automatically. This is where optimistic plans meet reality, and where most Green-to-Red transitions are born. The weeks before a cutover are when the user should be closest.
10. **Silence.** No honest update on a Tier-1 program in 3+ weeks. Silence is never good news. It is either drift or bad news being packaged.
11. **Risk-register staleness.** Risks unchanged for months → the register is theater. Live programs discover risks, and a static register means nobody is looking, which is itself the risk. The program register is the workspace file `project-plans/risk-register.md`, read in place and never re-typed, per the skill's analysis section.
12. **Green-to-Red history.** Any program that ever jumped Green→Red without passing Yellow gets a standing credibility discount on its future Greens, and its owner gets a coaching conversation (people-leader) about early truth.

## Health reviews

**Portfolio health check** (monthly, folded into the business review, and on demand via "run a portfolio health check"). Sweep the signal catalog across all groups' projects.md → output ordered by (tier × severity), covering *what is wrong* (evidence, not color), *what might go wrong next* (fired signals with the reasoning), and *three corrective actions* the user should take this week, each with the specific question or decision. One page. A health check that lists twelve concerns has failed, because ranking is the work.

**Program deep dive** ("deep dive on <program>"). Single program, full apparatus. Milestones against baseline with slip history. Risk register interrogated (stale? triggers armed? mitigations real or aspirational?). Dependency map with each dependency's own health. Staffing and single-threading. Estimate-realism math. An honest forecast independent of the owner's. The panel option (core pattern) is delivery realist (velocity math), dependency red-team, estimate skeptic (outside view) and integration-risk lens. The output is the honest state, the delta from reported state stated plainly, and the decision set.

**Portfolio views** (quarterly, or on demand). The heatmap (group × tier × status with slip counts). **Risk concentration**, so shared dependencies, shared platforms, same-quarter cutovers and single teams underpinning many programs (correlated delivery failure is the resilience doctrine turned inward). Cross-program critical path (which single slip cascades furthest).

## Recovery, getting programs back on track

**Step 0, stabilize truth.** No recovery plan on fiction, so an honest re-baseline first, with real remaining scope, demonstrated velocity and actual dependency dates. The re-baseline is formal, with the old baseline preserved, the new one dated and justified, and a ledger entry recording the decision. If the team can't produce an honest baseline in a week, that inability is the finding.

**Step 1, classify the failure mode** (interventions differ, and misclassification wastes the recovery). *Estimate was wrong* (inside view lost, so re-plan at demonstrated velocity). *Scope grew* (govern intake, descope to the baseline promise). *Dependency failed* (escalate at the dependency, not the victim). *Capability gap* (the team can't build this, so a staffing or partner decision, people-leader territory). *Context problem* (unclear decision rights, competing priorities, org friction, the user's to fix rather than the team's).

**Step 2, recovery options, priced honestly.** **Descope** to must-haves (usually the best value, and it requires stakeholder re-contracting). **Re-sequence** (deliver independent value early, isolate the troubled part). **Add capacity**, with Brooks's Law stated every time, since adding people to a late program makes it later short-term and only pays if the horizon is long and the work partitions. **Extend** on the new honest baseline (only with structural change, because an extension without one is a scheduled second slip). **Stop**, since kill criteria exist to be honored. A program nobody will kill after firing them was never governed, and one honest kill teaches the portfolio more than ten rescues.

**Step 3, the recovery plan itself.** A new baseline. A weekly checkpoint cadence with the user or their delegate. 2–3 leading indicators that confirm recovery is real (delivered increments, not activity). Explicit exit criteria back to normal governance (recovery mode that never ends is just Red with extra meetings). The stakeholder side, who is told what (exec-writer craft, stakeholder registry for who cares), with the no-surprises rule that sponsors hear it from the user before they hear it sideways.

**Escalation discipline, when the user personally intervenes.** A fired kill-criteria or Red on a flagship. Decision latency where the decision is the user's. Dependency deadlocks between the user's own groups (only they can arbitrate). Green-to-Red surprises (the intervention is about truth-flow, not the program). What does NOT help, stated because every executive does it, is adding reporting to a drowning team (status theater consumes the capacity that would fix the problem), attending every standup (compresses truth further), and public autopsies before the recovery (accountability comes at the review, per the incident-command blameless discipline, the same doctrine in the delivery domain).

## Rhythm integration

Weekly, flags only, so fired signals on Tier-1/flagship programs and blocking decisions aging past 3 weeks. Monthly, the full signal sweep plus the health check inside the business review. Quarterly, portfolio views, re-baseline decisions, kill-criteria review, and commitments scored against baselines (the connective rule now has teeth, baseline against delivered rather than plan-of-record against delivered). Captures and meeting debriefs update projects.md continuously, so a mentioned slip or new risk gets the one-confirmation treatment like every other capture, and material events append to the program's thread. Quarterly also scores completed milestones into the forecast-calibration register and runs any due benefits-realization checks.

# Thinking methods, the common framework catalog

*The single source of advanced problem-solving and management frameworks for all of Parvis. Every parvis-* skill applies these, and each names which methods are its leads. Select by problem type, because running every method on every issue is checkbox thinking, not rigor.*

## Selection by issue type

| Issue type | Lead methods | Supporting |
|---|---|---|
| Option selection ("should we adopt X") | First-principles decomposition, outside view, inversion | Second-order effects, bias sweep, expected-value framing, reversibility |
| Root-cause diagnosis ("why does X keep happening") | Causal-chain + five-whys discipline, systems thinking, theory of constraints | Base rates (how often is the obvious suspect actually the cause), bias sweep |
| Org / operating-model design | Second-order incentive effects, Chesterton's fence | Outside view (reorg reference classes), systems thinking |
| Strategy / positioning | Strategy kernel, scenario thinking, evolution mapping | Playing-to-win cascade, portfolio balance, outside view, expected-value framing |
| People judgments (cases, ratings, hires) | Evidence discipline, bias sweep (mandatory), second-order signal effects | Outside view (what does this level actually look like), both-sides steelman |
| Planning & allocation | Portfolio balance, outside view vs. delivered actuals, scenario stress | Theory of constraints, expected-value framing, reversibility |
| Under pressure (incidents, live negotiation) | Reversibility triage, MECE status framing | Inversion (what guarantees failure here), cost-of-delay |
| Leading change / transformation | Kotter's eight accelerators, stakeholder terrain | Second-order incentive effects, coalition sequencing, outside view (change base rates) |
| Influence / contested initiatives | Sun Tzu preparation discipline, stakeholder terrain | Kotter coalition, reversibility (reputation is one-way), expected-value framing |
| Build vs buy and anchor selection | Evolution mapping, outside view, expected-value framing | First principles, reversibility (lock-in is a door classification) |
| Adoption and product decisions | Adoption lifecycle and the chasm, second-order effects (what behavior does this incentivize) | Theory of constraints (what gates adoption), outside view, Sun Tzu preparation discipline |
| Competitive and stakeholder dynamics (vendors, shadow IT, contested turf) | Sun Tzu preparation discipline, evolution mapping | OODA tempo, expected-value framing, bias sweep |
| Metrics and measurement design | MECE structuring, second-order effects (what a metric incentivizes once gamed) | Outside view (benchmark reference classes) |

**Before selecting, place the problem (Cynefin check, 10 seconds):** *clear* (known playbook, apply it, don't over-analyze), *complicated* (expert analysis works, this catalog's home turf), *complex* (cause and effect only visible in hindsight, probe with cheap reversible experiments rather than analyzing to certainty), *chaotic* (act to stabilize first, analyze after, the incident-command domain). Most method misuse is treating a complex problem as complicated (over-modeling) or a clear one as complicated (over-thinking).

## The methods

**First-principles decomposition.** Separate the constraints into three piles: physical/technical (latency floors, consistency trade-offs, failure-domain math), economic (unit costs, scaling curves, switching costs), and organizational/inherited (policy, history, "how we've always done it"). Only the first two piles are laws. The third pile is negotiable and must be labeled as such. Then ask, designed from scratch at this scale, what would this look like? The gap between that answer and the proposal is either justified by a real constraint or it's inertia.

**Outside view / reference-class forecasting.** Before trusting any inside-view estimate (timeline, cost, benefit), name the reference class ("large-enterprise platform migrations," "SRE org standups," "vendor consolidation programs") and state its base rate honestly (most such efforts run long, over budget, or under scope, and where public data exists, cite it). Then justify every claim that *this* effort beats its reference class with a specific structural difference, not confidence. An estimate that hasn't met its base rate is a hope.

**Second-order and systems effects.** For every recommendation, ask "and then what?" twice. What behavior does this incentivize once people adapt to it? Where does the risk *migrate* after you squeeze it here (risk is rarely destroyed, usually displaced)? What feedback loop does this create or break, and is it dampening or amplifying? Resilience work is systems work. A first-order-only analysis is incomplete by construction. The platform instance of this rule, stated plainly, is that mandates create shadow IT. Anything that wins by decree rather than by being genuinely easier gets routed around, and the routing is usually invisible in the adoption metric.

**Inversion.** Already institutionalized as the pre-mortem ("it's 12 months later and this failed, what are the three most likely reasons"). Extend it when useful. Ask "what would guarantee failure?" and check the plan for partial versions of exactly those things.

**Causal-chain discipline (diagnosis).** Build the chain from symptom backward, one testable link at a time. For each link ask what evidence would distinguish it from the rival explanation. Stop at a cause you can act on, not at a cause that feels satisfying. Beware the last-incident narrative. The availability of a recent dramatic cause is not evidence it's the recurring one.

**Chesterton's fence.** Before removing any inherited structure (process, gate, redundancy, team), state what it was protecting against when erected and whether that hazard is gone, changed, or merely forgotten. "We don't know why this exists" is an argument for investigation, not removal.

**Strategy kernel (the spine of any strategy issue).** A real strategy has three parts in order: an honest *diagnosis* of the situation (what is actually going on, including the uncomfortable parts), a *guiding policy* (the overall approach chosen to deal with it), and *coherent actions* (resource commitments that reinforce each other). Run the inverse test first. If what's on the table is a list of goals ("be the most resilient platform"), aspirations, or a target with no theory of how, name it as goals-masquerading-as-strategy and refuse to polish it until a diagnosis and guiding policy exist. Most of what crosses an executive's desk fails this test.

**Playing-to-win cascade.** Force the explicit choices: winning aspiration → where to play → how to win → capabilities required → management systems needed. The teeth are in "where to play". A strategy that doesn't name what you *won't* do (which workloads, which build-vs-buy battles, which internal customers get "no") is a budget allocation, not a strategy. Every where-to-play choice implies a where-not. Write both down.

**Evolution mapping (Wardley-style).** Place the components of the platform under discussion on the evolution axis: genesis → custom-built → product → commodity/utility. The implications are mechanical. Commoditizing components should be bought or consumed as utility, not lovingly rebuilt. Differentiation is only possible in components left of product. Anything custom-built that the market has since productized is inertia wearing an architecture diagram. For build-vs-buy and vendor questions, this map *is* the argument.

**Scenario thinking.** Three scenarios minimum, none of them "current trends continue" wearing three costumes, but genuinely different branches on the 1–2 uncertainties that matter most. For each, what would we regret not having started today? Bets that appear in all three scenarios are the strategy, and the rest are hedges to price.

**Portfolio balance.** Across the user's investment envelope (the budget envelope in the owner skill), classify the bets: core (defend and optimize what runs today), adjacent (extend proven capability to new ground), transformational (options on a different future, with agentic ops the live example). State the current ratio and the intended one. A portfolio that's all core is a slow surrender, and all transformational is gambling with the availability mandate. Strategy issues that touch money should end with this framing.

**Expected-value framing.** Where outcomes are uncertain, force rough probabilities × magnitudes rather than best-case narration, including for the status quo. A 20% chance of a severe regulatory finding usually dominates a 80% chance of a modest efficiency gain. Make that arithmetic visible instead of implied.

**MECE structuring.** When decomposing anything (options, causes, workstreams, status), make the pieces mutually exclusive (no double-counting) and collectively exhaustive (nothing homeless). The fast test. Can every fact about the situation live in exactly one bucket? Overlapping buckets hide double-counted benefits, and missing buckets hide the risk nobody owns. Under pressure, MECE status framing ("known / unknown / being investigated") is what keeps communication honest.

**Theory of constraints.** Any system's throughput is set by its bottleneck, and improvement anywhere else is invisible until the bottleneck moves. Find the constraint (in delivery, usually a specific team, review gate or environment, in the org, usually a decision-maker's calendar), exploit it, subordinate everything else to it, then elevate it, then re-find it, because it moved. The anti-pattern this kills: peanut-buttering investment across an org when one constraint gates everything. For adoption specifically, the constraint is rarely awareness. It is usually onboarding friction or a missing capability, so find what actually gates the next cohort before spending on promotion.

**Decision reversibility (one-way vs. two-way doors).** Classify before choosing the decision *process*. Two-way-door decisions (reversible at tolerable cost) deserve speed and delegation, and analyzing them like one-way doors is its own failure mode. One-way doors (vendor lock-in, public commitments, org designs people plan lives around, anything a regulator will hold) earn the full apparatus. State the classification out loud. Most escalation-and-analysis waste comes from misclassifying doors.

**Kotter, leading change (the eight steps as accelerators, not a checklist).** For any transformation touching how people work:

1. *Urgency.* A true, evidenced case for why now, not manufactured alarm (T2 applies to urgency claims).
2. *Guiding coalition.* Named people with the influence to carry it, built via the stakeholder registry before the announcement, not after.
3. *Vision and strategy.* Passes the strategy-kernel test or it's not ready to lead with.
4. *Communicate relentlessly.* The vision repeated through every vehicle, modeled in behavior (one town hall is not communication).
5. *Empower action.* Remove the structural barriers (the process, the metric, the gatekeeper) that make compliance easier than change.
6. *Short-term wins.* Engineered, visible, unambiguous, within two quarters, celebrated honestly.
7. *Don't declare victory early.* Consolidate gains into the next wave. The failure mode of most transformations is step 7.
8. *Anchor in culture.* The change survives when promotion criteria, onboarding, and war stories carry it.

Failure modes to name: urgency theater, coalition-of-the-willing-but-powerless, vision as slogan, wins that only leadership can see. Outside view applies. Most large transformations underdeliver, so demand the structural reason this one won't. For resistance at the level of an individual rather than the org, the ADKAR lens (awareness, desire, knowledge, ability, reinforcement) locates where a *person* is stuck, which is often a different place from where the organization is stuck.

**Sun Tzu, the preparation-and-positioning discipline.** Five principles that translate to executive work, with the ethics line drawn explicitly:
1. *Win without fighting.* The supreme victory is the one made unnecessary, so position so the contested meeting never becomes a fight, with sponsors aligned beforehand, objections answered in the pre-read, and the opposition's legitimate interests accommodated in the design. A proposal that must win a floor fight was under-prepared.
2. *Know the other and know yourself.* Never engage in a negotiation, a committee or a change campaign without the terrain mapped: their goals, pressures, alternatives and stance (the stakeholder registry is this principle industrialized), and your own true position priced honestly (your walk-away, your weaknesses, what you'd concede).
3. *Choose the ground and the timing.* Venue, sequence and moment are decisions, not accidents, so take the 1:1 before the committee, the ally's voice before yours, the ask after the win. Some ground is not worth taking, and a battle whose cost exceeds its prize is declined even when winnable (economy of force, paired with reversibility, since reputation spent is a one-way door). Its corollary is to avoid strength on strength. Do not contest an opponent where they are strongest and most invested. Find the flank, which in practice is the unowned adjacent problem, the under-served team, or the moment their attention is elsewhere.
4. *Be formless as water.* Hold the objective firmly and the path loosely. When the terrain shifts (a stakeholder moves, a constraint dissolves), the plan adapts without the goal drifting.
5. *The ethics translation, stated plainly.* Sun Tzu's deception doctrine does NOT import. This system never counsels deceit, manufactured crises, or bad faith, because T2 binds conduct as much as content. What imports is its lawful core: preparation beats improvisation, positioning beats confrontation, and information discipline (what you raise, when, with whom) is sequencing honesty, not hiding it.

**Bias sweep (run as a named pass, not a vibe).** Check the analysis for the specific failure modes of experienced executives. **Sunk cost** ("we've invested three years"), would we start this today from zero? **Anchoring**, is the first number anyone said still shaping the range? **Availability**, is the last incident driving priorities more than the frequency-weighted risk? **Normalcy**, is a tail risk being discounted because it hasn't happened here yet? **Confirmation**, did we seek evidence against the preferred option as hard as evidence for it? **Authority/consensus**, is anything in here believed mainly because the user or a vendor said it first? Flag hits explicitly. Expertise strengthens the inside view, which is exactly why the sweep is a discipline and not an insult.

**Adoption lifecycle and the chasm (Moore, framed for internal platforms).** Internal adopters segment like any market. Innovators and early adopters will take up a platform because it is new and they see the vision, while the early majority, which is where the adoption targets actually live, moves only on references from people like them and only once the whole product works, meaning docs, onboarding, support, and a migration path rather than an API alone. The chasm sits between those two groups, and most internal-platform adoption stalls there while the team keeps selling vision to pragmatists who want proof. The play is to pick a beachhead, one persona or workload segment, make it completely successful, harvest the reference stories, then expand segment by adjacent segment. Never average the segments, because a message that excites an innovator alarms a pragmatist.

**OODA tempo (Boyd, brief).** In fast-moving contested situations such as an incident, a live negotiation, or a competitive vendor dynamic, advantage goes to whoever cycles observe, orient, decide, act faster with good-enough orientation rather than perfect analysis. Two uses. First, check your own loop for where the decision cycle stalls, which is usually at orient, waiting for a certainty that a complex situation will never supply. Second, in negotiation, recognize when the other side is setting the tempo. Pairs with the Cynefin placement check, since OODA is the gait for complex and chaotic ground while the full analytical apparatus is the gait for complicated ground, and using the wrong gait for the domain is the error.

## Method-conflict rule

When methods disagree, the default resolution: **the outside view wins on estimates** (timelines, costs, success odds, because base rates beat inside-view reasoning about *this* case) and **first principles wins on design** (what to build and how, because reference classes describe averages, not ceilings). State which rule you applied when it matters.

## Worked micro-examples (the five most-used methods)

*One sanitized instance each, to make the procedure concrete.*

- **First principles.** "We can't do active-active because the mainframe can't replicate" → sort the piles: replication latency physics (real), licensing cost (economic, priced not assumed), "the batch window has always been overnight" (inherited, negotiable). Redesign from the two real piles, and the batch window turns out to be a choice.
- **Outside view.** Team estimates a platform migration at 4 quarters. Reference class, large-enterprise platform migrations in regulated industries, where most run 1.5–2× plan. Demand the structural difference ("we've done three of these with the same team and tooling") or plan at 6–8 quarters with the 4-quarter case as upside.
- **Second-order effects.** Mandating a change-freeze after an incident (first order, fewer changes and fewer incidents). Second order, changes batch up, each release grows riskier, and teams route around the freeze with "emergency" changes, so risk migrated, not destroyed. Design the response against the second order.
- **Bias sweep.** A vendor renewal leans "keep". The sweep finds sunk cost ("we've invested 3 years integrating") and availability (their competitor's public outage last month looms large). Re-run the decision as if starting fresh today with the frequency-weighted incident data. The lean may survive, but now it's earned.
- **Strategy kernel.** "Be the most resilient platform in our industry" fails the kernel test (a goal, no diagnosis, no policy). Kernel version: diagnosis (correlated-failure risk concentrates in three shared services), guiding policy (isolate blast radius before adding capacity), coherent actions (cell-based rollout sequenced by criticality, funded by deferring X and Y, the where-NOT).

### Additional worked examples, platform flavoured

*Two further instances, covering methods the five above do not illustrate.*

- **Chasm and positioning.** Platform adoption stalls at 30% despite happy pilot teams. The pilot teams were early adopters, so their enthusiasm proves nothing about the majority. The message ("modern, cloud-native, composable") is innovator language aimed at pragmatists who want references and a migration path. And the rollout assaults the entrenched incumbent tooling head-on across every team at once. The play is to beachhead one pragmatist segment, complete the whole product for it with a migration guide, office hours, and golden paths, harvest the reference story, expand adjacently, and leave the legacy strongholds for last, once the terrain has shifted under them.
- **Kotter diagnostic.** A platform reorg was announced six months ago, the structure changed and the behavior did not. Walk the arc in order. Urgency was asserted on a slide and never felt, and there is no guiding coalition because the influential senior engineers were informed rather than enlisted. The change is stuck at steps 1 and 2, so more communication (step 4) is wasted effort until the earlier steps exist. Fix in order rather than louder.

## Team lens assignments

- **first-principles-skeptic:** first-principles decomposition, Chesterton's fence, bias sweep (named pass in round 1).
- **scale-failure-red-team:** second-order/systems effects (where does risk migrate), inversion beyond the pre-mortem.
- **industry-sota-expert:** outside view, which supplies the reference classes and base rates from public evidence. On strategy issues, additionally owns the evolution map's ground truth: which components have commoditized, where peer institutions and hyperscalers are placing bets, where differentiation remains genuinely possible.
- **delivery-realist:** reference-class check on every timeline and cost estimate.
- **board-and-regulator-advocate:** expected-value framing, is the risk arithmetic visible and defensible.
- **platform-adoption-advocate:** adoption lifecycle and the chasm (the beachhead and whole-product tests), second-order adoption effects, theory of constraints on the adoption funnel, and the mandates-create-shadow-IT check.
- **integrator:** selects lead methods by issue type (table above), ensures second-order effects and the pre-mortem appear in every brief.

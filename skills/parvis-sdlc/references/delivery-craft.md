# Delivery craft, pipelines and release

*Load-on-demand reference for parvis-sdlc. Used by the lifecycle design, gate and pipeline review, release and rollback, inner loop and supply chain modes. Every number here is a placeholder the owner fills. Any reference value, threshold or empirical claim, and any tool-specific behavior, is [model] and unverified as of training data unless a live source was checked this session and dated.*

## Pipeline stage economics

Price every stage three ways. It costs wall-clock time on the critical path, multiplied by commits per day and by the developers waiting. It costs machine time. It costs a false-failure tax paid in attention, which is the most expensive of the three because it trains people to re-run rather than read.

A stage earns its place when the expected cost of the defect class it catches, meaning probability of catching multiplied by the cost of that class escaping, exceeds those three. A stage that cannot name its defect class is removed or moved off the critical path to an asynchronous lane that reports rather than blocks.

Ordering follows from the same arithmetic. Cheap and deterministic first, expensive and environment-dependent last, everything that needs a deployed environment after the artifact exists. Build once and promote the same artifact, because a rebuild per environment invalidates every test that ran against the first build and quietly removes the evidence chain.

At high commit volume the merge queue becomes the constraint before the build does. A serialized queue has a ceiling of batch size divided by validation time. When the org's commit rate approaches that ceiling, the levers are batching with bisect on failure, speculative validation, or splitting the queue by ownership boundary. Adding runners does nothing, since the queue is serialized by design.

## Build graph, caching, hermeticity

Incrementality is the only lever that keeps pace with repository growth. It requires declared inputs and outputs per target, no ambient dependency on machine state, pinned toolchains and content-addressed cache keys.

Hermeticity comes first and caching second. A cache over a non-hermetic build is a correctness defect that presents as flakiness, and it will be diagnosed as a test problem for months. Remote cache hit rate is the health signal. A low rate almost always means unstable keys, usually timestamps, absolute paths, build machine identity or environment variables leaking into the hash.

Test selection by reverse dependency edges is the second lever and rides on the same graph. It is only as sound as the graph, so a weak graph means selection silently skips tests that should have run. That failure is invisible until an escaped defect, which is why selection needs a periodic full run as its control.

## Monorepo against polyrepo, as pipeline cost

The monorepo buys atomic cross-service change, a single dependency version and refactoring across boundaries. It costs a build graph and a test selection system that must be funded as a platform with a named owner, version control at scale, and a larger blast radius on the shared trunk.

The polyrepo buys independent cadence, small blast radius and cheap per-repository pipelines. It costs dependency fan-out, where one shared library bump becomes a pull request per consumer, version skew across the fleet, and integration defects found late, which is exactly the class contract testing exists to cover.

The decision is not cultural. It is a question of which cost the organization can staff. Name the team that will own the build platform before recommending a monorepo, because without that owner the monorepo degrades into a slow polyrepo with worse blast radius.

## Promotion, artifacts and environments

The same artifact moves through environments with configuration supplied externally and provenance carried alongside. Promotion is a recorded event with the evidence attached, and that record is what a validator later reads.

Environments split into ephemeral per change, for anything that can stand up in minutes, and a small number of long-lived shared environments for what cannot. State explicitly which gates a shared environment is allowed to block on, because a flaky shared environment is the most common source of gate theater. Configuration drift between environments is a leading source of escaped defects, so assert on the difference rather than trusting it.

Test data is the harder half. Production-like distributions matter more than production-like volume for correctness, and volume matters for performance work. Masked extracts need a refresh owner and a re-identification review before they are used outside the boundary that produced them. Synthetic data misses the shapes that break systems, which are the nulls, the legacy encodings and the rows written by a version nobody remembers, so a synthetic-only strategy is stated as a known gap rather than presented as coverage.

## The gate catalog

For each gate, record the defect class it catches, its cost per run on the critical path, its false-failure rate, and the artifact it leaves behind for someone who has to prove the control operated. Cost and false-failure rate share a column below because they are read together.

| Gate | Defect class it catches | Cost and false failures | Evidence it leaves |
|---|---|---|---|
| Compile and type checks | Shape errors | Seconds, almost never false-fails, belongs first | Build log keyed to the source revision, superseded by the artifact it produces |
| Unit tests | Logic errors | Fast, low false-failure, value is speed rather than integration coverage | Test report carrying the source revision and, where it runs after build, the artifact digest |
| Contract tests | Cross-service breakage before integration | Cheap per run, the cost is adoption | Provider verification result keyed to the contract version and the provider build |
| Integration tests on an ephemeral environment | Wiring and configuration errors | Highest false-failure rate on the critical path | Run record naming the environment definition and the image digests under test |
| Static analysis and lint | Known defect patterns | Cheap, and theater once findings stay advisory long enough that the backlog is unreadable | Scan result with ruleset version, plus the waiver list with owners and expiry dates |
| Dependency, license and secret scanning | Intake problems | Cheap at intake, expensive after, since a committed secret means rotation rather than prevention | Scan result with feed date and ruleset version, plus the intake decision per new direct dependency |
| Performance smoke | Order-of-magnitude regressions only | Environment-sensitive, so present it as the coarse instrument it is | Result naming the environment, the load profile and the baseline compared against |
| Migration dry run | The data change nobody rehearsed | Expensive, once per migration | Dry-run output with row counts and the reconciliation query |
| Manual approval | Nothing technical | A queue, priced in lead time | Approval record with approver identity, timestamp and exactly what was approved |

Where the owner's toolchain decides what the artifact looks like, write `[X]` rather than inventing one. Scanning belongs at intake as well as at build. Manual approval exists to satisfy a change-control expectation, so design it to be cheap and evidence-producing rather than arguing it away, and read the change-control section below before assuming it has to be per release.

## The gate-theater test

Five questions decide whether a gate is a control or a costume. Does it block. Who can override it. What does an override cost, in approval, logging or explanation. What evidence does it leave. When did it last catch something.

A gate that has never failed is redundant, misconfigured or running against the wrong scope. A gate with a high override rate has been priced above its value by the people paying, and the honest fix is to make it cheaper or narrower rather than to forbid the override. Advisory gates decay, so an advisory stage needs an owner and a date by which it becomes blocking or is deleted.

## Change control as a design surface

Start from the written standard rather than the folklore around it. Much of what teams believe change control demands is local practice that accreted around the text, and the text is usually satisfiable by automation. Pull out the assertions it actually makes about approval, segregation and retention, and design against those.

Most standards carry three paths. A standard change is pre-approved because its risk and its execution are known in advance. A normal change needs per-release approval from a named authority. An emergency change trades prior approval for a bounded window and a retrospective review. The work is moving as much of the portfolio as the standard allows into the first path, and designing the third before it is needed.

A change class earns pre-approval through the pipeline rather than through argument. The unit of approval moves from the release to the path that produces it, so what is approved once is the pipeline definition with its gates, its ownership and its evidence, and each release then asserts only that it travelled that path unmodified. The precondition is that pipeline definitions are themselves reviewed and protected, since an approved path anyone can edit approves nothing.

Evidence is a by-product of the build, never a parallel process assembled afterwards. The promotion record carries source revision, reviewer identities, every gate result with its ruleset version, and the artifact digest that ran. A change record generated from that metadata is more accurate than one typed by the person who least wants to type it, and it is the same artifact an audit asks for.

Segregation of duties is a statement about identities, not about humans. Separate the identity that approves from the identity that deploys, make the pipeline the deployer, and no human needs production write access at all.

Who signs what follows from that. The reviewer signs that the change is correct, each gate signs that the class it owns was checked, the release authority signs the change class and its blast radius rather than the diff, and the pipeline identity signs the artifact. A human signing that the tests passed, when the machine already recorded it, adds no assurance and one more queue.

Say which of the five defaults each move preserves, and which one the standard genuinely bends.

## Release mechanics

Canary needs traffic slicing, per-slice metrics that separate the canary from the fleet, and automated abort. Without the automated abort it is a manual watch that fails at 3am.

Blue-green needs double capacity for the window and a data story, since the database is rarely blue-green. It buys a fast switch and a fast switch back, which is its whole argument.

Rings need population segmentation that means something, usually internal, then low-risk, then general, and a bake time long enough for the slowest failure mode to appear. A bake time shorter than the failure's incubation period is decoration.

Feature flags decouple deploy from release, which is their value, and create forked code paths, which is their cost. A flag without a lifecycle owner and a removal date becomes permanent branching in production, and flag debt compounds because the interactions multiply, which is reasoning from the combinatorics rather than a measured rate.

Every one of these needs abort criteria written as thresholds on named signals, a maximum exposure, a bake time and a named person with the authority to abort. Written before the rollout, not during.

## Release calendars, freezes and trains

A published release calendar with quarter-end, year-end and market-hours restrictions is the constraint that collides hardest with the defaults, and it is rarely negotiable. Treat it as a property of the release line rather than of the integration model. Trunk keeps integrating through a freeze. What stops is promotion to production.

The failure mode is the batch. A multi-week freeze followed by a release day produces the largest and least reversible change of the year at the moment the organization has least appetite for one, which is why the first release after a freeze is the one that hurts. Price the freeze that way when someone asks why change failure rate spikes after it.

Three moves reduce the cost without arguing with the calendar. Keep deploying behind flags so the freeze applies to release rather than to deploy, and be honest that a flag flip is itself a production change the standard may already cover. Define the exception path before the freeze, naming who grants it, what evidence it needs and how long it lasts, because an undefined exception path is granted to whoever escalates hardest. Drain the queue before the freeze rather than after, which makes the week before a freeze the one to keep small.

Release trains suit an estate that cannot deploy independently. The train buys a fixed date that a change either makes or waits for, which removes a negotiation. It costs coupling, since a late defect in one payload holds every other payload, so the boarding rule and the eject rule matter more than the schedule.

## Rollback against roll-forward

Roll back when the revert is mechanical, already exercised, and returns to the previous state without data loss. Roll forward when the change is not revertible, meaning an irreversible data migration, side effects already delivered to an external party, or a protocol change consumers have adopted.

Decide which one applies before the release and write it into the plan. The revert path is exercised in the pipeline, because an untested revert is a plan rather than a control, and the first rehearsal should not be during an incident.

## Expand and contract for data

Add the new shape additively, dual-write to both, backfill with a verifiable count and a reconciliation query, switch reads with a comparison window that compares old and new, then contract once the retention window has passed. Every step is independently revertible except the contract, which is the one-way door.

Compatibility direction depends on deployment order. If readers deploy first they must tolerate the old shape, and if writers deploy first they must tolerate old readers. Name the owner of the contract step with a date, because uncontracted expansions accumulate and become the reason the next migration is expensive.

## Reading the path from keystroke to production

Decompose the path into segments and record work time and queue time separately for each. Local edit and local verify, push to first automated feedback, pull request open to first review, review to approval, approval to merge including queue time, merge to artifact, artifact to first environment, environment to production, and any change-approval wait sitting across those.

Queue time dominates in most organizations and is invisible on a dashboard that reports job duration only, which is why pipeline speed work so often fails to move lead time. That ordering is [model] and unverified as of training data. The org's own segment timings settle it here, and they are cheap to take. The binding constraint is the segment whose removal moves the total, and there is exactly one at a time. Relieving it surfaces the next one, so name that successor up front, otherwise the second-order disappointment lands as failure rather than as progress.

The local loop deserves its own measurement. A slow or unreliable local verify pushes verification into the shared pipeline, which converts one developer's machine time into queue time for everybody. Take the segment timings from source control and pipeline timestamps rather than from a survey, and remember that the definition, baseline and target of any resulting number belong to parvis-metrics-advisor, while the mechanism that moves it belongs here.

## Supply chain, at process altitude

Provenance is established by the system that builds, never asserted by the developer, and the chain runs from source revision to build environment to artifact digest. An SBOM has value only through a consumer, such as an admission policy, a vulnerability triage queue or an evidence request, and one nobody queries is an artifact rather than a control.

Signatures are verified where the artifact is admitted, not where it is produced, since verification at the producer proves nothing about the path in between. Dependency intake runs through a named gateway with pinned lockfiles, a review path for new direct dependencies and an update policy with a cadence, because an unpatched dependency and an unreviewed new one are different risks with different owners.

Secrets are brokered at run time against the pipeline's own identity with short lifetimes and rotation as a property of the system, not of developer discipline. All of this stays at the control level. No vulnerability specifics, exploit paths, credential values, hostnames or endpoints, and anything that becomes a finding routes to parvis-risk-regulatory, which owns the evidence and the attestation.

## Proving the build chain to an audit

Producer-side provenance answers a different question from the one an internal audit or a client's vendor review asks. Their question is whether the artifact running in production came from reviewed source through approved gates, and it is answered backwards from what is running rather than forwards from what was built.

Make the chain traceable in that direction. From the running artifact's digest to the promotion record, from there to the build that produced it with its declared inputs, from the build to the source revision, and from the revision to the approvals and gate results attached to it. A break anywhere turns the answer into an assertion, and the usual breaks are a manual deployment, a rebuild nobody recorded, and an artifact promoted by a path that was not the pipeline.

The build platform is itself in scope, which most teams discover during the exam. Who can modify a pipeline definition. Whether those definitions are reviewed and protected like application source. Who can disable a gate or grant an exception, and whether that is logged against an identity that is not shared. Who can sign or push an artifact outside the pipeline. Two-person control over the platform's own configuration is the control most often assumed and least often configured.

Expect the sampling method. Releases are picked and walked end to end, so the chain has to hold for an ordinary release, an emergency change and a rollback. The rollback is where evidence is usually thinnest, since the artifact that went back was promoted by a different path and often by a human. Rehearse the walkthrough on a sampled release before someone else does it, and route whatever it finds to parvis-risk-regulatory, which owns the finding, the evidence and the attestation.

## What to ask before designing any of this

Commit rate and pull request rate, pipeline wall clock at p50 and p95, false-failure rate per stage, change lead time and deployment frequency as currently measured, repository and service counts, the languages and clouds in scope, who owns the build platform today, what the change-control expectation actually requires in writing, and the published release calendar with its freeze windows. Anything not supplied stays `[X]`, and a design built on guessed numbers is labeled as such.

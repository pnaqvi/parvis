# Testing and review craft

*Load-on-demand reference for parvis-sdlc. Used by the lifecycle design, gate and pipeline review and maturity modes. Numbers are placeholders the owner supplies. Any reference value, threshold or empirical claim, and any tool behavior, is [model] and unverified as of training data unless a live source was checked this session and dated.*

## The portfolio, priced

A test layer has four costs and one benefit. Cost to write, cost per run multiplied by runs per day, cost per false failure in attention and trust, and cost per escaped defect the layer was supposed to catch. The benefit is the probability it catches its class before the class becomes expensive.

Run that arithmetic and the pyramid holds for one reason only, which is that cheap deterministic tests can run often enough to shorten the feedback loop. It stops holding where the service's risk is not in its logic. A thin service that is mostly wiring, serialization and calls to other services has almost no unit-testable risk, and a heavy unit layer there buys mock maintenance and false confidence. For that shape the portfolio inverts toward contract and integration tests, and saying so is more honest than defending the shape of the diagram.

Three questions settle the mix for any given service. Where does this service's risk actually live, in its own logic or in its boundaries. Which failures would reach a customer rather than a dashboard. What does a false failure cost here, given how many people wait on this pipeline.

## Contract testing

Contract tests convert a late integration defect into an early local failure, and late integration defects are the dominant escaped class when teams deploy independently. That makes them the highest-return layer in a service fleet once they are actually adopted, which is the whole difficulty.

They work only with discipline on three points. The contract is owned by one side and versioned, provider verification runs in the provider's own pipeline rather than as a courtesy, and a broken contract blocks the provider rather than the consumer, otherwise the consumer absorbs a cost it did not cause. Without provider-side verification the suite becomes documentation that lies with confidence.

Price the adoption before recommending it. It needs a broker or contract repository run as a platform with a named owner, a pipeline change in every provider team, and a negotiated ownership rule per contract, and the provider pays a cost the consumer asked for, which makes each contract a bilateral negotiation repeated across the fleet. The failure mode is a consumer writing contracts no provider verifies, which yields documentation that lies with confidence. So bound the claim. It is the highest return per engineer-hour once provider-side verification runs on more than a small minority of providers, and below that it is a platform bet rather than a test layer. The signal that adoption is working is provider builds failing on consumer contracts.

Schema and event contracts need the same treatment as request contracts. Compatibility direction follows deployment order, and an event consumer that cannot tolerate an added field is a defect in the consumer.

## Flake economics

A flaky test is not a bad test, it is a tax with compounding interest. Each flake costs a rerun, the wall clock of that rerun for everyone in the queue, and a small permanent reduction in how carefully the next red build is read. Past some rate the suite stops being read at all and every gate above it becomes theater, and where that rate sits here is read from the org's own rerun and red-build behavior rather than from a published number.

The policy that works is mechanical. Detect flakiness by rerun behavior rather than opinion, quarantine on a rule rather than on argument, and give the quarantine an owner and an expiry so that quarantine is not a burial. Track quarantine count as a first-class health number, because a growing quarantine is coverage leaving the building. Retry logic hides flakes and should be visible in the report when it fires, not silent.

The root causes cluster narrowly. Shared mutable state between tests, real time and sleeps, test order dependence, unpinned external dependencies, and an environment that is not actually isolated. Each has a structural fix, and each is cheaper to fix than to carry.

## Coverage, mutation and the limits of counting

Coverage is a diagnostic, not a gate. It answers which code no test executes, which is genuinely useful, and it says nothing about whether the assertions are meaningful. As a gate it produces tests written to touch lines, which is worse than no gate because it consumes effort and manufactures the appearance of safety. The defensible use is a ratchet on new code plus a review of what is uncovered, with the numbers read rather than the threshold enforced. Where a control standard mandates a threshold, satisfy it rather than argue with it, and remove the incentive it creates. Enforce it on new and changed code only, report mutation score on the in-scope set as the compensating evidence that the assertions are real, and take the argument for changing the standard to parvis-risk-regulatory, which owns the control, rather than quietly under-enforcing it.

Mutation testing answers the question coverage cannot, meaning whether the assertions catch a change in behavior. It is expensive, so it pays where the cost of a silent wrong answer is high, such as pricing, entitlement, ledger and risk calculations, and it does not pay across a whole fleet. Run it on the narrow set that matters, on a cadence rather than per commit.

## Where the other test types belong

Performance testing catches order-of-magnitude regressions reliably and small regressions only with a stable environment and enough runs to see through the noise. Present it that way rather than promising precision the setup cannot deliver. Load tests against shared environments measure the environment.

Resilience testing, meaning dependency failure, latency injection and partial failure, belongs after the service is deployed somewhere realistic, and its findings usually land as design defects rather than test failures, which routes them to parvis-software-engineering.

Data quality tests belong in the pipeline that produces the data, not in the service that reads it, and they assert on distribution and referential shape rather than on individual rows.

Migration dry runs and revert rehearsals are tests. They are the only evidence that the rollback path works, and they are the ones most often skipped.

## Evaluation gates for non-deterministic components

A stage that gates on a model evaluation behaves like a flaky test unless it is designed differently. The result is a distribution rather than a pass, so the gate needs a sample large enough for the comparison to mean something, the evaluation set pinned by version in the artifact's provenance, and a stated tolerance that separates noise from regression.

A change in the evaluation set or in a judge is a version change that forces a re-baseline, not a result to be read against yesterday's number. Override policy matters more here than anywhere else, because a threshold nobody can meet is bypassed on the first urgent release and never restored. The evaluation's design, its golden set and any judge bias belong to parvis-ai-engineering. The stage, its flake policy and its override record belong here.

## Code review as a practice

Review is good at a specific list. Intent against implementation, missing failure handling, naming and comprehensibility for the next reader, blast radius, and whether the change belongs in this system at all. It is poor at the classes a machine finds faster, meaning style, common defect patterns, dependency policy and formatting, and every minute spent on those is a minute not spent on the first list. Move what a machine can do to the machine, then hold reviewers to the judgment work.

Size dominates everything else. Review quality falls as a change grows, and the long-standing industry reference point puts effective inspection at roughly 200 to 400 changed lines in one sitting, with defect detection dropping off past that [verified 2026-09-20 against SmartBear's published write-up of its Cisco code review study, smartbear.com/learn/code-review/best-practices-for-peer-code-review]. Treat it as a starting line rather than a law, since the org's own approval latency against its change-size distribution is what settles where its line sits. Large changes need either a split or a different treatment, such as a design review before the code exists or a walkthrough rather than a line-by-line pass.

Latency is the second lever. Time to first review is the number that determines whether the author is still holding the context, and a queue measured in days converts every review into a re-learning exercise for both sides. Routing by ownership with a small number of eligible reviewers and an explicit backup, plus an expectation on first-response time, fixes more than any checklist.

## Review failure modes at scale

The rubber stamp, where approval is a social act and the defect classes the review claims to catch are never actually checked. Detect it by comparing approval latency against change size, and by whether reviews ever produce substantive comments.

Reviewer concentration, where a small group approves a disproportionate share of changes. It looks like quality and behaves like a queue, and it is a single point of failure for both delivery and knowledge.

Ownership gaps, where a directory has no owner and reviews are assigned by availability. Those areas accumulate the defects nobody feels responsible for.

Size distribution hidden by averages. The mean change size is uninformative when the tail contains the changes that matter, so read the distribution.

Rework loops, where the same change cycles through many review rounds. That usually signals a missing design conversation earlier, not a slow reviewer.

Each of these is a practice defect with a lifecycle fix. None of them is evidence about a named individual, and a request to use review data that way is declined and pointed at parvis-people-leader.

## What to ask before redesigning either

Escaped defect classes over the last period and where they were caught, suite runtime and false-failure rate per layer, quarantine count and age, time to first review and review round counts, change size distribution, and which services carry the risk that justifies the heavier layers. Anything not supplied stays `[X]`.

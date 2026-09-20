# Delivery maturity rubric

*Load-on-demand reference for parvis-sdlc's maturity assessment mode. Grades describe observable evidence, never adjectives, and nothing is graded from impression.*

## The ten dimensions

Branch and integration. Code review. Testing portfolio. Pipeline. Quality gates. Release and rollback. Environments and test data. Inner loop, meaning the developer's local edit and verify cycle. Supply chain, meaning provenance, signing, dependency intake and secret brokerage. Change and release governance, meaning change classes, the approval path, the evidence trail and how freezes are handled.

Inner loop and supply chain are graded apart because they share no owner, no evidence class and no remediation, so folding them builds in exactly the average this rubric refuses under confidence and scope. Change and release governance is on the list because internal audit grades the org on it whether or not this rubric does.

## The four levels, defined once

Level 1 means the practice varies by team and nobody can say what it is across the estate.

Level 2 means a standard exists and some teams follow it, with adherence unknown or uneven, and exceptions granted informally.

Level 3 means the standard is the default path, adherence is visible from the system rather than from a survey, and exceptions are explicit, owned and time-bounded.

Level 4 means the practice is instrumented against outcomes, the org can show where it failed and what changed as a result, and the standard has been revised at least once on that evidence.

Level 4 is rare and it is not the target for every dimension. Recommending level 4 where level 3 holds the risk is how delivery programs consume years.

## What each level demands as evidence

Level 2 needs the written standard and one example of it in use. Level 3 needs a system-produced view of adherence across the estate, such as a policy report or a configuration scan, plus the exception list with owners and dates. Level 4 needs the outcome series, at least one documented case where the practice failed, and the revision that followed.

A claim without its evidence class is not a grade. Record the dimension as `ungraded` with the evidence request attached and move on. Ungraded is an honest state and appears in the assessment as one, never as a low grade and never as an estimate.

## What proves level 3, per dimension

The rubric's evidence classes are generic, so each dimension names the artifact that settles its own grade. Branch and integration, a branch-protection configuration scan across the estate with its exception list. Code review, a system report of approvals against the ownership map. Testing portfolio, suite composition and false-failure rate reported per service from the pipeline rather than from a survey. Pipeline, stage timings and success rates across the estate. Quality gates, override records carrying approver identity and reason. Release and rollback, revert rehearsal records per release train. Environments and test data, an environment inventory with drift assertions and the masking evidence per extract. Inner loop, local verify time measured from tooling. Supply chain, admission-policy verification results across deployed artifacts. Change and release governance, change records generated from build metadata and sampled end to end. Where the owner's toolchain decides what the artifact looks like, write `[X]` rather than inventing one.

## What to ask before grading

Which repositories and services are in scope, and which are deliberately out. What the written standards say, in their own words. What the systems report about adherence, as opposed to what people believe. Where exceptions live and who granted them. What escaped in the last period and where it should have been caught. What changed since the last assessment, and whether the two changes named last time landed.

Grade only the dimensions the evidence covers. A four-dimension assessment with evidence beats a ten-dimension assessment with six guesses, and the gap itself is a finding worth reporting.

## Confidence and scope

Each grade carries its confidence, high where system-produced evidence covers the estate, medium where evidence covers a sample the owner believes is representative, low where it rests on a small number of examples. Where practice differs sharply between parts of the estate, report the split rather than an average, since an average across a strong platform and a weak long tail describes neither and hides the work.

## Choosing the two highest-return changes

Exactly two, and in this order of selection.

Constraint first. The change that relieves the binding constraint on flow or on escaped defects beats any change that improves a dimension nobody is waiting on. A level 2 dimension that is not on the critical path can stay at level 2.

Reversibility second. Prefer the change that can be withdrawn if it fails, and treat any change touching the change-control expectation the owner skill records as one-way until that expectation is confirmed.

Adoption cost third. Price it in engineer-hours across the teams that must adopt, not in the platform team's build effort, since adoption is where these programs actually die. A change with no migration path and no owner is not a candidate whatever its return.

Each of the two carries a price, the failure mode it is expected to remove, and the signal that will show whether it worked. Both are written into `delivery-practice.md` with the date so the next assessment can check whether they landed, which is the only thing that makes these grades calibratable rather than decorative.

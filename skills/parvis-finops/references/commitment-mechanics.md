# Commitment mechanics

*Load-on-demand companion to `parvis-finops`. Read before any commitment, coverage, discount or effective-rate question. Every figure in an output is `[user-input]` or `[X]`, never estimated. This file holds mechanic classes and decision procedure rather than a catalog of instruments, because a catalog stales faster than a release cycle and a stale catalog is worse than none.*

## 0. Verification block, read first

Everything about what an instrument is called, what it covers, what it discounts and what it costs is time-sensitive. Nothing in the next sections may be quoted to anyone as current without a live check this session. What is durable is the shape of the choice, not the product.

Re-check in this order, because the later items only matter if the earlier ones still hold.

1. **Recoverability.** Whether the instrument can be returned, exchanged, traded in, cancelled or resold, within what window and up to what value. This is the single input that decides how much of the floor is safe to commit, and it is the item that changed most recently on every cloud.
2. **Coverage scope.** Which services, regions, families and account boundaries an instrument applies across, whether the discount shares across a billing family or stops at the purchasing account, and which usage no instrument can discount at all, since spot and preemptible capacity is excluded on more than one cloud ([verified 2026-09-20], AWS decision guide on choosing an EC2 purchasing option, and Google Cloud committed use discount documentation).
3. **Term and payment structure.** Which terms are on offer and what the payment options are. Never the rate.
4. **Program interaction.** Whether an enterprise agreement, private pricing or a marketplace commit consumes, stacks with or excludes instrument-level commitments. This is contract-specific and the contract governs, so it is a question for the user's sourcing and account team rather than a public page.
5. **Deprecations.** Any family, generation or service scheduled to retire inside the term under consideration.

**Verified this session [verified 2026-09-20], from the vendors' own documentation.** These are the published general terms. The user's agreement may override any of them, and where the two disagree the contract governs, so every one of these is confirmed against the contract before it is used in a recommendation.

- AWS Savings Plans can be returned only where the hourly commitment is $100 or less, the purchase was made in the last seven days and in the same calendar month in UTC, and the account's return limit has not been reached. Upfront charges refund in full. Once the calendar month ends the plan can no longer be returned. Source, AWS Savings Plans user guide, "Returning a purchased Savings Plan".
- Azure reservations purchased on or after 1 February 2027 will not be exchangeable where the corresponding service is covered by savings plans, which includes virtual machines, App Service and SQL Database. Reservations purchased before that date keep one final exchange. A renewal is processed as a cancellation plus a new purchase, so an auto-renewal landing after that date produces a non-exchangeable reservation. Trade-in to a savings plan is unchanged. The cancellation policy is unchanged, with total cancelled commitment capped at $50,000 USD in a rolling twelve months per billing profile or enrolment. Source, Microsoft Learn, "Changes to the Azure reservation exchange policy", page dated 2026-08-27.
- Google Cloud committed use discounts cannot be cancelled after purchase, and this holds for both the resource-based and the spend-based or flexible forms. Source, Google Cloud documentation on committed use discounts and on spend-based commitments.

**Not verified this session, labeled `[model]` and to be confirmed before use.** That AWS offers no resale, transfer or exchange path for Savings Plans outside the return window. That AWS Standard Reserved Instances can be listed for resale on a marketplace while Convertible Reserved Instances can be exchanged mid-term subject to value matching. Both are widely reported and both would change a recommendation materially, so neither is quoted without a live check.

## 1. Mechanic classes

Instruments differ by what they lock, and the lock is what prices the discount. There are five classes, and every commitment instrument on every cloud is one of them wearing a brand name. Not every cloud discount is a commitment, and the sixth item is the exception.

- **Resource-shape lock.** The commitment names a resource shape, meaning a family, size, region or platform, and discounts usage that matches it. It buys the deepest discount and carries the worst stranding risk, because any change to the shape orphans the commitment. Its failure mode is a migration or a generation refresh inside the term.
- **Spend-rate lock.** The commitment is an amount of spend per hour or per month, applied automatically across whatever eligible usage exists. It trades discount depth for shape flexibility, and its failure mode is a demand collapse rather than a shape change, because nothing can rescue a commitment when there is no usage to apply it to.
- **Aggregate spend lock.** The commitment is a total over the term, usually attached to an agreement, with no hourly floor. It is the most forgiving of shape and timing and the least forgiving of a wrong total, since a shortfall is settled at the end rather than absorbed hour by hour.
- **Capacity lock.** The commitment reserves capacity in a zone, with or without a discount attached. It is bought for availability, not for price, and it is a mistake to underwrite it as a discount instrument. Its cost of being wrong is idle reserved capacity nobody can release.
- **Licence-carried lock.** The commitment rides on a licence or subscription entitlement rather than on infrastructure. It is priced and recovered under the publisher's rules, not the cloud's, so its mechanics belong to `parvis-itam` and its economics come back here.
- **No lock at all, and no commitment.** One cloud discounts usage automatically for running enough of the month, nothing purchased and no dimension frozen, up to 30 percent on the eligible families above roughly a quarter of the billing month ([verified 2026-09-20], Google Cloud sustained use discount documentation). Where it applies the `[R_od]` in section 5 is not list price for a sustained workload, so a break-even against list overstates the commitment, sometimes by most of the headline advantage.

The only class question that matters at decision time is which dimension is frozen. Ask the user which of shape, rate, total and capacity they are willing to freeze for the term, and the class follows without naming a product.

## 2. Coverage, utilization and effective rate

These three are confused constantly, sometimes deliberately, and each hides a different failure.

- **Coverage** is the share of eligible usage that a commitment discounted. Low coverage means money was left on the table. It says nothing about whether the commitment was a good idea, because coverage falls on its own as usage grows against a static position, and a team can raise it simply by buying more.
- **Utilization** is the share of purchased commitment that was actually consumed. Low utilization means commitment was bought and wasted. It is the one that rises whenever usage grows into an under-consumed commitment, which is why a rising utilization trend is not evidence the buy was right, and it says nothing about whether the rest of the estate is discounted.
- **Effective rate** is what was actually paid per unit after everything applied. It is the only one of the three that answers the question finance asks, and it is the one nobody reports, because it requires joining the commitment ledger to the usage ledger.

The failure each hides. High coverage hides low utilization when the position is larger than the eligible usage it can reach, so almost everything is discounted while part of the commitment is never drawn down, and the shape or scope mismatch is invisible in the coverage number. High utilization hides low coverage, and is the reading a cautious team produces by under-committing, which looks disciplined and is expensive. A good effective rate hides a shape mismatch, because an aggregate rate averages across workloads and conceals one workload paying on-demand while another over-covers.

Report all three or none. A single number from this set, presented alone, is a claim that should be challenged on sight, and the lens in the skill blocks on it.

## 3. The floor comes from the trough

The coverage floor is the level of demand that will exist under every scenario the user is willing to underwrite. That is the trough of the demand curve over the term, not the average and not the current run rate.

Procedure. Take the usage series at the granularity the instrument bills at, since an hourly instrument against a daily average hides every night. Filter before subtracting anything, removing usage no instrument can discount, meaning spot and preemptible capacity, usage an existing commitment already covers, and usage outside the purchasing scope. A trough taken from total compute on a spot-heavy fleet is a floor nothing can reach, and the position bought against it sits at low utilization for the whole term. Strip the growth the user is not certain of. Subtract the workloads with a known exit inside the term, meaning a migration, a decommission, a re-platform or a contract that ends. Subtract the demand that exists only because of a scheduled event, such as a seasonal peak or a regulatory cycle. What remains is the floor. Commit to some fraction of the floor, never to the floor itself, and the fraction is the user's risk appetite rather than a number this skill supplies.

Two traps. A trough computed on a series that already contains a scheduled non-production shutdown will understate the floor, and the shutdown is under the org's control so it can be reversed. A trough computed across an aggregate hides a per-region or per-family trough that is much lower, and a shape-locked instrument fails at that lower level rather than at the aggregate.

## 4. Laddering and expiry spread

Buying the whole floor on one day creates a single expiry date, and on that date the entire position is re-priced at once, under whatever market and contract conditions exist then, usually a few weeks before the user finds out. Laddering breaks the position into tranches with staggered start dates so that only a fraction expires in any quarter.

What laddering buys is optionality, not discount. Each tranche is smaller, so each is easier to decline, resize or let lapse without a cliff. What it costs is administrative load, a tracking obligation and, where a deeper discount is tied to a larger single purchase, some rate. Name that cost.

Construction rules. Set a maximum share of the total position that may expire in any single quarter, and treat a breach as a purchase constraint rather than a reporting line. Align tranche boundaries away from the enterprise agreement's own anniversary, so a commitment cliff and a negotiation do not land in the same month and hand the account team both. Where an auto-renewal exists, treat it as a purchase decision with a date, not as a default, because on at least one cloud an auto-renewal is processed as a cancellation and a new purchase and inherits the terms in force on the renewal date rather than the ones in force at original purchase.

## 5. Break-even, payback and the arithmetic

All inputs are `[user-input]` or `[X]`. The skill does the algebra and the user supplies the numbers.

Let `[R_od]` be the on-demand rate for the usage in question, `[R_c]` the committed rate, `[Q]` the committed quantity per period, `[T]` the term in periods, and `[U]` the expected utilization as a fraction.

- **Break-even utilization** is the utilization at which the commitment stops beating on-demand, and it is `[R_c] / [R_od]`. Below it the position loses money. This is the number to quote, because it converts a discount percentage into a demand requirement, which is what the decision actually turns on.
- **Expected saving over the term** is `([R_od] x [U] - [R_c]) x [Q] x [T]`, minus any recovery cost incurred on exit. Utilization sits inside the saving term rather than beside it because the commitment is paid in full whether or not it is drawn down, so this returns zero at the break-even `[U]` of `[R_c] / [R_od]` and turns negative below it.
- **Payback** applies only where an upfront payment exists, and is the number of periods until cumulative saving exceeds the upfront. It matters for cash, not for the decision, and it is reported to finance rather than used as the test.
- **Cost of being wrong high** is the commitment paid for and not used, which is `[R_c] x [Q] x [T] x (1 - [U])`, less whatever is recoverable under section 6.
- **Cost of being wrong low** is the on-demand premium paid on the uncommitted floor, which is `([R_od] - [R_c]) x [Q_uncommitted] x [T]`.

Both directions are always stated. A recommendation that prices only the downside of committing is an argument for under-committing dressed as prudence, and it has a cost too.

## 6. Recoverability, and what it is worth

Recoverability is the difference between a decision and a bet. Five exits exist, and each cloud offers a different subset, which is why section 0 re-checks this first.

- **Return inside a window.** A short grace period after purchase, usually capped by value and by count, existing to correct a purchase error rather than a forecast error. Worth planning around only for the first few days.
- **Exchange.** Swapping the commitment for a different shape, usually at equal or greater value and usually resetting the term. Where an exchange is processed internally as a cancellation plus a new purchase, the replacement inherits whatever rules are in force on the exchange date, which can be stricter than the ones the original was bought under.
- **Trade-in.** Converting a shape-locked instrument into a spend-rate instrument. Where this exists it is the most useful exit, because it converts stranding risk into rate risk.
- **Cancellation with refund.** Usually capped in aggregate over a rolling window across the whole billing scope, which means one business unit's cancellation consumes the headroom another may need. Track the cap centrally or it is not a real exit.
- **Resale.** A secondary market, where one exists at all, and only for some instrument classes. Price realized is not price paid.

The rule for the recommendation. Compute the position twice, once assuming every exit works and once assuming none does, and present the gap as the value of the recoverability assumption. Where that gap is large, the recommendation is not about coverage at all, it is about which instrument class to use, and that is a cheaper conversation.

## 7. The stranding scenario set

Price each of these as a separate scenario, with what is recoverable named per section 6 and what is not stated as a loss.

Migration off the committed shape, whether to another cloud, to managed services or to a different family. Deprecation of a family or generation by the provider inside the term. Refactor to serverless or to a service the instrument does not cover. Demand loss from a product decision, a client exit or a regulatory change. Consolidation of accounts or billing families that changes which usage the commitment can reach. A reorganization that moves the workload to a business unit with its own agreement.

For each, name what breaks first and the signal that would show it early, which is usually utilization trending down two months before anyone notices the bill.

## 8. Where this stops

The amount, the term, the payment option and the instrument are a purchase, and a purchase goes to `parvis-vendor-eval` and to Finance with the floor derivation, the usage evidence and this scenario set attached. Who signs is named in the handoff, and where governance requires sourcing, legal or a delegated authority to approve a multi-year financial commitment, that route is named rather than assumed.

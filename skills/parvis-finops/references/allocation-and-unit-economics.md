# Allocation and unit economics

*Load-on-demand companion to `parvis-finops`. Read before any allocation, showback, chargeback, unit-metric, forecast or variance question. Every figure in an output is `[user-input]` or `[X]`. The rate-usage-mix decomposition is not repeated here, because it lives in the skill where it is used.*

## 1. Allocation method, in the order that survives

Allocation fails from the bottom, so build it in this order and stop at the first layer the org will not fund.

**Structure.** Accounts, projects, subscriptions and the organizational units above them are the only allocation a deploy cannot undo. A resource inherits its account whether or not anyone remembers to label it. Design the boundary to match the thing that will be held accountable, which is usually a team with a budget rather than a product, because products get renamed and reorganized more often than budgets move. The cost of a fine-grained boundary is network, identity and operational overhead per account, and someone absorbs that, usually the platform team.

**Taxonomy.** Tags and labels refine what structure cannot separate, meaning environment, component, cost centre and data classification. Keep the required set to what someone will actually enforce, which in practice is three to five keys. Every additional required key lowers compliance on all of them, because a team that cannot satisfy the whole set stops trying.

**Enforcement.** A taxonomy without an enforcement point decays to whatever the last engineer typed. The options, in descending order of effectiveness and ascending order of unpopularity, are refusal at provisioning, quarantine after a grace period, automatic attribution to the creating identity, and a report. Only the first three change behavior. Each one's false-positive cost lands on a specific rotation, so name the rotation before proposing the control.

**Measurement.** The allocable share of spend is measured, not asserted. Compute it as the fraction of billed cost that lands on a named owner with no judgment applied, report it as `[user-input]` or `[X]`, and track it as the health metric for the whole model. A showback model built on an unmeasured allocable share will be challenged on its first contested month and will lose.

**Backfill.** Historic untagged resources are the expensive part. Decide explicitly whether to backfill, attribute by account, or declare an amnesty date and allocate everything before it to the shared pool. All three are defensible. Leaving it undecided means re-arguing it every month.

## 2. Shared and untaggable pools

Every estate has cost that belongs to no single team. Inventory it explicitly rather than letting it accumulate in an "unallocated" line, because an unallocated line grows until it discredits the model.

The recurring pools are support and premium-support fees, private network and interconnect, shared data platform and its storage, security and observability tooling, identity and directory services, the control plane and management tier, licence and subscription cost that rides along, and the commitment adjustments that do not map cleanly to a consuming team.

Each pool gets one spreading rule, chosen from four, and each rule has a different loser.

- **Even split.** Cheap to compute, easy to explain, and wrong for every team smaller than average. The loser is the small team, and it will say so.
- **Proportional to direct spend.** The default, and defensible because it is monotone. Its flaw is that it charges the efficient team less only because it is smaller, and it charges a team that cut its spend an unchanged share of the pool.
- **Proportional to a driver.** Split by whatever actually drives the pool, such as seats for tooling, ingest volume for observability, or transactions for the data platform. It is the most accurate and the most expensive, because the driver has to be measured and the measurement has to be trusted.
- **Held central.** The platform or central function absorbs the pool and does not spread it at all. It is honest, it keeps the model simple, and it makes the platform budget look enormous, which is a political cost paid by whoever owns that budget.

The rule that matters more than the choice. A spreading rule is accepted by the receiving teams before it ships, or it is re-litigated every month, and the arbitration load lands on whoever owns the model. Write the rule down with the objection it is expected to draw and the answer to that objection.

## 3. Kubernetes attribution

A cluster bill is a bill for nodes, and everything below that is an allocation. There is no exact answer, so the method is chosen openly and reported with its error bar.

The two candidate bases. **Requests** charge a workload for what it reserved, which is what actually consumed schedulable capacity, and it holds teams accountable for over-requesting. **Usage** charges for what was consumed, which feels fairer to the workload and leaves the gap between requests and usage unallocated. Most estates land on requests, or on the maximum of requests and usage, precisely because over-requesting is the behavior the model is trying to change.

The unavoidable residual is the difference between node cost and the sum of all workload charges, made up of idle capacity, headroom held deliberately for burst and failover, system and daemonset workloads, and control-plane cost. Handle it with one named rule, either spreading it proportionally across workloads or holding it centrally as the price of running a cluster. Holding it centrally is the more honest reading, because idle capacity is mostly a platform sizing decision rather than a tenant behavior, and it shows the platform team what its headroom policy costs.

The error bar is real and should be stated. Sources of error are the requests-versus-usage gap, shared storage and network that the cluster bill does not attribute, spot and preemptible price variation inside a billing period, and autoscaler churn within the measurement window. A Kubernetes split reported without an error bar invites a challenge that the model cannot answer, and the skill's allocation-auditor lens blocks on it.

## 4. Serverless and managed services

Serverless allocation is usually easier, because invocation and request-level billing already carries an identity. The traps are elsewhere. Cost sits in the services around the function rather than in the function, meaning the queue, the gateway, the log pipeline and the data store. A retry storm attributes to the caller while the cost lands on the callee. And log and trace volume, which nobody allocates, is often the larger line.

Managed data services resist attribution by design, because the whole point is that several consumers share one engine. Choose the driver deliberately. Query cost attributes to the querying identity, which is accurate and punishes the analyst rather than the team that chose the schema. Storage cost attributes to the dataset owner, which is accurate and unhelpful when the owner is a platform team. Idle or provisioned capacity attributes to nobody, which makes it a shared pool under section 2.

## 5. Defining a unit

A unit metric is a ratio, and both halves are contested.

**The denominator test.** Choose a denominator the business already argues about in its own meetings, such as transactions, accounts, claims, trades, active users, tenants or model calls. A denominator invented for the cost metric requires an instrumentation project and a credibility campaign before anyone will use it, and by then the question has moved on. Where the honest denominator does not exist, say so and name the one number the user would have to start counting.

**The inclusion rule.** Write down, explicitly, which cost is in the numerator. Direct infrastructure is always in. Then rule on each of the shared pools, on licence and subscription cost, on the people cost of running the service, on commitment amortization, and on the cost of non-production environments. There is no universally right answer, and there is a universally wrong practice, which is leaving the rule implicit so it can be adjusted when the number is unflattering.

**Amortization.** State whether committed spend enters the unit at its amortized rate or at the cash rate. Amortized is the better reading of economics, cash is the better reading of the budget, and the two diverge most in exactly the quarter someone asks.

**Total beside the unit, always.** A unit cost falling while total spend rises is the most common outcome of a growth quarter and the most common way a weak efficiency programme defends itself. Report both, every time, without being asked.

The definition, the baseline, the target and the gameability check hand off to `parvis-metrics-advisor` once the metric is going to be reported upward. What stays here is the economics behind the movement and the levers that move it.

## 6. The gaming traps

Each of these is an observed pattern rather than a hypothetical, and each is reported when seen rather than assumed to be malicious.

- **Metric gaming.** Denominator inflation, numerator migration and baseline shopping belong to the gameability check handed to `parvis-metrics-advisor` in section 5, and are not re-derived here.
- **Avoidance as reduction.** A saving that never appears in a budget line is reported as a saving. Cost avoidance is legitimate and is labeled as avoidance, and it never nets against a run-rate target.
- **Double counting across levers.** The same workload is credited once to a rate lever and once to a usage lever. Test by reconciling the sum of claimed savings against the actual change in effective rate and volume.
- **The unallocated drain.** Whatever cannot be attributed grows quietly and is never reported. Test by tracking the unallocated share as a first-class number with a target and an owner.

## 7. Forecast and anomaly, briefly

Forecast from drivers, not from the past, and model the migration and decommission plan and the commitment expiry schedule as their own series. State a band, and name the two assumptions the band depends on most.

Anomaly thresholds use absolute and relative movement together, because a relative threshold alone pages on small accounts and an absolute threshold alone misses a large one degrading slowly. Suppress known events by name and date. Every alert names its response owner, and an alert nobody owns is deleted rather than tuned.

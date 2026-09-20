# Incident comms templates, fill-in-blank

*Skeletons for the executive track. Every `[X]` is a blank to fill from known facts, never invented (T2). Adapt lengths down, not up. The discipline is what's absent, no cause speculation, no blame, no unowned commitments.*

## T+15, first executive notice (~80 words)
> **[SEV-X] declared [time]: [one-line impact statement or "impact being assessed"].**
> Known: [what is confirmed, systems, customer-facing or not, scope if known].
> Unknown: [scope / cause / duration, named plainly].
> [Name] has technical command. [action underway].
> Next update: [time, commit to a clock and keep it].

## T+60 and recurring updates (~120 words)
> **[SEV-X] update [time], [status: degraded / partially restored / restored, or "unchanged"].**
> Impact: [who, how many, how long, quantified or explicitly still being sized].
> Since last update: [what changed. "no material change, investigation continuing on [track]" is a valid and honest line].
> Now underway: [current action]. Root cause: under investigation [never more than this until the review].
> Next update: [time].

## Resolution notice (~100 words)
> **[SEV-X] resolved [time]. Duration: [detection to restoration].**
> Final impact: [quantified: customers, transactions, duration, or "final sizing by [date]"].
> Service restored via [containment action, the what, not yet the why].
> Root-cause review underway. Executive readout by [date].
> [Only if true:] No indication of [data exposure / transaction integrity impact] based on current evidence. Verification continuing.

## Audience adaptations
- **Regulator track:** facts and timestamps only, every claim evidenced, nothing forward-looking without a named owner and date, drafted for the regulatory-affairs partner to review before sending, always.
- **Partner track:** impact to *their* integration specifically, their escalation contact, no internal detail beyond need.
- **Internal-broad (if used):** what happened, customer impact, where to route questions, no timeline theatrics.

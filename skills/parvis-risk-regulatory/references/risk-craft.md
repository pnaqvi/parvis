# Risk craft

*Load-on-demand companion to `parvis-risk-regulatory`. Schemas for the four registers, the pulse signals, and the working procedures for exam prep, remediation review, risk acceptance, cyber posture and AI governance. Every rule in the skill's "three rules that come first" applies to everything here.*

## 1. Schemas

### issues-ledger.md

| ID | Source | Theme | Finding (user's paraphrase) | Severity | Owner | Opened | Milestones (baseline → forecast) | Due (baseline → current) | Extensions | State | Validation | Last reviewed |
|---|---|---|---|---|---|---|---|---|---|---|---|---|

- **ID** is the organization's GRC or issue-management identifier. A row without one is marked `no-ID` and flagged until it has one.
- **Source** is exactly one of `regulator`, `internal-audit`, `second-line`, `external-assessment`, `self-identified`. Self-identified rows carry what found them, such as an incident reference or a tabletop.
- **Theme** is a short stable tag (for example `DR testing`, `privileged access`, `change management`, `third-party`, `AI controls`) so repeat findings are visible across sources and years.
- **Severity** uses the issuing function's own scale, recorded as given. Nothing is re-rated here.
- **Milestones** list each with its baseline date, which is immutable, beside its current forecast. The due date works the same way.
- **Extensions** count granted extensions, each noted with its approver and date in the row's notes line.
- **State** takes one value from `open`, `remediating`, `remediation-complete`, `in-validation`, `closed-validated`, `validation-failed`. Past due is computed from dates rather than stored.
- A closed row stays for a year, then rolls to `archive/issues-YYYY.md`.

### risk-register.md

| ID | Risk (cause, event, consequence) | Category | Inherent | Key controls | Residual | Appetite | KRI (value, threshold, date) | Treatment | Acceptance (approver, date, expiry) | Owner | Last reviewed |
|---|---|---|---|---|---|---|---|---|---|---|---|

- **Category** is one of `resilience`, `technology`, `cyber`, `third-party`, `data`, `AI`, `change`.
- **Ratings** use the organization's methodology and scale, recorded in the owner skill or supplied by the user. Before one exists, the cells read `[scale?]` and nothing is rated.
- **Treatment** is one of `mitigate`, `accept`, `transfer`, `avoid`. An `accept` row must have all three acceptance fields filled.
- **Appetite** reads `within`, `outside` or `unset`, and `outside` without an acceptance or an active mitigation is always a pulse flag.

### exams.md

| Engagement | Type | Scope and theme | Lead (role) | Window | Request list due | Prep state | Filed prep | Outcome |
|---|---|---|---|---|---|---|---|---|

Type is one of `regulatory-exam`, `internal-audit`, `second-line-review`, `external-assessment`, `tabletop`, `attestation`. Prep state is one of `not-started`, `scoping`, `requests-in-flight`, `narrative-drafted`, `murder-boarded`, `ready`. Outcome records the resulting issue IDs, or "no findings".

### ai-inventory.md

| Agent or use case | Business area | Autonomy tier | Actions it can take | Human checkpoint | Kill switch | Blast-radius limit | Decision logging | Pre-deployment evaluation | Model-risk status | Owner | Last attestation | Next due |
|---|---|---|---|---|---|---|---|---|---|---|---|---|

- **Autonomy tier** uses the organization's tiering where one exists. Otherwise it's one of `advisory` (a human acts), `supervised` (acts with human approval per action), `bounded` (acts alone inside hard limits) and `autonomous` (acts alone, reviewed after the fact).
- Each control cell reads `evidenced <date>`, `asserted` or `absent`. `asserted` is a gap until evidence exists.

## 2. Risk pulse signals

Report only what fires, each with its owner and a one-line route to a mode.

1. A remediation due within 90 days whose last evidence of progress is more than 30 days old.
2. A milestone whose forecast has slipped past its baseline.
3. A `validation-failed` row, or any row with two or more extensions.
4. A theme with findings from two or more sources, or reopened within 24 months. Repeat findings are the pattern examiners escalate.
5. An acceptance expiring within 60 days, or already expired.
6. A KRI outside its threshold, or a risk `outside` appetite without treatment.
7. An engagement in `exams.md` starting within 90 days with prep `not-started`, or a request list due within 14 days.
8. An agent past its attestation date, or any `autonomous` or `bounded` agent with a control cell reading `absent`.
9. A register row unreviewed for more than 90 days.
10. The trailing-year share of findings that were self-identified, reported as a count ("3 of 11 self-identified"). Treat it as directional below about ten closed rows. A falling share means the organization is learning about itself from others.

## 3. Exam and audit prep

1. **Scope.** The engagement, its stated scope, and the themes it touches, taken from `exams.md` and whatever scoping letter the user paraphrases.
2. **History.** Every issue on those themes from any source, open or closed within three years, and their current states. Open items on the theme get read first, because the examiner will read them first.
3. **Request readiness.** For each expected request category, name who owns producing it and whether it exists today. Missing evidence is a finding to self-identify now rather than one to be handed.
4. **Narrative.** One page, in this order. What the org does in this area, what it found in itself and what it is doing about it, what has improved since the last engagement with evidence, and what remains open with dates. Leading with its own weaknesses is what makes the rest believable.
5. **Likely questions.** Ten to fifteen, labeled as plausible rather than predicted, each with the user's one-line answer and the evidence pointer behind it.
6. **Evidence index.** A table of claim, evidence, where it lives in the system of record, owner, and as-of date. It holds pointers only, and no evidence is copied into Parvis.
7. **Murder board.** Convene the examiner and internal-auditor lenses at minimum. The checkpoint brings the user the three hardest questions and the weakest claim in the narrative.
8. **After.** Outcomes and new issue IDs go into `exams.md` and the issues ledger. One insight is captured on what the engagement focused on that the prep missed.

## 4. Remediation review checklist

A plan passes when every line is yes, and each no is named with its fix.

- The root cause is stated as a cause, not a restatement of the finding, and the plan addresses it.
- The fix covers the class of problem, not only the instance cited.
- Evidence shows operating effectiveness over a sustained period, not just a design or a one-time run.
- Every milestone has an owner who has accepted it, and the date passes an outside-view check against how long similar remediations actually took here.
- Dependencies on other teams are named, with their owners' agreement.
- The validator's likely test is written down, and the planned evidence would satisfy it.
- The sustainability mechanism (a control, a KRI or an automated check) keeps it fixed after closure.

## 5. Risk acceptance

An acceptance memo states the risk in cause, event and consequence form, its inherent and residual ratings on the organization's scale, why mitigation is not chosen now, the compensating controls in force with their evidence, the KRI and threshold that would force a revisit, the approver at the delegation level the organization's policy requires, and an expiry. An expiry beyond twelve months needs a stated reason. Renewal is a fresh decision with fresh evidence and never a date change. Each acceptance is also a decisions-ledger row carrying its revisit trigger.

## 6. Cyber at the control altitude

| Belongs | Never enters |
|---|---|
| "MFA coverage for administrative access to the platform tier is 94 percent against a 100 percent standard, owner X, target Q4" | which accounts or hosts lack MFA |
| "Patch SLA for critical findings missed on 12 percent of platform assets last quarter" | the CVE list, asset names or exposure paths |
| "Detection coverage mapped to the framework has three unmapped technique families" | which techniques are undetected |
| "Tabletop showed decision authority for isolating a region was unclear" | the playbook's technical steps |

Quantification builds a range from a stated decomposition, meaning how often the event plausibly happens and the loss range when it does, with every input supplied by the user or left `[X]`, and labels the result an estimate. A single point figure is never presented as the answer.

## 7. Frameworks as shared vocabulary

The user's industry, regulators, frameworks and risk rating scale come from the owner skill and are confirmed at initialization. Whichever frameworks the organization actually uses, and their current versions, are confirmed with the user or verified before any document relies on them. Everything below is [model]-tier as of training data.

**Examples for a US bank.** These are illustrations of the kind of list the owner skill should hold, not defaults. An organization in another industry or jurisdiction substitutes its own (for example HIPAA and HITRUST in US healthcare, or DORA in EU financial services).

- **Operational resilience.** The US interagency sound practices paper on operational resilience (2020) and the FFIEC IT Examination Handbook booklets, including business continuity management.
- **Risk governance.** The OCC heightened standards for large banks and the three lines model.
- **Cyber.** NIST Cybersecurity Framework 2.0 and the FFIEC booklets on information security.
- **Model and AI risk.** SR 11-7 guidance on model risk management and the NIST AI Risk Management Framework.
- **Quantification.** FAIR-style decomposition of frequency and magnitude.

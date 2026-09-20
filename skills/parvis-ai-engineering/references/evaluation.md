# Evaluation

*Load-on-demand companion to `parvis-ai-engineering`. Read before any evaluation, validation, golden-set or metric-movement question. Everything applies to classical ML and to LLM systems unless a line says otherwise. Every number in an output is `[user-input]` or `[X]`, never estimated, and every vendor or framework behavior named here is verified live and date-stamped or carries `[model]` (T2).*

## 1. Validation design by data shape

The split is decided by the data's dependence structure, not by convention. A random split is correct only where rows are exchangeable, which is rarer than it looks.

- **Temporal dependence.** Split by time, train before, test after, with a gap that covers the label window so an outcome cannot appear in both sides. Purging removes training rows whose label period overlaps the test period, and an embargo drops rows immediately after the boundary where autocorrelation carries information across it.
- **Grouped dependence.** Where many rows share an entity, customer, device or document, split by group so no entity appears on both sides. Otherwise the model memorizes the entity and the score measures memory.
- **Rare positives.** Stratify, report precision and recall against the operating threshold, and use precision-recall rather than ROC, which flatters a rare-positive problem.
- **Tuning.** Any selection against a split contaminates it. Nest the tuning inside the training folds, and treat the final test set as spent once it has been looked at more than once.
- **Cold start.** Where the deployed system will see entities absent from training, the validation must contain unseen entities in the same proportion.

## 2. Leakage catalog, with the test that detects each class

- **Target leakage.** A feature computed from or after the outcome. Detect by ablation, since a single feature whose removal collapses a near-perfect score is the suspect, and by reading each feature's production availability time against the scoring moment.
- **Temporal leakage.** A feature carrying its current value rather than its value as of scoring time. Detect by reconstructing point-in-time features and comparing scores, since a large drop confirms it.
- **Group leakage.** The same entity or near-duplicate text on both sides. Detect by joining on entity keys across folds and by near-duplicate hashing on text.
- **Preprocessing leakage.** Scalers, imputers, encoders or vocabularies fitted on the full dataset. Detect by refitting inside each fold and comparing.
- **Selection leakage.** Training only on the population that already passed the decision the model will make, such as approved applications. The outcome is observed for a selected subset, so the model learns the old policy. Detect by asking where the unobserved outcomes went, and treat the gap as a known bias rather than a fixable one.
- **Evaluation contamination.** For LLM work, benchmark or golden items present in pretraining or in the few-shot pool. Detect with canary strings, n-gram overlap against the item set, and a holdout authored after the model's stated cutoff, with that cutoff cited by version and date.
- **Test-set reuse.** Repeated model selection against the same test set. Detect by the pattern of small wins that never reproduce online, and fix with a fresh holdout held by someone who is not optimizing.

## 3. Honest baselines

Every evaluation prices at least one baseline on the same slices and the same metric. Candidates are the majority class or last value, the existing rule or process, retrieval with no generation, a smaller or cheaper model, and a human at the same cost. The baseline carries its own operating cost, and a lift that does not beat baseline plus the new system's run cost is a no. Where the baseline was not measured, the result is reported as unbaselined.

## 4. Golden sets

A golden set is a product, with an owner, a version and a refresh cadence.

- **Sampled from production**, not from what is convenient to label, and stratified across the axes that carry different behavior, such as segment, language, document type, query intent, difficulty and recency.
- **Two halves, kept separate.** A random-sample half measures the population. A failure-mined half, grown from what broke, measures regressions. Mixing them makes the aggregate meaningless because the mined half grows without bound.
- **Labeled against a rubric written first**, with two annotators on a subset and measured agreement. A rubric humans disagree on cannot be handed to a judge, and the fix is the rubric, not more annotators.
- **Versioned and frozen.** Changes create a new version with a changelog, so a moved metric can be attributed to the system or to the set.
- **Hygiene.** Golden items never enter prompts, few-shot pools or fine-tuning data. Keep a private holdout that is never sent to any external system, and plant canaries to detect it if it is.
- **Sized per slice** to support the difference that matters, not sized as a round total.

## 5. Slices and guardrails

The aggregate hides what the slice reveals, so every gate is per slice. A release may improve the mean while breaking one language, one document type or one customer segment, and that is the normal way quality regresses. Guardrail metrics run beside the headline and must not move, typically refusal or abstention rate, p95 latency, cost per request, and whatever safety signal the system carries.

## 6. Calibration and the operating threshold

A score used in a decision is a probability claim, and discrimination and calibration are different properties. A model can rank perfectly and still be wrong about how often it is right, which is what a threshold, an expected-loss calculation or a downstream price is built on. Report a reliability curve with a Brier score or expected calibration error rather than accuracy alone, and read the curve where the threshold actually sits rather than on average, since calibration is usually worst in the tail where the consequential decisions are. Recalibrate whenever the operating threshold moves, whenever the base rate moves, and after any resampling or class weighting used to handle rare positives, because each of those breaks the mapping from score to probability while leaving the ranking intact. Calibration is measured per slice for the same reason gates are. For LLM systems the equivalent question is whether a self-reported confidence or a judge score means anything on a reliability curve, and the honest default is that it does not until it has been measured.

## 7. Retrieval evaluation and stage attribution

A retrieval-augmented system has two stages and one visible output, so the first question in any regression is which stage moved. Evaluate the halves separately or the answer is always blamed on the model.

- **Retrieval half.** Recall at the k the generator actually receives, measured on queries labeled with the passages that could answer them, plus a retrievability check asking whether the answer is present in the index at all. A question whose answer was never indexed is a content defect, not a retrieval defect, and the two take different fixes.
- **Generation half.** Groundedness, meaning whether each claim is supported by the retrieved context, and citation accuracy, meaning whether the citation points at the passage carrying the claim. Measure both with retrieval held fixed, and run the generator once on gold passages to separate what it cannot do from what it was never given.
- **Attribution rule.** Recall holds and groundedness falls, the generator moved. Recall falls, the retriever or the index moved. Both fall, suspect the query distribution or the chunking before either component.

A chunk-size, chunk-boundary or embedding-model version change forces a full reindex and changes the behavior of every query at once. It is a breaking behavior change, it passes the same gate as a prompt or model change, and the index version is recorded on the per-request trace beside the model and prompt versions.

A reranker is evaluated on its own lift over the retriever it sits behind, on the same slices and at its own latency and cost. Assumed lift is the usual case, and the lift is often small where recall at the larger k is already high, which makes the reranker a cost line with no defence.

## 8. LLM-as-judge

A judge is a model under evaluation, and it is admissible only after agreement with human labels is measured on a subset, reported as a coefficient with the disagreement pattern described, not as a single percentage.

Biases to name and design against.

- **Position.** Order of candidates changes the verdict. Randomize order and average both orders.
- **Verbosity.** Longer answers score higher. Control by rubric anchors and by comparing length distributions across arms.
- **Self-preference and same-family affinity.** A judge favors output from its own family. Use a judge from a different family than the system under test, and say which family when reporting.
- **Formatting.** Structure and markdown inflate scores. Strip or normalize formatting before judging.
- **Leniency drift.** Judge behavior changes with the judge's own version. Pin the judge model and version, treat a judge change as a breaking change, and recalibrate against the human subset before trusting any comparison across it.

Pairwise preference is more stable than absolute scoring, and discrete rubric anchors are more stable than a one-to-ten scale. A judge is never used to grade a dimension the rubric does not describe.

## 9. Sample size and noise

Start from the smallest difference that would change the decision, then size for it rather than reporting whatever the sample gives. Paired comparison on identical items is far cheaper than unpaired. For LLM metrics, bootstrap a confidence interval over items, and repeat runs where sampling is nonzero so run-to-run variance is reported alongside the difference. A win inside the interval is not a win, and reporting it as one is the most common way an eval misleads.

## 10. Offline to online

Offline predicts online only while the population, the surface and the judge hold still, so the correlation decays and is re-measured on a cadence and after any product change. When offline stops predicting online, the gate is theater and is rebuilt rather than trusted.

Online instruments differ by question. A/B measures user-visible outcomes and needs the guardrails attached. Interleaving is the efficient choice for ranking. Shadow runs the new system on real traffic with no exposure, which catches operational failure but not user response. A long-run holdback is the only instrument that sees slow drift and cumulative harm.

## 11. Regression gates

A gate is specified by what it blocks, the per-slice thresholds, the guardrails, the sample it runs on, its owner, and a named override path. It gates on the failures that have actually hurt, not on the aggregate. Gate noise is measured before the threshold is set, because a flaky gate is routed around within two sprints. Prompt changes, retrieval changes, tool-schema changes and model version changes all pass the same gate, since each is a behavior change.

## 12. When a metric moves

Work the causes in this order, cheapest and most likely first, and report which were ruled out and how.

1. Instrumentation. Did logging, sampling or the metric definition change.
2. Population. Did the traffic mix change, which moves an aggregate with no system change at all.
3. Data. Did an upstream feature, index or document source change.
4. Judge or labeler. Did the judge version, rubric or annotator pool change.
5. System. Model version, prompt, retrieval parameters, tools, cache.
6. Real. The world moved, which is drift and is the last conclusion, not the first.

## 13. Drift and retraining

Monitor input distribution, prediction distribution and, when labels arrive, realized outcome. Label delay sets how long the system is blind, and that interval is stated rather than implied. Retraining triggers are a sustained drift breach, a slice performance breach, or a calendar backstop, and a retrain is a release that passes the same gate as any other change.

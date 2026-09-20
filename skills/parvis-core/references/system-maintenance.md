# System maintenance, the T7 run list

*Trigger: "run system maintenance", quarterly or on request. This is the run list T7 points to. It moved here from T7 in `parvis-core/SKILL.md`, so core carries the principle and this file carries the steps. Like every reference it explains and never binds, and the binding rules are T6 and T7.*

Work the steps in order. Every proposed edit goes to the owner before it is made (T4), and a step that could not run is reported as not run (T8).

## The quarterly run

1. **Friction-log review.** Read the friction lines in the `system` memory section since the last run and propose skill edits for the patterns they show. Waiver lines sit in the same section. Ladder line 3 records them under T4's second exception, the rule and the date and never the content, and they are counted here by rule, so a rule set aside often is a rule to reword.
2. **T6 consolidation pass.** Look for restated tenets and duplicated text across skills, and turn each into a citation of its single home. Report the words given back.
3. **Owner profile.** Re-confirm the `parvis-owner` profile with the owner and refresh its Last-confirmed date. The installed copy is never overwritten, so its Profile version line is what dates it.
4. **Prose-hygiene reconciliation.** Check each rule in the writer's bundled `prose-hygiene.md` against its source rule in the standalone `be-human` skill, and reconcile any that disagree. A line diff proves nothing here, because the bundled copy is a condensation and always differs from its source.
5. **Description optimization.** Run the description-optimization loop over all skills where the tooling exists (Claude Code). Every description stays under 1,024 characters.
6. **Docs mirrors.** Refresh the six `docs/` mirrors (how-to-use, install-guide, skills-reference, why-parvis, system-guide, initialization) from their canonical copies in `references/`.
7. **Freshness re-verification.** Re-check, restamp or correct the dated claims in `language-and-data-traps.md`, `commitment-mechanics.md`, `agent-patterns.md`, `testing-and-review-craft.md`, `metrics-catalog.md` and `install-guide.md`. Then re-read the unstamped doctrine in `ipe-knowledge-base.md` and `risk-craft.md` for what has since become checkable.
8. **The release gate.** Run `tools/check-release.sh`, and run `tools/install-sandbox-tests.sh` after any `install.sh` change. The gate compares version lines with VERSION on X.Y only, because maintenance also runs it mid-release when a skill's Z is above 0.
9. **Changelog entry.** Record what changed in `CHANGELOG.md`, including the `wc -w` measurement of the always-loaded `SKILL.md` files and of `references/*.md`. The changelog is the one home of that measurement, and core's T6 no longer carries a figure.
10. **Close.** The run ends with the bundle updated and fanned out to every machine that carries it.

## Every release

A mirror refresh also runs at every release, and `check-release.sh` confirms the six pairs diff clean. The T6 ceiling is check 10 of the gate. It reads the ceiling line in `tools/ratchet-baseline`, fails a release that passes it, and appends nothing itself, so the maintainer adds the release's measurement row by hand.

## Once a year, the sunset

Counted from the first session logged on the production machine, not from a release date. List each tenet with its last citation in a friction line, decision row or waiver, and whether its test ran. Drill lines and skill text never count. A tenet with neither goes to the owner in one batch marked retire, merge or keep. Keep costs one ledger sentence on what the tenet prevented. Silence never retires a tenet, so an unanswered batch returns at the next run. T2, T3 and T4 are reviewed for wording only, because silence there is the rule working. The last-cited table lives in the `system` memory section.

# Deck craft, executive presentations

*How to build decks that survive executive rooms. Content rules live here. File production (.pptx mechanics, layouts, rendering) belongs to the platform's pptx skill, so read it before generating any deck file.*

## The rules that govern every exec deck

**Action titles carry the argument.** Every slide title is a full assertion rather than a topic label, "Cell-based isolation cuts blast radius 80% for $[X]M over 6 quarters," never "Cell-Based Architecture Overview." The test: read only the titles, top to bottom. They must form the complete argument as a coherent paragraph. Executives who flip through in 90 seconds get the entire case from titles alone, and everything else on each slide exists to prove its title.

**One assertion per slide.** A slide making two points makes neither. Split or cut.

**Evidence, not decoration.** Each slide body holds the minimum that proves the title, one chart, one table, or 3–5 lines. A chart earns its place only if the title's claim is *visible in it* within three seconds. Otherwise a sentence with the number beats the chart. No stock imagery, no icon walls, no decorative SmartArt.

**The 10/20 discipline.** Main deck ≤ 10 content slides for a decision meeting, ≤ 20 for a long program deck, and parvis-reviews sets the ceiling for the MBR and QBR. Everything else is appendix, and a strong appendix is a weapon, one slide per anticipated hard question, findable in five seconds when the question comes. Building the appendix IS meeting prep.

**Numbers formatted for scanning.** Right-align figures, one unit per column, deltas and trends marked, targets shown against actuals. A table an executive must study has failed. The pattern should be visible before the detail.

**Chart selection follows the claim.** The title's assertion picks the visual. A *trend* claim ("MTTR falling toward target") gets a line chart with the target drawn on it. A *comparison* claim ("option B is cheapest") gets bars sorted by the value rather than alphabetically. A *share* or *composition* claim gets a table or a sorted bar, never a pie. An *it's-under-control* claim gets actual-vs-threshold on one axis. A *relationship* claim ("spend doesn't track incidents") gets a scatter only if the pattern is unmistakable, otherwise state the correlation as a sentence. Two overriding rules: any chart that needs a legend study to be understood gets replaced by a sentence with the number, and every chart shows the target/threshold/baseline the claim is measured against, because a line with no reference line is decoration.

**Placeholders visible.** `[X]` markers for every figure the user must supply, never an invented number, and the delivery note lists which placeholders remain.

## Deck anatomies

**Board / risk-committee deck (≤ 10 slides).** Slide 1: the ask and the risk position, the whole meeting on one slide. Then: exposure today (quantified) → recommendation with price → options compared including status quo (one slide, one table) → evidence of safety/control → delivery plan with owner and dates → what's being asked of the committee (note vs. approve, explicitly). Appendix: one slide per hard question. Register: every claim survives the sharpest member, and confidence levels are stated rather than implied.

**Strategy deck (≤ 12 slides).** Follows the strategy kernel in order: honest diagnosis (2–3 slides, and the uncomfortable slide goes here, because its presence is what buys credibility for everything after) → guiding policy (1 slide, one sentence large) → where-to-play / where-NOT-to-play (1 slide, both columns) → coherent actions with prices and sequencing → scenario robustness (which bets hold across futures) → portfolio balance → the decision requested. Failure mode: a strategy deck with no where-NOT slide is a budget request wearing a strategy costume.

**QBR deck.** Lead, spine and failure mode follow the QBR / program narrative entry in `document-anatomies.md`, and parvis-reviews owns the structure and the ceiling in `skills/parvis-reviews/references/review-templates.md`. On slides: slide 1 carries the headline of the quarter. Each metric that matters gets its own slide with trend, target and delta. The named miss gets a full slide, because burying it costs more credibility than the miss did. Then next quarter's bets with prices, then asks.

**Incident readout deck (≤ 8 slides).** Lead, spine and failure mode follow the incident executive summary entry in `document-anatomies.md`. On slides: slide 1 carries customer impact and current state, quantified. Then the timeline on one slide (detection → containment → resolution with durations), cause at known depth with uncertainty stated plainly, what contained it, recurrence prevention with owner and date, and pattern-or-one-off with the evidence for which.

**Town-hall / org deck (≤ 12 slides).** Lead, spine and failure mode follow the org announcement / staff comms entry in `document-anatomies.md`. On slides: why (the real reason, in language a staff engineer respects) → what's changing, concretely → what it means Monday for the people in the room → sequencing and dates → where questions go. An engineering org of any size detects spin at parts-per-million, and the deck that says who reports to whom beats the one with the vision slide.

## Speaker notes

For presented decks (not pre-reads), each slide's notes carry the one spoken sentence that lands the title, the supporting number said aloud, and the pivot line to the next slide. Notes are fragments for speaking rather than paragraphs for reading, because a deck whose notes are essays produces an executive reading essays.

## Production

Before generating any .pptx, read the platform pptx skill (`/mnt/skills/public/pptx/SKILL.md`) and follow it. It owns file mechanics, layout, and rendering constraints, and this file owns what goes on the slides. The same split applies to Word documents, where the docx skill (`/mnt/skills/public/docx/SKILL.md`) owns file production and the memo/report anatomies here own the content. Prefer the format the user asked for. When they say "deck" produce .pptx, "Word doc" or "memo to send" produce .docx, otherwise markdown is the default working format.

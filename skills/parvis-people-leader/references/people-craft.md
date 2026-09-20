# People craft

*Anatomies for the recurring people-leadership tasks. Same discipline as document anatomies, so lead element, structure and failure mode.*

## Person file schema, `sections/people-management/people/<person-slug>.md`

The development arc per direct, and per skip-level worth tracking. The evidence log (`evidence/<slug>.md`, dated one-liners) stays separate and append-heavy. The person file is the synthesis and the evidence log is the raw material.

```markdown
# <Name>
*Role/level: <> · Tenure: <in role / in org> · Updated: <date>*

## Scope & context
- <what they own; team size; current-year charter>

## Performance history
- <cycle · rating · headline · source: formal review / user's assessment>

## Strengths (evidenced)
- <strength · the 1–2 evidence-log entries or review lines that prove it>

## Development areas & actions
- <area · the action agreed · checkpoint date · progress>

## Goals (current cycle)
- <goal · target · trajectory>

## Career aspiration (their stated words, dated)
- <what THEY said they want, never inferred>

## Watch items
- <dated flags from the people-signals catalog: structural facts only>

## History
- <dated: significant conversations, moves, moments>
```

Glass-test governs with full force. Formal review content and the user's managerial assessments belong here, since they are professional records the user owns as their manager. Armchair psychology, health speculation and anything about protected characteristics never do. Career aspirations are recorded in their words, dated, because an aspiration inferred is an aspiration invented (T2).

## People signals, the early-warning catalog (structural and observed facts only)

Run at the quarterly talent review, and raise unprompted when a signal fires. Each entry runs what to look for → the question or action. **The boundary, stated hard.** These are structural facts and observed behaviors, never psychological diagnosis. The system flags "sustained on-call load + vacation untaken + scope shrink," not "burnout". Naming the inner state is the user's conversation to have, carefully, or a professional's.

1. **Flight-risk structure.** Comp or promotion disappointment this cycle, scope shrank in a reorg, passed over visibly, their specialty running hot in the market, a trusted peer just left, milestone tenure (2–3 years post-promotion is when eyes wander). Any two together → a deliberate career conversation within the month, led by listening.
2. **Load structure.** Sustained incident/on-call weight, vacation accrued and untaken across quarters, the person who can never be out because everything routes through them (single-threading is a person-risk before it's a delivery-risk). The action is to restructure the load, because the conversation without the restructuring is sympathy theater.
3. **Performance drift.** Evidence-log tone shifting over two quarters, commitments starting to slip for someone who never slipped. Classify per the performance-situation anatomy before acting, because drift has causes.
4. **Succession aging.** A critical role's ready-now bench shrinking (departure, promotion elsewhere) with no grid update, or "ready in 1–2 years" entries older than a year with no development action taken, a hope calcifying.
5. **Team-health clusters.** Attrition clustering in one team (three departures in two quarters is a signal about the leader or the load, not three coincidences, with regretted vs. non-regretted marked honestly), and engagement signals the user observes concentrated in one area.
6. **New-leader integration.** Any senior hire or internal move into a critical role gets a 90-day watch item by default, with the checkpoint conversation at day 45, not day 90 when it's history.

## Quarterly talent review, "run my talent review"

Walk the top-N (the user's directs plus critical skip-levels), the way the portfolio health check walks programs. (1) **Trajectory** per person, evidence log and goals against last quarter, honestly. (2) **Development actions**, progressing, stalled (a development area with no action for two quarters is a decoration), or done. (3) **Fired people-signals**, ranked. (4) **Succession grid** against reality, so coverage, aging and the second-seat problem. (5) **Calibration honesty**, where the user's past ratings or reads proved wrong against outcomes (the T2-inward pass, and their people-judgment calibration is tracked like their decision calibration). (6) **Three actions** the user will take this quarter, a conversation, a move, a load restructuring. One page. Composes with the coverage map (stakeholders) and the forecast-calibration register (portfolio), because the leader whose programs run 1.6× long and whose team is clustering attrition is one picture, not two.

## Drafting performance reviews, "draft <name>'s review"

From the evidence log and person file, in the user's voice (exec-writer register rules apply, numbers over adjectives, no invented specifics). The year's evidence is organized against the rating dimensions, strengths carry their proof, development areas are stated plainly with the growth path, and the rating recommendation carries its honest basis and the calibration-room defense. The draft flags where evidence is thin ("Q2 has two entries, was that the quiet quarter or the uncaptured one?") rather than padding. The user edits, owns and delivers. The system never invents an accomplishment or a concern.

## Initializing directs from past reviews, "initialize my directs"

When the user shares past performance reviews (a couple of cycles per person), parse each into the person's file, covering role/level, performance history rows (cycle, rating, headline), strengths and development areas with review language as evidence, goals if stated, and watch items where prior reviews flagged them. Every entry is tagged `[formal review, <cycle>]` and confirmed per person before writing. Seed the evidence log with the reviews' concrete accomplishments as dated entries. What ingestion deliberately does NOT do is import another manager's psychological characterizations as fact (recorded as "prior review stated X", attributed, not adopted), or anything protected-class adjacent (skipped, flagged to the user if load-bearing in the source). These files live in the people-management nested local-only repo. The reviews themselves are not stored verbatim, so the file is the synthesis and the user's originals stay wherever they keep them.

## Promotion / calibration case
**Lead:** the claim, "operating at <level> for <duration>, evidenced below." **Anatomy:** claim → 3–5 evidence blocks, each a concrete accomplishment with scope, complexity and quantified outcome mapped to the target level's criteria → impact beyond own team (the differentiator at senior levels) → growth trajectory → the honest gap (naming one known development area builds credibility, and a gapless case reads as advocacy) → comparison anchoring where calibration will demand it. **Failure modes:** adjectives without artifacts, effort framed as impact, evidence from only the last quarter (availability bias, so pull the full period), the case that's really about retention pressure, which calibration rooms smell instantly. **Pre-calibration murder-board:** the 5 hardest challenges this case invites and the one-line answers.

## Succession grid
**Lead:** the risk picture, which critical roles have no ready successor. **Anatomy:** per critical role, incumbent → ready-now names → ready-in-1–2-years names with the specific development gap and the assignment that closes it → external-hire trigger (the condition under which inside options are declared insufficient). **Discipline:** "ready" means evidence of operating at scope, not potential narrative, and a grid where everyone is "ready in 1–2 years" is a hope document. Apply the outside view, since most succession plans fail at the second seat, the plan for the successor's successor. **Review cadence:** grid entries age like positions, so re-confirm every cycle.

## Difficult conversation prep
**Lead:** the one sentence the user must say clearly even if everything else goes sideways. **Anatomy:** the core message (unhedged, rehearsable) → the evidence the user will reference (specific instances, dates, impact, never "people are saying") → their side, genuinely steelmanned (what's legitimately true in their likely response, and what the user might be missing) → anticipated reactions with the user's responses (defensiveness, counter-accusation, emotion, silence) → the outcome the user needs from this conversation vs. what can wait → follow-up commitment (what's written down after, by when). **Failure modes:** the sandwich (burying the message in praise until it's deniable), litigating history instead of naming the pattern, walking in without knowing one's own non-negotiable.

## Performance situation assessment
**Lead:** classify honestly before acting, so skill gap, will gap, role mismatch, context problem (unclear expectations, impossible scope, broken team), or leader problem (the user's own contribution). **Anatomy:** the observable pattern with instances → classification with the evidence for it → what's been tried and what happened → the intervention matched to the classification (coaching for skill, expectations-reset for will, move for mismatch, fix-the-system for context) → timeline with checkpoints → the honest fork (what improvement looks like, and what the next step is if it doesn't come). **Discipline:** run five-whys on "underperformance", because a surprising fraction resolves to unclear expectations or organizational context, which no PIP fixes. Second-order check, what does the org learn from how this is handled?

## Senior-hire interview kit
**Lead:** the 3–4 things this role must prove, decided before any question is written. **Anatomy:** per must-prove, 2 behavioral probes anchored in their actual history ("walk me through the incident that went worst on your watch") + what a strong vs. hollow answer sounds like → the scenario probe (a real-shaped problem from the user's world, sanitized) → reference-check questions targeting the same must-proves → a scoring frame agreed with the panel before interviews start. **Failure modes:** brilliance bias (confusing articulate with effective, so demand the messy specifics behind the polished story), hiring for the last person's gaps, panel questions that all probe the same comfortable dimension.

## Org-move communication (people layer)
When org design changes touch people (the advisor owns the design trade-offs, this owns the human sequencing), the order runs who hears first and from whom (affected individuals before broad announcement, always) → the honest why for each affected person → what's actually decided vs. still open (never present open questions as settled) → the personal conversation script for anyone whose role shrinks. **Failure mode:** optimizing the announcement while the individual conversations are improvised, since it's the individual conversations that the org retells for years.

# Positions seeding interview

*Run this when the advisor's sections are empty. About twenty minutes, permanent payback. The entry format for a position is owned by `parvis-memory/references/section-templates.md`, under its `positions.md` heading, so follow the shape there rather than a second copy here. Nothing in this interview presupposes the user's org. Read the owner skill (and `portfolio-planning/org-context.md` if it exists) first for the org's scale, groups, industry and regulators, and phrase each question in those terms, never assuming a size, budget or structure the user has not stated. For each domain elicit four things, the user's position in one sentence, their confidence as high or medium or low, the basis, and the observable that would change their mind. Write results through `parvis-memory` into the named sections. Skip domains the user defers, and record "no position yet" where that is the honest answer, because an absent position is itself worth knowing.*

## General domain

Interview the user on their current stances across the domains below, choosing and phrasing them for the scope, industry and org described in the owner skill rather than assuming any particular org size or structure. Starting set: resilience architecture (cell-based isolation, blast radius, multi-region posture, DR philosophy), SRE operating model (SLO regime, error budgets, incident command, toil thresholds), platform strategy (build-vs-buy thresholds, paved-road vs. flexibility, internal platform-as-product), agentic AI operations (autonomy boundaries, human-in-the-loop thresholds, provability to regulators), enterprise architecture (standardization vs. federation, governance weight), and org design (team topologies, platform team ratios, centralize-vs-embed), trimmed to what the user actually owns. Add topics as they recur.

## Platform program

Where the work in front of the user is a platform program rather than their general infra domain, run the program-shaped questions below.

### portfolio-planning, the program strategy questions

1. What does winning look like for this program in three years, and what will you explicitly NOT do, which workloads, which domains, which internal customers get a no or a later?
2. What is the honest diagnosis, the two or three root problems this platform must solve that the current model cannot?
3. What is your MVP conviction, which single high-value use case proves the platform first, and why that one?
4. Phase gates, what observable results must exist before the program scales beyond MVP?

### enterprise-architecture

5. Anchor posture per domain across compute, container, network, storage, observability and data services. One primary technology each, or where do you deliberately run two, and why?
6. Build-versus-buy line, what will this program custom-build as a true differentiator, and what is bought or consumed no matter how tempting the build?
7. Lock-in tolerance, which anchor dependencies are acceptable one-way doors, and what mitigation must exist in writing?
8. Everything-as-code posture, where must policy, config, pipeline and infrastructure as code be non-negotiable from day one?

### platform-products

9. Product taxonomy, what are the first three to five platform products, and who is the named customer persona for each?
10. Adoption thesis, for each early product, why will teams choose it over what they do today? The honest answer, not the pitch.

### vendor-management

11. Standing vendor beliefs, which vendor claims in this space do you distrust by default, and which partners have earned trust?

### Two questions that belong to other skills

These two come up in the same sitting, so ask them here, then route the answers rather than filing them in this advisor's sections.

12. Team model conviction, how do you want platform teams composed and sized, and what, if anything, from the current org model will you not copy? Routes to the `people-management` section and the people-leader skill.
13. The four or five metrics you would stake the program's credibility on in year one, and the one metric you refuse to be managed by. Routes to the `metrics-value` section and `parvis-metrics-advisor`.

Close by proposing each answer as a position entry carrying its confidence and its would-change-my-mind line, confirm with the user, write, commit.

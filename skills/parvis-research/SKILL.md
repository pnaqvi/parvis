---
name: parvis-research
description: >
  Customer-research synthesis for a platform program. Applies when the parvis-owner
  skill's domain is technology. Turns listening-tour interviews, CES and CSAT verbatims, survey
  free-text and support-ticket themes into structured findings, pain maps per persona,
  adoption barriers ranked by frequency and severity, and verbatim-grounded themes for
  product roadmaps. Use on "synthesize these interviews", "what are the
  themes in this feedback", "build the pain map from the listening tour", "what's
  blocking adoption per the research", "run the listening tour", "prep the interview
  guide", "what changed since the last tour", and casual phrasings. Every theme cites
  its verbatims and no user sentiment is invented. Writes findings to the
  `platform-products` memory section and files waves to `strategy/research/`. Feeds
  parvis-infra-advisor, parvis-metrics-advisor and parvis-exec-writer's adoption
  communications mode. Not for designing metrics, running campaigns, or making the
  strategy decision.
---

# Parvis research

*Skill version 2.7.0 · Last updated 2026-09-20 · Parvis release 2.7 (2026-09-20)*

The inbound counterpart to adoption communications. That mode tells the platform's story out, this skill brings the customers' story in, structured enough to act on. Where the owner skill lists a platform program, the doctrine hook is direct, the listening tour is an opening move of that program (`parvis-core/references/ipe-knowledge-base.md` section 7), and adoption strategy without user evidence is guessing. **Core governs** and the `parvis-core` tenets apply in full. Part of the technology-leadership set, it applies when the owner skill's domain is technology, and the personas, teams and org it researches are the user's, drawn from the owner skill and memory. Kept deliberately small, because this skill's value is discipline rather than surface area.

## Memory and workspace, a client of parvis-memory

Primary section `platform-products`, at `sections/platform-products/` in the memory home, where findings land as insights tied to the product they concern, on the user's word (T4), and mature into positions under the memory skill's rules. Two sections are read rather than written, `metrics-value` for the quantitative context behind a verbatim, and `stakeholders` for which teams were actually heard and which were not.

Research artifacts file to `strategy/research/<wave-slug>/` in the workspace home, holding the guide, the synthesis and the pain map, each with a manifest row per core T11. Raw interview notes the user supplies can be filed alongside or kept out of the system at the user's choice, and if filed, core T3 applies in full.

## The evidence rule, core T2 hardened for this domain

Every theme, barrier and pain point cites its verbatims. At least two independent sources per claimed theme, quoted or tightly paraphrased, each carrying its origin as an interview number, a survey batch or a ticket cluster. A theme with one source is reported as a single observation and not as a pattern. A theme with no source does not exist. No invented user sentiment, ever, because the fastest route to a wrong roadmap is a plausible-sounding "users want" that no user said. Frequency and severity are counted from the evidence rather than intuited. Notes about internal people stay professional and factual, synthesize roles and teams rather than personalities, per core T3.

## Working modes

- **Interview-guide prep**, triggered by "prep the interview guide". Six to ten open questions for the named persona, built from what the registers already show, so a known pain hypothesis becomes a question to test rather than an assumption to confirm. Ordered wide to specific. One page.
- **Wave synthesis**, triggered by "synthesize these interviews". A thematic pass over the supplied material producing themes with citation counts, a per-persona pain map of task then friction then workaround then cost, adoption barriers ranked by frequency against severity, surprises flagged separately because the finding nobody predicted is usually the valuable one, and contradictions preserved, since two teams wanting opposite things is a segmentation insight rather than noise to average away.
- **Barrier readout**, triggered by "what's blocking adoption per the research". The ranked barrier list with its evidence, joined against `parvis-metrics-advisor` readings where they exist, so low CES plus these verbatims becomes a diagnosis rather than two separate observations. Then routed, friction findings to `parvis-infra-advisor` for product and strategy, awareness findings to `parvis-exec-writer` adoption communications mode, measurement gaps back to `parvis-metrics-advisor`.
- **Cross-wave view**, triggered by "what's changed since the last tour". Compare filed waves for barriers resolved, barriers persisting and barriers new, claiming a change only where both waves actually asked the question.

## Guardrails

Synthesis, not decision. A recommendation is framed as what the evidence argues, and the decision itself routes to `parvis-infra-advisor`. Sample honesty, N is stated on every readout, and no "users think" from three conversations without saying it was three. Waves never overwrite each other, which is what the `<wave-slug>` folder is for. If the user supplies pre-synthesized findings from a delegated team, file them and use them, labeled as their synthesis rather than this skill's.

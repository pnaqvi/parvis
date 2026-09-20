---
name: parvis-owner
description: >
  Loads background about the user, Parvez Naqvi, so he doesn't have to re-introduce
  himself. It is the single identity source for Parvis, and every parvis-* skill
  defers to it. Use it whenever he invokes it ("/parvis-owner", "use my profile", "you know
  who I am") AND whenever knowing who he is would meaningfully improve the response,
  such as drafting or editing his resume, LinkedIn posts or profile, executive bios,
  conference talk abstracts or speaker intros, board or recruiter outreach,
  networking messages, career or job-search advice, and any task where he refers to
  "my team," "my org," "my role," "my budget," "my groups," "the Discover
  integration," or similar without spelling it out. When in doubt on a task that's
  about him or his career, load this rather than ask him to repeat details already
  provided here. Resumes and LinkedIn are here, not parvis-exec-writer.
---

# Who the user is

*Skill version 2.7.0 · Last updated 2026-09-20 · Parvis release 2.7 (2026-09-20)*

**Profile version: 2026-08-08 · Last confirmed: 2026-08-08.** This profile is load-bearing for all of Parvis, because every skill defers to it for identity, scale, org and preferences. At each quarterly system maintenance, re-confirm the Profile, Org and Signature accomplishments sections with him and refresh both dates. If more than about six months have passed since Last confirmed, mention it once when the profile is used for something consequential.

Treat the facts below as established, current background about the user and build on them rather than asking him to restate anything. A field showing `[X]` is unknown, so never fill it by guessing. Ask when a task genuinely needs it.

## Filling this in

This is the personalized copy, installed at `~/.claude/skills/parvis-owner/SKILL.md`. It carries no template marker, so the installer keeps it on every upgrade. Keep it out of any public repository. Replace an `[X]` whenever the fact becomes known.

## Profile

- **Name:** Parvez Naqvi
- **Pronouns:** he/him
- **Location:** Washington DC–Baltimore area (works on-site in McLean, Virginia)
- **Current role:** Managing Vice President, Cloud Platforms, Resilience Engineering and Enterprise Architecture at Capital One (2026–present; at Capital One since ~2017)
- **Scale:** Leads ~1,000 engineers and a ~$500M+ operating budget. His infrastructure carries billions in daily transactions for 100M+ customers under a 99.99%+ availability mandate.
- **Headline framing he uses:** "Cloud infrastructure & reliability engineering at 100M-customer scale · 99.99%+ uptime | Led tech integration of $35B and $17.2B deals | Wharton MBA"
- **LinkedIn:** https://www.linkedin.com/in/parvez/

## Org

- **Groups and their leaders:** Cloud Governance [X] · Cloud Engineering [X] · Resilience & Reliability Engineering [X] · Observability [X] · Enterprise Architecture [X]. These are his five groups. Initialization creates one memory section per group, and live details are kept in `portfolio-planning/org-context.md` in memory.
- **Headcount:** ~1,000 engineers (per-group split [X])
- **Budget envelope:** ~$500M+ operating budget. Skills frame proportions against it and never invent line items.
- **Reports to:** [X]
- **Flagship programs:** the multi-year infrastructure platform program, which turns infrastructure into internal platforms that product teams adopt by choice. Other flagship programs [X].

## Domain and industry

- **Industry:** banking, at a top-10 US bank (Capital One)
- **Domain:** technology (cloud platforms, resilience and reliability engineering, SRE, enterprise architecture, identity, agentic AI operations). The technology-leadership skills apply in full.
- **Regulated?** yes, a heavily regulated environment where regulators require that safety be proven, not asserted
- **Regulators and examiners:** [X], to be confirmed at initialization
- **Frameworks the org uses:** [X], to be confirmed at initialization
- **Risk rating scale:** [X]
- **Performance rating scale:** [X]
- **Key audiences:** his CIO, the board and its risk committee, regulators, and downward to his 1,000-engineer org

## Signature accomplishments

- **Discover acquisition ($35B):** Led the resilience, reliability, enterprise architecture, and cloud-infrastructure integration workstreams of one of the sector's largest deals.
- **Reliability transformation (2024–2026, as MVP of Resilience & Reliability Engineering):** Cut customer-impacting incidents 75%+ in two years by building Capital One's enterprise SRE practice and AIOps-driven incident detection from the ground up. Drove MTTD below 5 minutes and MTTR below 30 minutes, avoiding tens of millions in risk and cost exposure.
- **Agentic AI governance:** Established the governance, controls, and accountability framework enabling Capital One to deploy agentic AI and autonomous operations safely across regulated lines of business, spanning tens of millions of cloud assets.
- **Customer IAM (VP, 2022–2024):** Ran authentication for 100% of Capital One web and mobile sessions, at 400+ logins/sec and 5,000+ authorizations/sec. Cut unauthorized-access events (including bot attacks) 80%+ by wiring ML behavioral-risk signals into real-time access decisions.
- **Identity migration (Director 2017–2019, Senior Director 2019–2022):** Migrated 100M+ customer identities from legacy on-prem to an AWS-native identity platform in a zero-downtime, multi-year program. Scaled the Customer IAM organization from Director to Senior Director.
- **Thomson Reuters (2001–2017, 16 years):** Led post-merger identity and data-platform integration through the $17.2B Thomson–Reuters merger ($6.5M integration CapEx over three years). Founded Thomson Reuters' enterprise IAM capability from scratch (Director 2008–2012, Senior Director 2012–2015, TR ID/IAM Platform Group). As Head of Identity & Search Technology, Asset Management (expat in Zurich, 2015–2017), owned the P&L for the global $100M+ Search platform. Earlier, as Solutions Architect and then Senior Solutions Architect (~2003–2008), delivered $5M+ annual savings via global team rationalization and $1M+ annual cost cuts consolidating Thomson/Primark systems. Began in 2001 as a hands-on senior software engineer.

## Positioning

- **Thesis:** The hard part of the next decade isn't deploying AI. It's proving deployed systems are safe to boards and regulators, and he runs the infrastructure where that gets answered. He started as an engineer, earned a Wharton MBA, and never left the technical trenches, "deep enough to architect it, senior enough to carry the P&L."
- **Signature quote (AWS case study):** "We believe that innovation should be at the speed of well-managed systems."
- **Capital One's journey as he frames it:** the cloud-first transition began in 2016 and culminated in 2020 when Capital One exited all its data centers. His org was a beta participant for AWS resource control policies.
- **Capital One thesis he repeats:** the winners in banking will be great tech companies with the risk management skills of a leading bank.

## Credentials and visibility

- **Education:** MBA, The Wharton School, University of Pennsylvania (2011–2013, Management & Finance). B Tech in Computer Engineering, Pune Institute of Computer Technology.
- **Patents:** Holds 3, including "Fingerprint-based device authentication" (US 12142073) and "Identity proofing offering for customers and non-customers" (US 10819520)
- **Certifications:** Certified Product Manager (AIPMM, 2017). Stanford Machine Learning (Coursera).
- **Speaking:** Speaker at AWS re:Invent 2024 (CloudOps/Amazon CloudWatch) and two sessions at Snowflake Summit 2026 on AI, observability, and data infrastructure
- **Public profiles:** LinkedIn https://www.linkedin.com/in/parvez/ with 3,540+ followers and 500+ connections
- **Skills he lists:** Cloud Infrastructure, Agentic AI Development, and related

## Communication preferences

- **Default register:** executive-crisp, metrics-forward, concrete numbers over adjectives, technical depth without hand-waving. Never explain cloud, SRE or IAM basics to him.
- **Length:** tight by default. He prefers a strong single answer over menus of options, and length ceilings in his skills are real limits.
- **When unsure:** infer and state the inference in one overridable line rather than asking, unless the ambiguity is genuinely consequential. Then ask exactly one question.
- **Pushback:** wanted, direct, and evidence-based. He built his system to challenge his framing, so do not soften disagreement into hedging.
- **Punctuation:** his standing rule is no em dashes ever, and colons and semicolons kept to a minimum. He does not naturally write with these marks. The `be-human` skill applies this through rule 13 to every piece of prose written for him. The only exceptions are text he supplies containing these marks and direct quotes.

## Sensitive context (optional)

- None recorded.

## How to use this

- **Tailor, don't recite.** Draw on these facts to make responses specific to him, but don't dump the profile back at him unprompted. If he asks for a speaker bio, pick the details that fit the venue rather than summarizing his whole career.
- **Pick what's relevant.** Board and executive audiences want scale, P&L, deal integrations and regulatory safety framing. Technical audiences want the SRE and AIOps metrics (75% incident reduction, MTTD <5 min, MTTR <30 min), IAM throughput numbers and the zero-downtime migration. AI topics want agentic AI governance and the "proving systems are safe" thesis.
- **Match his voice.** His writing is confident, metrics-forward and executive-crisp, with concrete numbers over adjectives and a through-line of technical depth plus business ownership.
- **Stay accurate.** Use only what's here. Don't invent employers, dates, titles, metrics, team sizes or accomplishments that aren't listed. If a task needs a missing detail, ask him rather than guessing.
- **Keep it fresh.** These facts can go stale (role changes, new deals, new talks). If he says something that contradicts the profile, believe the newer information for that conversation and mention that this skill may be out of date so he can update it. Re-confirm quarterly and refresh Profile version and Last confirmed.

# IPE knowledge base, working platform doctrine

*A synthesis, in the system's own words, of infrastructure platform engineering practice. Doctrine is a reference class, not a law, so advisors argue against it where first principles or evidence disagree.*

## 1. What the program is building

An **infrastructure platform** is an internal software product, not a bundle of services: capabilities (compute, container, network, storage, observability, DBaaS, environments-as-a-service, IAM/SSO) made easily consumable via self-service portals, APIs, and CLIs, with governance, security, compliance, and cost controls **embedded in the platform** rather than enforced through manual gates. Consumers (product teams, developers, data scientists, increasingly AI agents) self-manage within guardrails. The platform organization curates the experience, retains governance, and treats users as customers. The shift is from managing infrastructure *for* consumers to empowering them *within* guardrails, and from ticket-driven to product-centric.

The reference architecture runs as layers: access layer (portal, catalog, API, custom interfaces) → platform core (components catalog, blueprints/paved roads, landing zones, shared services, sources of truth, artifact registry, everything-as-code: infra/config/pipeline/policy) → orchestration and control loops over cloud, PaaS, SaaS, on-prem, edge, and colocated targets → cross-cutting security/compliance (policy-as-code, secrets, IAM, IaC scanning), observability (telemetry, logging, alerting), cost management, and IPE governance (catalog curation, backlog, docs, support).

## 2. Architecture doctrine: anchor and complement

- **Anchor each platform domain on one primary technology** (ideally exactly one) providing most of that platform's intended functionality. ~80% is the starting heuristic and the default, a bar the user can reset per program [model]. Fragmentation across parallel stacks multiplies integration complexity, IaC divergence, and skills spread. An anchored estate also costs materially less to run than a fragmented one, because those stacks duplicate licensing, integration work and scarce skills, and that saving is the main financial argument for the discipline.
- **Complement before you buy.** Required functionality not covered by the anchor is first sourced by **reusing capabilities from platforms the organization already runs** (security, application, data/analytics, AI platforms) before any supplemental purchase. Reuse is enforced, not encouraged: capability inventory published, justification required to build or buy new, platform representatives on architecture governance, reference architectures maintained with EA.
- **Right-size engineering.** Curate vendor solutions first, and custom-build only true differentiators (integrations, governance layers, UX that removes real user pain). Over-customization is the technical-debt trap, so a written charter defines what the program builds against what it integrates and configures.
- **Manage anchor lock-in deliberately.** Identify switching barriers (contracts, skills, ecosystem dependencies, data portability), document the dependency risks, keep a written mitigation strategy, and state in the platform strategy when a platform must accommodate an anchor change. Anchor choices are one-way-door decisions, so classify and process them as such.
- **Make existing infrastructure platform-ready** by prioritizing four characteristics in life-cycle plans: **interoperable** (works with systems from other sources), **automatable** (controllable with minimal human intervention), **programmable** (adjustable through software interfaces), **intelligent** (self-optimizing to demand). Assets weak on these limit what the platform can safely do, and owners assess and remediate critical gaps.

## 3. Organization doctrine: the IPE team model

- Traditional I&O silo structure (network / server / storage / cloud teams, many handoffs) cannot deliver end-to-end platform capabilities. The unit of delivery is the **IPE team**, a dedicated, agile product team accountable as a group for delivery *and* operations of its platform products.
- **Three core roles.** The **platform owner** is a product-owner role covering strategy and vision, roadmap communication, backlog, and customer engagement. The role shows its success through satisfaction, usage, ease and reliability metrics, and is best filled by someone with a software product-management background plus people skills and business acumen. The **platform architect** connects the team to customers, owns architecture and tooling standards, and leads strategic planning and roadmaps, and may initially be fulfilled by the owner or federated, then dedicated as scale demands. **Platform engineers** run delivery and operations, applying software-engineering practice (version control, code review, CI/CD, automated testing) to infrastructure automation, self-service, and API access, plus documentation (solution docs, user manuals, runbooks). Teams start small (~3 engineers) with all skills needed, and scale by adding teams.
- **Two skill buckets to build.** Product management (demand-driven platforms, thinnest viable platform first, evolve on feedback and adoption) and software engineering (APIs, IaC, cloud-native, composable architecture). These skills are hard to hire at market, so the strategy combines hiring SWEs with a passion for platform engineering, partnering with external providers for accelerated adoption, partnering with application-development teams, staff augmentation, continual training, and higher-education outreach.
- **Head-of-platforms success pattern.** Prepare before the role (stakeholder map, culture read). Assess (maturity assessment, listening tour, budget and headcount reality). Act (measurable time-bound goals, clarify roles, execute a visible quick win, communicate on a 3/6/12-month arc). Prioritize with the impact-vs-effort grid, and avoid both undershooting (no credibility) and overshooting (visible early failure).

## 4. Transformation doctrine: the platform-centric roadmap

- Platform-centric operation is becoming the expected shape of infrastructure and operations, and the share of I&O functions run that way is rising fast. Complement existing capabilities rather than restructuring wholesale, because single permanent transformations fail through performance breaks, staff resistance, or net-added complexity, while preserving the status quo gets I&O sidelined.
- **Short term, prepare for oversight.** Close gaps in managing existing assets, workflows and services. Establish an infrastructure platform management policy. Incorporate platform measures into performance metrics. Require platforms to directly allocate and recover costs from consuming products.
- **Medium term, practices and tools.** Agile delivery models, platform-management toolsets, observability platforms. Assigned decision rights (RACI). Agile sourcing for platform selection. Systems of record giving a coherent view from business capability down to infrastructure.
- **Long term, systems and environments.** Anchor-and-complement development model. Distinct platform team structures free to organize per digital-product needs. Reconfigurable collaborative workspaces.
- The line that governs the whole program is that **platforms cannot rely on mandates, and must outperform alternatives in ways that matter to their customers.** Every adoption decision is tested against this.

## 5. Value doctrine: reuse, experience, and the traps

- The ROI drivers are right-sized engineering, anchored domains, and enforced reuse (lower TCO, lower cognitive load, network effects).
- **Ownership.** One accountable platform owner per platform. Cross-functional squads (architect, automation engineer, software engineer, product manager, operations). Co-invest with Finance (FinOps), Security (CISO), Data (CDAO) and AI (CAIO) so platforms are funded as strategic shared investments, not siloed I&O costs.
- **Developer experience is the product.** Measure CES, CSAT and NPS. Make self-service genuinely invisible (docs, API/CLI/UI parity, guided onboarding, tool integration). An internal developer platform layer shields teams from cloud and policy complexity.
- **Named traps.** *Policy fragmentation*, where disparate policy tools spread across domains, answered by building a policy-orchestration layer, inventorying policies and hunting contradictions. *Over-engineering*, answered by retiring low-usage features ruthlessly, working 80/20, and routing niche needs to self-service. *Disconnect from business outcomes*, answered by always linking adoption to deployment speed, cost and compliance, and telling the value story in business terms.

## 6. Measurement doctrine: the four pillars

`parvis-metrics-advisor/references/metrics-catalog.md` is the full catalog and owns every benchmark figure and metric definition, so cite it rather than carry one here. Targets are directional, each program sets its own, and improvement matters more than a static target.

| Pillar | Core metrics | Cadence |
|---|---|---|
| **Experience** | CES (effort/friction), CSAT (1–5 post-change), NPS | CES continuous · CSAT after major changes · NPS quarterly |
| **Adoption & engagement** | Adoption rate (onboarded/eligible), consumption rate (active/onboarded), API consumption, feature utilization & abandonment | Monthly, API quarterly |
| **Operations** | Uptime/SLA, provisioning speed vs. baseline, MTTD, MTTR, the five-metric DORA set [verified 2026-09-20, dora.dev] | Monthly (DORA monthly/quarterly) |
| **Business outcomes** | Self-service rate, technical-debt reduction vs. baseline, cost per workload / chargeback / budget variance, value-enhancement linkage to KPIs, compliance-audit readiness | Monthly–quarterly |

- **Ownership.** Every metric category has a named owner. Finance owns cost metrics and Security owns risk and compliance KPIs. Regulated-industry reporting aligns with audit requirements.
- **Dashboard discipline.** One integrated view links sentiment and outcomes, tuned per audience (platform team and product leadership → experience, head of I&O and CFO → adoption, CTO, DevOps and business units → operations and business). Start with 4–5 essential metrics (adoption, CSAT, uptime, one business metric), assign owners immediately, report within 30 days, add depth gradually. Read metrics **jointly**, because low CES with high adoption means users are using but struggling, so fix the experience rather than celebrate the adoption.

## 7. Phase model for the program

*Timings are the reference class, not commitments.*

1. **Strategy & assessment (~1–2 months).** Anchor definitions per domain. Maturity assessment (agility, observability, IaC). User pain-point interviews across cloud-native, data-science, and business teams.
2. **Team & governance (~2–4 months).** Dedicated IPE team(s) formed with full-time roles. Hire and upskill on IaC, CI/CD, API and cloud-native. Governance principles codified into automated policy.
3. **MVP (~4–6 months).** One high-value use case (e.g., cloud-account vending, Kubernetes). Build iteratively, release early, measure adoption, time-to-provision and satisfaction.
4. **Scale & optimize (6+ months).** Expand domains. Enforce reuse. Embed cost governance and chargeback at every layer.

- Opening moves: secure executive alignment (this is an organizational shift, not a technical one) and run a rapid listening tour (cloud architects, security, finance, product teams) to validate anchor choices and the MVP use case.
- A 90-day validation play. Weeks 1–2 audit platforms and integration complexity and identify anchors. Weeks 3–4 map the reuse landscape and duplication. Weeks 5–6 assign owners and define just-enough engineering scope. Weeks 7–8 co-design the minimum viable platform experience for one high-value persona. Weeks 9–12 pilot and measure CES, adoption and provisioning time.

## 8. Success picture

Provisioning in hours not weeks. Teams adopt the platform because it is easier than alternatives. Chargeback and observability expose waste and automation reduces it. Policy-as-code lowers audit risk. Platform engineers solve strategic problems instead of fielding tickets. And I&O is the infrastructure provider of choice by outperforming rather than mandating.

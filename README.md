# Parvis

**A personal executive operating system for Claude that anyone can adopt.** Seventeen composable skills, two git-backed data homes (a sectioned memory and a document workspace), a shared frameworks catalog, and thirteen binding tenets. Everything about you lives in one file, the `parvis-owner` skill. Fill it in and the whole system knows your role, your org, your scale, your industry and how you like to be written to.

Release **2.3** · License **Apache-2.0**

## What it does

It knows you and compounds. Positions, decisions tracked to outcomes, person and vendor files, meeting threads and a commitments ledger accumulate in memory, and every plan, review and brief is filed in the workspace with a manifest row. It challenges rather than flatters. It steelmans against your stated lean, names the wrong question when you ask one, and refuses to polish goals dressed as strategy. It reasons deeply and on the record, with depth over token cost (T1), a zero-hallucination protocol and no invented numbers (T2), and a frameworks catalog applied by selection and named when used. `docs/why-parvis.md` makes the full case.

The core works for any senior leader. The technology-leadership skills (the infra advisor, the metrics advisor, customer research and the platform program doctrine) go deep on cloud platforms, resilience, enterprise architecture and internal platforms, and apply when your domain is technology.

## Contents

```
skills/          17 Claude skills. parvis (the /parvis session), parvis-owner (identity
                 template), parvis-core (tenets, frameworks, panels, help), parvis-memory
                 (both homes), parvis-infra-advisor, parvis-metrics-advisor, parvis-research,
                 parvis-exec-writer, parvis-reviews, parvis-portfolio-planning,
                 parvis-meeting-prep, parvis-people-leader, parvis-stakeholders,
                 parvis-vendor-eval, parvis-risk-regulatory,
                 parvis-incident-command, be-human
memory/          Seed memory home, MANIFEST.md plus 13 sections (templates only). Your org
                 groups get their own sections at initialization
workspace-seed/  Seed workspace home, MANIFEST.md, strategy/ tech-plans/ project-plans/
                 cadence/ risk/ inbox/ reference/ archive/
docs/            The six help documents
install.sh       Install, update, and uninstall (see below)
VERSION          System release (X.Y). Each skill carries X.Y.Z in its header
```

## Make it yours

1. **Clone** the repository.
2. **Run** `bash install.sh`.
3. **Fill in the owner skill** at `~/.claude/skills/parvis-owner/SKILL.md`, the only file that holds anything about you. Edit its placeholders by hand, or drop your resume or LinkedIn export into the seed pack and let initialization step 3 draft it for you to confirm.

That's the whole personalization. No other skill names a person, an employer or an org. Your org groups become memory sections during initialization, your industry's frameworks and risk rating scale are collected from you then, and your punctuation and register preferences travel from the owner skill into everything the system writes. The installer never overwrites a filled-in owner skill.

## Install (Claude Code on macOS, Linux, WSL, or Windows under Git Bash)

```bash
git clone https://github.com/pnaqvi/parvis parvis
cd parvis && bash install.sh
```

One script, four modes.

```bash
bash install.sh                       # install, or update an existing install in place
bash install.sh --uninstall           # remove skills and the managed block, keep all data
bash install.sh --uninstall --purge   # also remove both data homes, typed confirmation required
PARVIS_BASE=/new/base bash install.sh --relocate   # move both homes to a new base
```

**Where the homes live.** By default the two data homes are `~/ai_working_Directory/parvis-memory` and `~/ai_working_Directory/parvis-workspace`. To put them anywhere else, set `PARVIS_BASE` on the first install, for example `PARVIS_BASE=/path/to/base bash install.sh`, which gives `<base>/parvis-memory` and `<base>/parvis-workspace`. Write the base as a POSIX path. On Windows under Git Bash that means `/c/Users/<you>/...` rather than `C:/Users/<you>/...`, which the installer refuses. The choice is remembered, so later runs need no `PARVIS_BASE`, and the managed block tells every skill where the homes are. `--relocate` moves existing homes later, after checking that they are clean git repositories and that the move is a rename on one volume. The install guide has the details.

The installer copies the skills into `~/.claude/skills/`, keeps an owner skill you have already filled in, writes a short managed block into `~/.claude/CLAUDE.md`, and seeds both homes **only if absent**, so existing data is never touched. What it retires, how the confidential memory sections become nested local-only repositories, what the install receipt is for, and why legacy infra-platform homes are reported and left in place rather than migrated are all in [docs/install-guide.md](docs/install-guide.md).

The script cannot reach `~/.claude/skills/synced/`. Skills delivered by claude.ai account sync are retired on the claude.ai side, and the script says so when it finds that directory.

Then restart Claude Code, run `/skills` to confirm seventeen skills, and say **"run the shakedown"** to validate the install. Then gather the seed pack described in `docs/initialization.md` and say **"initialize my system"**, the guided and resumable first-run setup. The installer prints these steps, and `/parvis` offers them until initialization is complete. Anytime, say **"help"** and the system explains itself from its own documents.

If the system will run on a machine your employer manages, read `docs/install-guide.md` §0 **first**, on policy, managed accounts and memory posture. It is the section with consequences. On a single personal machine with no employer policy in play, install and initialize on it directly.

## Use

Start a session with **`/parvis`**. Parvis greets you by the name in your owner skill, loads your profile, the Prime Directive and both data homes, and handles everything after it as your companion. Add a first request after it if you like, as in `/parvis prep me for the QBR`. Without it the system still works, since the managed block keeps the Prime Directive on in every session.

Say what you need and the right skill fires. *"quick take on X"*, *"spin up the team"*, *"design our platform metrics"*, *"synthesize these interviews"*, *"draft a board memo"*, *"start the September MBR"*, *"run my weekly"*, *"prep me for the risk committee"*, *"build the promotion case"*, *"should we buy X or build it"*, *"we have a sev-1"*, *"remember this"*, *"file this as a tech plan"*, *"where is the Q3 review"*.

The help set, identical in `docs/` and in `skills/parvis-core/references/`.
- `why-parvis.md`, purpose and design principles
- `install-guide.md`, install, update, uninstall, employer-managed-machine policy
- `initialization.md`, first-run setup, step by step
- `how-to-use.md`, the routing map and the rhythms
- `skills-reference.md`, every skill at a glance
- `system-guide.md`, every skill in depth, with its boundaries

If you modify the skills themselves, keep the tenets, which are the part that generalizes, and per Apache-2.0 §4(b), mark your modified files as changed.

## Privacy notes

- This repository ships **seed structure only** for memory and documents, so no live memory and no live documents travel with it. `skills/parvis-owner/SKILL.md` arrives filled in with the maintainer's own profile, which is what the installer copies on a first install. Replace it with your own facts, then keep your filled-in copy at `~/.claude/skills/parvis-owner/`, which the installer never overwrites.
- `.gitignore` refuses a populated memory home, and the nested-repo design keeps confidential sections off any remote structurally, not by discipline.
- Tenet T3 governs everything. No material non-public information, customer data or confidential specifics ever enter the system's files.

## Versioning

System release `X.Y` and its date live in `VERSION` and `CHANGELOG.md`. Every skill header carries `X.Y.Z`, where Z moves on skill edits and X.Y re-baselines at releases. An edited skill whose version did not move is a defect (T7).

## License

Apache License 2.0, see [LICENSE](LICENSE) and [NOTICE](NOTICE). SPDX `Apache-2.0`.

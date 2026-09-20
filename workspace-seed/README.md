# Workspace seed

This is the seed for the workspace home, one of two data homes. The two are never flattened together.

- **Memory** holds curated durable facts, sectioned and routed by its own MANIFEST. It installs to the memory home from `memory/` in this repo.
- **Workspace** holds working documents, routed by the workspace MANIFEST. It installs to the workspace home from this `workspace-seed/` directory.

The Parvis managed block in `~/.claude/CLAUDE.md` states where each home lives. The location comes from `PARVIS_BASE` on the first install, defaulting to `~/ai_working_Directory`, and is remembered from then on.

A fact that must survive and be cited belongs in memory. A document being drafted, reviewed, or filed belongs here.

`install.sh` seeds this home under the same policy it applies to memory, which is to seed only when the destination is absent and never overwrite a populated home.

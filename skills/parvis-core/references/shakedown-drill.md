# Shakedown drill, T9 validation

*Trigger: "run the shakedown" / "shakedown the system". ~30–45 minutes on real (then deleted) test data. It converts the system from designed-only to designed-and-tested on THIS machine and seeds the friction log with real observations. Run it once after install and after any major release. A drill on the user's own machine is required, because T9 says no capability is trusted until exercised where it will actually run.*

Rules. Every step is verified by reading the result back, not by asserting success. Every hiccup (wrong routing, missing file, awkward phrasing, a step that felt heavy) is logged one line to the `system` section as friction, live during the drill. Test entries are clearly marked `[shakedown]` and deleted at the end, and the deletion is itself a test of git hygiene.

## The drill

1. **Recall on empty.** "what's my position on <topic with no entry>?" → PASS = a plain "not in memory", no reconstruction.
2. **Capture & read-back.** "remember this: [shakedown] test position that X, low confidence" → PASS = routed to the right section, fields intact on read-back, git commits before and after.
3. **Contradiction check.** Capture a second `[shakedown]` position contradicting the first → PASS = the system surfaces the conflict and proposes supersession rather than writing a twin.
4. **Document filing.** "file this note as a tech plan: [shakedown] test doc" → PASS = file at `tech-plans/` with correct naming, manifest row present, committed.
5. **Reference retrieval.** "what does the reference library say about adoption targets?" → PASS, while `reference/INDEX.md` has no rows, = the answer says plainly that nothing in the reference library covers it and offers to file a source, and does not reconstruct content from memory or training. If system doctrine covers it, the answer may then cite the IPE knowledge base, labeled as doctrine and not as library content. PASS, once real material is filed, = the answer cites the file by name from the INDEX, synthesized and not reproduced.
6. **Fact-sheet & pulse.** "run my pulse" → PASS = reports the seeded state honestly (empty ledger, unconfirmed fact-sheet, no cadence artifacts) in a few lines, offers the fact-sheet refresh.
7. **Mini cadence cycle.** "draft a [shakedown] plan for a test period" → status → mini-MBR → PASS = period folder created with standard names, plan milestone appears as a ledger row once the plan is declared sent (T12's one trigger, never a git commit), MBR risk section reads from the risk register, manifest rows throughout.
8. **Advisor cold-start.** "quick take on <small real question from the user's own domain>" (parvis-infra-advisor when that domain is technology, otherwise a direct treatment using parvis-core's methods) → PASS = fact-sheet read first, methods named, no fabricated internals, position-capture offered at the end. Run before initialization, this tests the cold path, where a thin but honest answer is a PASS. Re-run it once the fact sheet is confirmed and positions are seeded to test the warm path.
9. **Panel dry-run (environments with subagents).** Sparring-mode team on a toy issue → PASS = single-writer discipline holds, checkpoint waits, brief lands in `brainstorm/` under the ceiling. Without subagents: confirm the filled team prompt is produced as a file instead (T8 announced).
10a. **Planning drill.** Toy allocation across 3 mock `[shakedown]` products with a mock capacity line in org-context and a deliberately overcommitted commit list → PASS = overcommitment surfaced from those two sources with the constraint named, where-NOT list present.
10b. **Exec-writer drill.** Convert a sandbox brief to a one-pager → mark 2–3 things you'd rewrite → PASS = the deltas land in style-notes.md as confirmed proposals.
10c. **Research drill.** 5 synthetic interview snippets → PASS = every claimed theme cites ≥2 verbatims, single-source items reported as observations, not patterns.
11. **Cleanup.** Delete all `[shakedown]` entries and files → PASS = removals committed, manifests clean, `git log` shows the full audit trail of the drill.

## Closing

Write the drill outcome as one `system`-section insight: date, steps passed/failed, friction lines logged. A failed step is not a failed drill, it is the drill working, so fix or log it. Re-run the failed step after any fix.

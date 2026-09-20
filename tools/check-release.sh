#!/usr/bin/env bash
# check-release.sh, maintainer tool. Runs the release-time checks nothing else runs.
#
#   bash tools/check-release.sh            run every check
#   bash tools/check-release.sh --quiet    print only failures and the summary
#
# Four things drift between releases and nothing catches them.
#
#   1. Description cap. Every skill's frontmatter description must be present and no longer than
#      the 1024 characters claude.ai allows. The measurement uses the folding rule a reader sees,
#      loaded from tools/package-skills.sh so the two tools can never disagree.
#   2. Documentation mirrors. The six help documents under docs/ are hand-copied from
#      skills/parvis-core/references/, and a correction applied to one copy leaves the other stale.
#      Each pair is compared with carriage returns stripped, so a CRLF checkout compares equal.
#      Both directions are compared, so a new help document never copied into docs/ is caught too.
#      A reference that belongs only to the skill is named in NOT_MIRRORED below and passed over.
#   3. System-guide drift. system-guide.md carries a behavior and a boundary block for every skill,
#      written by hand beside the skills themselves. Every entry it names must be an installed
#      skill and every skill must have an entry, in system-guide.md and in skills-reference.md.
#   4. Unregistered seed files. MANIFEST.md line 2 says a workspace document with no row is lost to
#      future sessions, and the installer copies a rowless seed file in without a word. This warns
#      instead, and the seed paths that need no row of their own are named in NO_ROW_NEEDED below.
#
# It reads the checkout and writes nothing. Exit code 0 when every check passes, 1 when any fails.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$REPO/skills"
REFS_DIR="$REPO/skills/parvis-core/references"
DOCS_DIR="$REPO/docs"
SEED_DIR="$REPO/workspace-seed"
QUIET=0

# References that are working material for parvis-core rather than help documents, so docs/ has no
# copy of them on purpose. Anything else missing from docs/ is a copy someone forgot to make.
NOT_MIRRORED="ipe-knowledge-base.md methods.md shakedown-drill.md"
# Seed paths that carry no manifest row by design. The manifest describes the workspace, so it
# cannot hold a row for itself, and .gitkeep and .gitattributes are plumbing.
NO_ROW_NEEDED="MANIFEST.md README.md reference/INDEX.md"

die() { printf 'check-release: %s\n' "$*" >&2; exit 1; }

while [ $# -gt 0 ]; do
  case "$1" in
    --quiet) QUIET=1; shift ;;
    -h|--help) sed -n '2,/^$/p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "unknown option $1" ;;
  esac
done

note() { [ "$QUIET" -eq 1 ] || printf '%s\n' "$*"; }
fails=0
warns=0
report_fail() { printf '  FAIL %s\n' "$*"; fails=$((fails + 1)); }
report_warn() { printf '  WARN %s\n' "$*"; warns=$((warns + 1)); }
in_words() { case " $1 " in *" $2 "*) return 0 ;; esac; return 1; }

# The two functions this tool measures with are loaded from package-skills.sh, the way that script
# loads valid_skill_name from install.sh, so one folding rule serves both.
for fn in skill_description description_length; do
  body="$(sed -n "/^$fn() {\$/,/^}\$/p" "$REPO/tools/package-skills.sh" | tr -d '\r')"
  [ -n "$body" ] || die "could not load $fn from tools/package-skills.sh"
  eval "$body"
done
DESC_CAP="$(sed -n 's/^DESC_CAP=\([0-9][0-9]*\).*/\1/p' "$REPO/tools/package-skills.sh" | head -n 1)"
[ -n "$DESC_CAP" ] || die "could not load DESC_CAP from tools/package-skills.sh"

SKILL_NAMES=()
for d in "$SKILLS_DIR"/*/; do
  [ -f "$d/SKILL.md" ] || continue
  SKILL_NAMES+=("$(basename "$d")")
done
[ "${#SKILL_NAMES[@]}" -gt 0 ] || die "no skills found under $SKILLS_DIR"

# ---- 1. Description cap ------------------------------------------------------------------
note "[1/4] Description cap, ${#SKILL_NAMES[@]} skills against $DESC_CAP characters"
for n in "${SKILL_NAMES[@]}"; do
  len="$(description_length "$SKILLS_DIR/$n/SKILL.md")"
  if [ "$len" -eq 0 ]; then
    report_fail "$n carries no frontmatter description, so nothing routes to it"
  elif [ "$len" -gt "$DESC_CAP" ]; then
    report_fail "$n has a description of $len characters, over the $DESC_CAP cap"
  else
    note "$(printf '  ok   %-30s %4d characters, %3d left' "$n" "$len" "$((DESC_CAP - len))")"
  fi
done

# ---- 2. Documentation mirrors ------------------------------------------------------------
note "[2/4] Documentation mirrors, docs/ and parvis-core/references/ against each other"
for f in "$DOCS_DIR"/*.md; do
  [ -f "$f" ] || continue
  b="$(basename "$f")"
  if [ ! -f "$REFS_DIR/$b" ]; then
    report_fail "docs/$b has no canonical copy at skills/parvis-core/references/$b"
  elif diff -q <(tr -d '\r' < "$REFS_DIR/$b") <(tr -d '\r' < "$f") >/dev/null; then
    note "  ok   docs/$b matches its canonical copy"
  else
    report_fail "docs/$b differs from skills/parvis-core/references/$b. Copy the canonical file over it."
  fi
done
# The other direction. One way round, a help document written into references/ and never copied out
# is invisible to this check, and the release ships with docs/ a document short.
for f in "$REFS_DIR"/*.md; do
  [ -f "$f" ] || continue
  b="$(basename "$f")"
  if in_words "$NOT_MIRRORED" "$b"; then
    note "  ok   references/$b is not mirrored, by declaration"
    continue
  fi
  [ -f "$DOCS_DIR/$b" ] || report_fail \
    "skills/parvis-core/references/$b has no copy at docs/$b. Copy it there, or name it in NOT_MIRRORED in this tool."
done

# ---- 3. System-guide drift ---------------------------------------------------------------
note "[3/4] System-guide drift, its entries against the skills themselves"
# Each skill has a heading of its own, written as the bare name, as a numbered heading with the
# name after the number, or as the name followed by a comma or a middle dot and a few words. The
# name is what is wanted, so the numbering and everything after the name is cut away.
guide_entries() {
  sed -n 's/^#\{2,3\} //p' "$1" \
    | sed -e 's/^[0-9]\{1,2\}\. //' -e 's/ · .*$//' -e 's/[ ,].*$//' \
    | LC_ALL=C sort -u
}
for doc in system-guide.md skills-reference.md; do
  [ -f "$REFS_DIR/$doc" ] || { report_fail "skills/parvis-core/references/$doc is missing"; continue; }
  named="$(guide_entries "$REFS_DIR/$doc")"
  for n in "${SKILL_NAMES[@]}"; do
    printf '%s\n' "$named" | grep -qx "$n" || report_fail "$doc has no entry for the skill $n"
  done
  while IFS= read -r n; do
    [ -n "$n" ] || continue
    case "$n" in parvis|parvis-*|be-human) ;; *) continue ;; esac
    [ -f "$SKILLS_DIR/$n/SKILL.md" ] || report_fail "$doc has an entry for $n, which is not a skill in this bundle"
  done <<EOD
$named
EOD
  note "  ok   $doc read, $(printf '%s\n' "$named" | grep -c .) entries"
done

# ---- 4. Unregistered workspace seed files ------------------------------------------------
note "[4/4] Workspace seed rows, each seed file against workspace-seed/MANIFEST.md"
SEED_MAN="$SEED_DIR/MANIFEST.md"
if [ ! -f "$SEED_MAN" ]; then
  report_fail "workspace-seed/MANIFEST.md is missing, so no seed file can be registered"
else
  # The path is the second column of a table row, compared whole, the way install.sh reads it
  seed_rows="$(tr -d '\r' < "$SEED_MAN" | LC_ALL=C awk -F '|' '
    /^\| / { p = $3; gsub(/^[ \t]+|[ \t]+$/, "", p); if (p != "Path") print p }')"
  rowless=0
  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    case "$rel" in *.gitkeep|*.gitattributes) continue ;; esac
    if in_words "$NO_ROW_NEEDED" "$rel"; then continue; fi
    printf '%s\n' "$seed_rows" | grep -qxF "$rel" || { report_warn \
      "workspace-seed/$rel has no row in workspace-seed/MANIFEST.md, so the installer copies it in unregistered"
      rowless=1; }
  done < <(cd "$SEED_DIR" && find . -type f | sed 's|^\./||' | LC_ALL=C sort)
  if [ "$rowless" -eq 0 ]; then note "  ok   every seed file that needs a row has one"; fi
fi

echo
if [ "$warns" -gt 0 ]; then echo "check-release: $warns warning(s), which do not fail the release."; fi
if [ "$fails" -gt 0 ]; then
  echo "check-release: $fails check(s) FAILED."
  exit 1
fi
echo "check-release: all checks passed."

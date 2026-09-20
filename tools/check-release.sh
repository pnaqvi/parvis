#!/usr/bin/env bash
# check-release.sh, maintainer tool. Runs the release-time checks nothing else runs.
#
#   bash tools/check-release.sh            run every check
#   bash tools/check-release.sh --quiet    print only failures and the summary
#   bash tools/check-release.sh --accept-unread-visibility origin
#                                          pass check 9 for the named remote when its visibility
#                                          cannot be read. A remote read as public still fails.
#
# Ten things drift between releases and nothing else catches them. The checks are numbered once,
# here, and an added check takes the next number.
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
#   5. Version lines. Every skill header carries the release in VERSION, compared on X.Y only,
#      because maintenance also runs this gate mid-release when a skill's Z is above 0. A skill
#      edited since the last commit whose version line did not move is T7's own named defect.
#   6. Tenet integrity. parvis-core holds at most TENET_CAP tenets in ascending number order, each
#      ends with its Broken when line, and every Tn cited anywhere in the bundle is a live tenet.
#      CHANGELOG.md is history and may cite a retired number, so it is not read.
#   7. Directive copies. The Prime Directive sentence has one home in parvis-core, and the
#      installer's managed block and the install guide carry copies by necessity. Every line that
#      says "Prime Directive:" must carry core's sentence word for word.
#   8. Banned marks. The owner's standing rule is no em dash, which a search can check and a
#      session grading its own prose cannot. A file that has to show the mark in order to ban it
#      is named in EM_DASH_ALLOWED with the number of lines it may hold. This is T13's test run on
#      the bundle under this bundle's own preference, and that list holds the documented exceptions.
#   9. Owner profile and remotes. The bundle ships the maintainer's filled profile, so its
#      Sensitive context section must be empty and every git remote must read as PRIVATE. A
#      visibility this tool cannot read FAILS. It never warns and passes. The one way past is
#      --accept-unread-visibility with the remote's name. This covers the working tree only, and
#      git history still holds whatever an earlier commit carried.
#  10. Word ceiling, T6. tools/ratchet-baseline holds the owner's ceilings for parvis-core/SKILL.md and
#      for all SKILL.md files together. A release may grow, and it fails only when either count
#      passes its ceiling. Only the owner raises a ceiling, by editing the ceiling line. The release
#      rows in that file are a measurement history and never fail a release.
#      Nothing here is kept in VERSION, which install.sh reads as the bare release string.
#
# Looked for nowhere yet, so still designed-only. T11 and T12's tests and T13's test on filed
# documents concern the live workspace, which is not in this checkout.
#
# It reads the checkout and writes nothing. Exit code 0 when every check passes, 1 when any fails.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$REPO/skills"
REFS_DIR="$REPO/skills/parvis-core/references"
DOCS_DIR="$REPO/docs"
SEED_DIR="$REPO/workspace-seed"
CORE="$SKILLS_DIR/parvis-core/SKILL.md"
OWNER="$SKILLS_DIR/parvis-owner/SKILL.md"
BASELINE="$REPO/tools/ratchet-baseline"
QUIET=0
ACCEPT_UNREAD=""
CHECKS=10

# References that are working material for parvis-core rather than help documents, so docs/ has no
# copy of them on purpose. Anything else missing from docs/ is a copy someone forgot to make.
NOT_MIRRORED="ipe-knowledge-base.md methods.md shakedown-drill.md system-maintenance.md"
# Seed paths that carry no manifest row by design. The manifest describes the workspace, so it
# cannot hold a row for itself, and .gitkeep and .gitattributes are plumbing.
NO_ROW_NEEDED="MANIFEST.md README.md reference/INDEX.md"
# T6's ratchet caps the tenet count. A retired number is never reused, so numbers may have gaps.
TENET_CAP=14
# The em dash, written as bytes so this file never holds the mark it searches for.
EM_DASH=$'\xe2\x80\x94'
# path:lines, space separated. be-human's catalog entry has to show the mark in order to ban it.
EM_DASH_ALLOWED="skills/be-human/SKILL.md:1"

die() { printf 'check-release: %s\n' "$*" >&2; exit 1; }

while [ $# -gt 0 ]; do
  case "$1" in
    --quiet) QUIET=1; shift ;;
    --accept-unread-visibility)
      [ $# -ge 2 ] || die "--accept-unread-visibility needs the name of the remote"
      ACCEPT_UNREAD="$ACCEPT_UNREAD $2"; shift 2 ;;
    -h|--help) sed -n '2,/^$/p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    *) die "unknown option $1" ;;
  esac
done

note() { [ "$QUIET" -eq 1 ] || printf '%s\n' "$*"; }
fails=0
warns=0
overrides=0
report_fail() { printf '  FAIL %s\n' "$*"; fails=$((fails + 1)); }
report_warn() { printf '  WARN %s\n' "$*"; warns=$((warns + 1)); }
report_override() { printf '  OVERRIDE %s\n' "$*"; overrides=$((overrides + 1)); }
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
note "[1/$CHECKS] Description cap, ${#SKILL_NAMES[@]} skills against $DESC_CAP characters"
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
note "[2/$CHECKS] Documentation mirrors, docs/ and parvis-core/references/ against each other"
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
note "[3/$CHECKS] System-guide drift, its entries against the skills themselves"
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
note "[4/$CHECKS] Workspace seed rows, each seed file against workspace-seed/MANIFEST.md"
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

# ---- 5. Version lines --------------------------------------------------------------------
note "[5/$CHECKS] Version lines, every skill header against VERSION on X.Y"
version_line() { tr -d '\r' | grep -m 1 '^\*Skill version ' || true; }
REL=""
if [ -f "$REPO/VERSION" ]; then REL="$(tr -d ' \t\r\n' < "$REPO/VERSION")"; fi
if ! printf '%s\n' "$REL" | grep -qE '^[0-9]+\.[0-9]+$'; then
  report_fail "VERSION does not read as a bare X.Y release, so no version line can be compared"
  REL=""
fi
# The work tree counts only when this checkout is the top of its own repository, so a copy that
# merely sits inside some other repository is not mistaken for one.
IN_GIT=0
if command -v git >/dev/null 2>&1 \
   && [ -z "$(git -C "$REPO" rev-parse --show-prefix 2>/dev/null || echo outside)" ] \
   && git -C "$REPO" rev-parse --verify -q HEAD >/dev/null 2>&1; then
  IN_GIT=1
fi
for n in "${SKILL_NAMES[@]}"; do
  line="$(version_line < "$SKILLS_DIR/$n/SKILL.md")"
  if [ -z "$line" ]; then
    report_fail "$n has no Skill version line in its header"
    continue
  fi
  sv="$(printf '%s\n' "$line" | sed -n 's/^\*Skill version \([0-9][0-9]*\.[0-9][0-9]*\)\.[0-9][0-9]*[^0-9].*/\1/p')"
  rv="$(printf '%s\n' "$line" | sed -n 's/.*Parvis release \([0-9][0-9]*\.[0-9][0-9]*\)[^0-9.].*/\1/p')"
  bad=0
  if [ -n "$REL" ]; then
    if [ "$sv" != "$REL" ]; then
      report_fail "$n is at skill version ${sv:-unreadable}, and VERSION says $REL"; bad=1
    fi
    if [ "$rv" != "$REL" ]; then
      report_fail "$n names Parvis release ${rv:-unreadable}, and VERSION says $REL"; bad=1
    fi
  fi
  if [ "$IN_GIT" -eq 1 ] && [ -n "$(git -C "$REPO" status --porcelain -- "skills/$n" 2>/dev/null || true)" ]; then
    old="$(git -C "$REPO" show "HEAD:skills/$n/SKILL.md" 2>/dev/null | version_line || true)"
    if [ -n "$old" ] && [ "$old" = "$line" ]; then
      report_fail "$n was edited since the last commit and its version line did not move (T7)"; bad=1
    fi
  fi
  if [ "$bad" -eq 0 ]; then note "  ok   $n"; fi
done
if [ "$IN_GIT" -eq 0 ]; then
  report_warn "no git history here, so whether an edited skill's version line moved was not checked"
fi

# ---- 6. Tenet integrity ------------------------------------------------------------------
note "[6/$CHECKS] Tenet integrity, the count, the order, the tests and every cited number"
tenets="$(tr -d '\r' < "$CORE" | awk '
  /^## / { if (cur != "") { print cur, bw; cur = "" } }
  /^\*\*T[0-9]+ / { if (cur != "") print cur, bw; s = $1; gsub(/[^0-9]/, "", s); cur = s; bw = 0 }
  /^\*Broken when\*/ { if (cur != "") bw++ }
  END { if (cur != "") print cur, bw }')"
live=" "
count=0
prev=0
while read -r num bw; do
  [ -n "$num" ] || continue
  count=$((count + 1))
  if [ "$num" -le "$prev" ]; then
    report_fail "T$num follows T$prev in parvis-core, so the tenets are out of number order or a number repeats"
  fi
  if [ "$bw" -ne 1 ]; then
    report_fail "T$num has $bw Broken when lines, and every tenet ends with exactly one"
  fi
  prev="$num"
  live="$live$num "
done <<EOD
$tenets
EOD
if [ "$count" -eq 0 ]; then
  report_fail "no tenet headings were found in parvis-core/SKILL.md"
elif [ "$count" -gt "$TENET_CAP" ]; then
  report_fail "parvis-core holds $count tenets, over the cap of $TENET_CAP that T6 sets"
else
  note "  ok   $count tenets in number order, each with its test"
fi
CITE_PATHS="skills docs workspace-seed memory README.md install.sh"
cited="$(cd "$REPO" && grep -rhowE --include='*.md' --include='*.sh' 'T[0-9]{1,2}' $CITE_PATHS 2>/dev/null \
  | tr -d 'T' | LC_ALL=C sort -un || true)"
dead=0
while read -r num; do
  [ -n "$num" ] || continue
  if in_words "$live" "$num"; then continue; fi
  where="$(cd "$REPO" && grep -rlwE --include='*.md' --include='*.sh' "T$num" $CITE_PATHS 2>/dev/null | tr '\n' ' ' || true)"
  report_fail "T$num is cited and is not a live tenet. Cited in $where"
  dead=1
done <<EOD
$cited
EOD
if [ "$dead" -eq 0 ] && [ "$count" -gt 0 ]; then note "  ok   every cited tenet number resolves"; fi

# ---- 7. Directive copies -----------------------------------------------------------------
note "[7/$CHECKS] Directive copies, each against the sentence in parvis-core"
directive="$(tr -d '\r' < "$CORE" | sed -n '/^> \*\*.*\*\*$/{s/^> \*\*\(.*\)\*\*$/\1/p;q;}')"
directive_lc="$(printf '%s' "${directive%.}" | tr 'A-Z' 'a-z')"
if [ -z "$directive_lc" ]; then
  report_fail "the Prime Directive sentence could not be read from parvis-core/SKILL.md"
else
  in_installer=0
  while IFS= read -r hit; do
    [ -n "$hit" ] || continue
    file="${hit%%:*}"
    rest="${hit#*:}"
    lineno="${rest%%:*}"
    text_lc="$(printf '%s' "${rest#*:}" | tr 'A-Z' 'a-z')"
    if [ "$file" = "install.sh" ]; then in_installer=1; fi
    case "$text_lc" in
      *"$directive_lc"*) note "  ok   $file:$lineno carries the sentence" ;;
      *) report_fail "$file:$lineno says Prime Directive and does not carry core's sentence word for word" ;;
    esac
  done < <(cd "$REPO" && grep -rnF --include='*.md' --include='*.sh' 'Prime Directive: ' \
             skills docs README.md install.sh 2>/dev/null | tr -d '\r' || true)
  if [ "$in_installer" -eq 0 ]; then
    report_fail "install.sh has no Prime Directive line, so the managed block no longer carries the directive"
  fi
fi

# ---- 8. Banned marks ---------------------------------------------------------------------
note "[8/$CHECKS] Banned marks, the em dash across every text file in the bundle"
marked=0
while IFS= read -r rel; do
  [ -n "$rel" ] || continue
  have="$(LC_ALL=C grep -c "$EM_DASH" "$REPO/$rel" || true)"
  allowed=0
  for a in $EM_DASH_ALLOWED; do
    if [ "${a%:*}" = "$rel" ]; then allowed="${a##*:}"; fi
  done
  if [ "$have" -gt "$allowed" ]; then
    lines="$(LC_ALL=C grep -n "$EM_DASH" "$REPO/$rel" | cut -d: -f1 | tr '\n' ' ' || true)"
    report_fail "$rel holds an em dash on $have line(s) where $allowed are allowed, at line $lines"
    marked=1
  else
    note "  ok   $rel holds $have, allowed by declaration"
  fi
done < <(cd "$REPO" && LC_ALL=C grep -rlI --exclude-dir=.git --exclude-dir=dist --exclude-dir=build \
           "$EM_DASH" . 2>/dev/null | sed 's|^\./||' | LC_ALL=C sort || true)
if [ "$marked" -eq 0 ]; then note "  ok   no em dash outside the declared lines"; fi

# ---- 9. Owner profile and remotes --------------------------------------------------------
note "[9/$CHECKS] Owner profile and remotes, Sensitive context empty and every remote private"
if [ ! -f "$OWNER" ]; then
  report_fail "skills/parvis-owner/SKILL.md is missing, so its Sensitive context cannot be read"
else
  # Only a count is ever printed. The lines themselves never reach a terminal or a log.
  sens="$(tr -d '\r' < "$OWNER" | awk '
    /^## / { on = 0 }
    tolower($0) ~ /^## sensitive context/ { on = 1; found = 1; next }
    on {
      l = tolower($0); gsub(/^[ \t]*[-*]?[ \t]*|[ \t]*$/, "", l)
      if (l == "" || l == "none recorded." || l == "none recorded" || l == "[x]") next
      kept++
    }
    END { if (!found) print "missing"; else print kept + 0 }')"
  case "$sens" in
    missing) report_fail "parvis-owner has no Sensitive context heading, so the section cannot be read as empty" ;;
    0) note "  ok   Sensitive context is empty in the working tree. Git history is not covered." ;;
    *) report_fail "parvis-owner's Sensitive context holds $sens line(s). The bundled copy ships with none." ;;
  esac
fi
if [ "$IN_GIT" -eq 0 ] || [ -z "$(git -C "$REPO" remote 2>/dev/null || true)" ]; then
  note "  ok   no git remote here, so there is no repository to be public"
else
  while IFS= read -r r; do
    [ -n "$r" ] || continue
    url="$(git -C "$REPO" remote get-url "$r" 2>/dev/null || true)"
    vis=""
    case "$url" in
      *github.com[:/]*)
        if command -v gh >/dev/null 2>&1; then
          vis="$(gh repo view "$url" --json visibility -q .visibility 2>/dev/null | tr -d '\r' || true)"
        fi ;;
    esac
    case "$vis" in
      PRIVATE) note "  ok   remote $r reads as PRIVATE" ;;
      '')
        if in_words "$ACCEPT_UNREAD" "$r"; then
          report_override "remote $r could not be read, accepted by name on the command line"
        else
          report_fail "the visibility of remote $r could not be read. Sign in with gh, or pass --accept-unread-visibility $r"
        fi ;;
      *) report_fail "remote $r reads as $vis, and the bundle carries the owner profile. No override covers this." ;;
    esac
  done < <(git -C "$REPO" remote 2>/dev/null || true)
fi

# ---- 10. Word ceiling ---------------------------------------------------------------------
# The owner set ceilings, not a ratchet. A release may grow. It fails only when parvis-core or the
# always-loaded total passes its ceiling, and only the owner raises a ceiling, by editing the
# ceiling line in tools/ratchet-baseline. The release rows in that file are a measurement history
# and never fail a release on their own.
note "[10/$CHECKS] Word ceiling, parvis-core and the always-loaded total against tools/ratchet-baseline"
now_core="$(wc -w < "$CORE" | tr -d ' ')"
now_total="$(cat "$SKILLS_DIR"/*/SKILL.md | wc -w | tr -d ' ')"
is_count() { case "$1" in ''|*[!0-9]*) return 1 ;; esac; return 0; }
if [ ! -f "$BASELINE" ]; then
  report_fail "tools/ratchet-baseline is missing, so there is no ceiling to hold against"
else
  base_text="$(tr -d '' < "$BASELINE" | grep -v '^[ 	]*#' || true)"
  c_core="$(printf '%s
' "$base_text" | awk '$1 == "ceiling" { print $2; exit }')"
  c_total="$(printf '%s
' "$base_text" | awk '$1 == "ceiling" { print $3; exit }')"
  if ! is_count "$c_core" || ! is_count "$c_total"; then
    report_fail "tools/ratchet-baseline holds no readable ceiling line, which reads: ceiling <core words> <always-loaded words>"
    printf '  measured now, parvis-core %s words and the always-loaded total %s
' "$now_core" "$now_total"
  else
    over=""
    if [ "$now_core" -gt "$c_core" ]; then over="parvis-core $now_core against a ceiling of $c_core"; fi
    if [ "$now_total" -gt "$c_total" ]; then over="${over:+$over, }the always-loaded total $now_total against a ceiling of $c_total"; fi
    if [ -z "$over" ]; then
      note "  ok   parvis-core $now_core of $c_core, always-loaded $now_total of $c_total"
    else
      report_fail "over the owner's ceiling, $over. Give the words back, or have the owner raise the ceiling line."
    fi
  fi
fi

echo
if [ "$warns" -gt 0 ]; then echo "check-release: $warns warning(s), which do not fail the release."; fi
if [ "$overrides" -gt 0 ]; then echo "check-release: $overrides check(s) passed on a named override."; fi
if [ "$fails" -gt 0 ]; then
  echo "check-release: $fails check(s) FAILED."
  exit 1
fi
echo "check-release: all checks passed."

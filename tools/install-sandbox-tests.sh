#!/usr/bin/env bash
# install-sandbox-tests.sh, maintainer tool. Drives install.sh end to end inside a throwaway HOME.
#
#   bash tools/install-sandbox-tests.sh              run every test
#   bash tools/install-sandbox-tests.sh fresh adopt  run only the named tests, refusing any other
#   bash tools/install-sandbox-tests.sh --list       print the test names and exit
#   PARVIS_SANDBOX_ROOT=/path bash tools/install-sandbox-tests.sh    put the sandboxes elsewhere
#
# Keep that root short. On Windows a deep one runs a nested repository past the path limit and git
# fails inside it, which the default temporary directory avoids.
#
# Every run happens under a sandbox HOME made for it, so the installer writes its skills, its
# managed block, its receipt and both data homes inside that directory and nowhere else. The suite
# resolves the sandbox path before judging it and refuses to start when that path would be, or
# would contain, the real HOME, or when HOME is unset. It never takes HOME or PARVIS_BASE from the
# environment, and it fingerprints the real ~/.claude before and after to prove nothing there
# moved. The real memory and workspace homes are never read or written.
#
# What is covered. A fresh install, a personalized owner skill kept on the next run, adoption of a
# filled-in profile from the older user skill, a profile backup offered back after an uninstall and
# written in, an added memory section with its manifest row, an added section whose row the bundle
# forgot, an added workspace file with its table row and the same run twice, an added folder whose
# name ends the way an existing one does, a relocation compared by git HEAD in all seven nested
# repositories, and the refusals. No run has a terminal, so the restore offer is declined rather
# than accepted, and write_owner_from is driven on its own for the accepting half.
#
# Exit code 0 when every test passes, 1 when any fails, 2 when the suite refuses to run.

set -uo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

die() { printf 'install-sandbox-tests: %s\n' "$*" >&2; exit 2; }

[ -f "$REPO/install.sh" ] || die "no install.sh beside this tool"
# With no HOME there is nothing to tell a sandbox apart from, so the suite refuses in words rather
# than dying on an unbound variable.
[ -n "${HOME-}" ] || die "REFUSED, HOME is not set, so no path can be told apart from the real HOME"
REAL_HOME="$(cd "$HOME" 2>/dev/null && pwd -P)" || die "REFUSED, HOME is not a directory: $HOME"
CLAUDE_ROOT="$REAL_HOME/.claude"

TESTS="fresh keep adopt restore section section_row_missing ws_file ws_folder relocate refusals"
WANTED=""
while [ $# -gt 0 ]; do
  case "$1" in
    --list) printf '%s\n' $TESTS; exit 0 ;;
    -h|--help) sed -n '2,/^$/p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) die "unknown option $1" ;;
    *) case " $TESTS " in
         *" $1 "*) ;;
         *) die "unknown test $1. Run --list for the names." ;;
       esac
       WANTED="$WANTED $1"; shift ;;
  esac
done
[ -n "$WANTED" ] || WANTED="$TESTS"

# ---- Safety -----------------------------------------------------------------------------------
# A path serves as a sandbox only when it is neither the real HOME nor anywhere above it. Temporary
# directories on Windows sit under the profile, so being inside HOME is allowed, being HOME or
# holding it is not, and anything under the real ~/.claude is refused outright.
#
# resolve_path PATH folds away . and .., then resolves the part that exists through its symlinks and
# keeps the rest as written. A path that is not there yet still resolves, so the guard judges it
# before anything is created. Without this, $HOME/foo/.. read as a sandbox and the suite wrote
# inside the real HOME.
resolve_path() {
  local p out="" tail="" part
  local IFS=/
  for part in $1; do
    case "$part" in
      ''|.) ;;
      ..) out="${out%/*}" ;;
      *) out="$out/$part" ;;
    esac
  done
  p="${out:-/}"
  while [ ! -d "$p" ] && [ "$p" != "/" ]; do
    tail="/${p##*/}$tail"
    p="${p%/*}"
    [ -n "$p" ] || p="/"
  done
  p="$(cd "$p" 2>/dev/null && pwd -P)" || p="/"
  printf '%s\n' "${p%/}$tail"
}

refuse_real_home() {
  local p
  [ -n "$1" ] || die "empty sandbox path"
  case "$1" in /*) ;; *) die "sandbox path $1 is not absolute" ;; esac
  p="$(resolve_path "$1")"
  [ "$p" = "/" ] && die "REFUSED, the root directory is not a sandbox"
  [ "$p" = "$REAL_HOME" ] && die "REFUSED, $1 is the real HOME"
  case "$REAL_HOME/" in
    "$p"/*) die "REFUSED, $1 contains the real HOME $REAL_HOME" ;;
  esac
  case "$p" in
    "$CLAUDE_ROOT"|"$CLAUDE_ROOT"/*) die "REFUSED, $1 is inside the real $CLAUDE_ROOT" ;;
  esac
}

# A fingerprint of the parts of the real ~/.claude an installer would write. Transcripts and the
# other files Claude Code writes on its own are left out, so an unrelated write is not read as harm.
real_fingerprint() {
  {
    cksum "$CLAUDE_ROOT/CLAUDE.md" 2>/dev/null | awk '{ print $1, $2 }'
    cksum "$CLAUDE_ROOT/.parvis-install.json" 2>/dev/null | awk '{ print $1, $2 }'
    cksum "$CLAUDE_ROOT/.parvis-home" 2>/dev/null | awk '{ print $1, $2 }'
    ls -1 "$CLAUDE_ROOT/skills" 2>/dev/null | LC_ALL=C sort
  } | cksum
}

SANDBOX_ROOT="${PARVIS_SANDBOX_ROOT:-${TMPDIR:-/tmp}}"
refuse_real_home "$SANDBOX_ROOT"
mkdir -p "$SANDBOX_ROOT" || die "cannot create the sandbox root $SANDBOX_ROOT"
refuse_real_home "$SANDBOX_ROOT"  # again, now that it exists and resolves through its real links
WORK="$(mktemp -d "$SANDBOX_ROOT/parvis-sandbox.XXXXXX")" || die "cannot create a sandbox directory"
refuse_real_home "$WORK"
BEFORE="$(real_fingerprint)"

KEEP_WORK=0
cleanup() {
  local after
  after="$(real_fingerprint)"
  if [ "$after" != "$BEFORE" ]; then
    echo
    echo "ALARM. $CLAUDE_ROOT changed during this run. Check it by hand before trusting the result."
  fi
  if [ "$KEEP_WORK" -eq 1 ]; then
    echo "Sandboxes kept at $WORK"
  else
    rm -rf "$WORK"
  fi
}
trap cleanup EXIT

# ---- Harness ----------------------------------------------------------------------------------
PASSED=0
FAILED=0
PROBLEMS=""
LOG=""
RC=0

problem() { PROBLEMS="$PROBLEMS      - $1
"; }

# sandbox NAME makes a HOME of its own and prints it
sandbox() {
  local sb="$WORK/$1"
  refuse_real_home "$sb"
  rm -rf "$sb"
  mkdir -p "$sb/.claude" || die "cannot create the sandbox $sb"
  printf '%s\n' "$sb"
}

# run_install HOME BUNDLE [ARG...] runs one install with none of the real environment left in it.
# Standard input comes from /dev/null, so an interactive branch takes its non-interactive path.
run_install() {
  local sb="$1" bundle="$2"
  shift 2
  refuse_real_home "$sb"
  LOG="$sb/run-$(date -u +%H%M%S)-$RANDOM.log"
  env -u PARVIS_BASE HOME="$sb" bash "$bundle/install.sh" "$@" > "$LOG" 2>&1 < /dev/null
  RC=$?
  return 0
}

# run_install_base HOME BUNDLE BASE [ARG...] does the same with PARVIS_BASE set
run_install_base() {
  local sb="$1" bundle="$2" base="$3"
  shift 3
  refuse_real_home "$sb"
  LOG="$sb/run-$(date -u +%H%M%S)-$RANDOM.log"
  HOME="$sb" PARVIS_BASE="$base" bash "$bundle/install.sh" "$@" > "$LOG" 2>&1 < /dev/null
  RC=$?
  return 0
}

assert_rc() { [ "$RC" -eq "$1" ] || problem "exit code $RC, expected $1, see $(basename "$LOG")"; }
assert_says() { grep -qF -- "$1" "$LOG" || problem "the run never said: $1"; }
assert_silent_on() { grep -qF -- "$1" "$LOG" && problem "the run should not have said: $1"; }
assert_exists() { [ -e "$1" ] || problem "missing $1"; }
assert_absent() { [ -e "$1" ] && problem "still present $1"; }
assert_holds() { grep -qF -- "$2" "$1" || problem "$(basename "$1") does not carry: $2"; }
assert_count() {
  local n
  n="$(grep -cF -- "$2" "$1")"
  [ "$n" -eq "$3" ] || problem "$(basename "$1") has $n lines carrying $2, expected $3"
}

# fake_bundle NAME copies the bundle, so a test can add a seed path without touching the repo
fake_bundle() {
  local b="$WORK/bundles/$1"
  rm -rf "$b"
  mkdir -p "$b" || return 1
  cp "$REPO/install.sh" "$REPO/VERSION" "$b/" || return 1
  cp -R "$REPO/skills" "$REPO/memory" "$REPO/workspace-seed" "$b/" || return 1
  printf '%s\n' "$b"
}

# The repositories the installer creates under a base, the two homes and one per confidential
# section. The section names are read from install.sh, so a release that adds one is compared too.
NESTED="parvis-memory parvis-workspace"
for s in $(sed -n 's/^CONFIDENTIAL=(\(.*\))$/\1/p' "$REPO/install.sh" | tr -d '"'); do
  NESTED="$NESTED parvis-memory/sections/$s"
done
[ "$NESTED" = "parvis-memory parvis-workspace" ] && die "could not read CONFIDENTIAL from install.sh"

# heads BASE prints the HEAD of every one of them, or none where there is no commit
heads() {
  local s
  for s in $NESTED; do
    printf '%s %s\n' "$s" "$(git -C "$1/$s" rev-parse HEAD 2>/dev/null || echo none)"
  done
}

# own_from HOME SRC runs install.sh's own write_owner_from on SRC against the sandbox's owner skill.
# The restore's write sits behind [ -t 0 ] and no run here has a terminal, so the function is lifted
# out of the installer and driven directly rather than left with no coverage at all.
own_from() {
  local sb="$1"
  refuse_real_home "$sb"
  OWN_F="$sb/.claude/skills/parvis-owner/SKILL.md" bash -c '
    set -u
    eval "$(grep -E "^(OWNER_SKILL|OWNER_MARKER|OLD_OWNER_MARKER)=" "$1")"
    eval "$(sed -n "/^is_template_skill() {\$/,/^}\$/p;/^write_owner_from() {\$/,/^}\$/p" "$1")"
    write_owner_from "$2"
  ' _ "$REPO/install.sh" "$2"
}

run_test() {
  local name="$1"
  case " $WANTED " in *" $name "*) ;; *) return 0 ;; esac
  PROBLEMS=""
  printf '  %-20s ' "$name"
  "test_$name"
  if [ -z "$PROBLEMS" ]; then
    echo "PASS"
    PASSED=$((PASSED + 1))
  else
    echo "FAIL"
    printf '%s' "$PROBLEMS"
    FAILED=$((FAILED + 1))
    KEEP_WORK=1
  fi
}

# ---- Tests ------------------------------------------------------------------------------------

# A fresh install into an empty HOME, and the owner skill it leaves behind. The bundle ships the
# owner profile filled in, so the run must call it the shipped copy and never the user's own.
test_fresh() {
  local sb base
  sb="$(sandbox fresh)"; base="$sb/base"
  run_install_base "$sb" "$REPO" "$base"
  assert_rc 0
  assert_says "Install complete"
  assert_exists "$sb/.claude/skills/parvis-core/SKILL.md"
  assert_exists "$sb/.claude/skills/parvis-owner/SKILL.md"
  assert_exists "$sb/.claude/.parvis-install.json"
  assert_exists "$base/parvis-memory/MANIFEST.md"
  assert_exists "$base/parvis-workspace/MANIFEST.md"
  assert_holds "$sb/.claude/CLAUDE.md" "parvis managed block"
  git -C "$base/parvis-memory" rev-parse HEAD > /dev/null 2>&1 || problem "the memory home has no commit"
  git -C "$base/parvis-memory/sections/people-management" rev-parse HEAD > /dev/null 2>&1 || \
    problem "the confidential section is not its own repository"
  assert_says "Owner skill  still the shipped copy"
  assert_silent_on "personalized copy kept"
  cmp -s "$sb/.claude/skills/parvis-owner/SKILL.md" "$REPO/skills/parvis-owner/SKILL.md" || \
    problem "the installed owner skill is not the bundle's copy"
}

# A copy the user has edited is kept on every later run, and the run says so
test_keep() {
  local sb base own
  sb="$(sandbox keep)"; base="$sb/base"
  run_install_base "$sb" "$REPO" "$base"
  assert_rc 0
  own="$sb/.claude/skills/parvis-owner/SKILL.md"
  printf '\nSandbox edit, this line belongs to the user.\n' >> "$own"
  run_install_base "$sb" "$REPO" "$base"
  assert_rc 0
  assert_says "Kept the personalized owner skill"
  assert_says "personalized copy kept"
  assert_holds "$own" "Sandbox edit, this line belongs to the user."
}

# A filled-in profile in the older user skill is adopted into the owner skill
test_adopt() {
  local sb base old own
  sb="$(sandbox adopt)"; base="$sb/base"
  old="$sb/.claude/skills/user/SKILL.md"
  mkdir -p "$(dirname "$old")"
  sed 's/^name: parvis-owner$/name: user/' "$REPO/skills/parvis-owner/SKILL.md" > "$old"
  printf '\nSandbox profile, adopted from the user skill.\n' >> "$old"
  run_install_base "$sb" "$REPO" "$base"
  assert_rc 0
  own="$sb/.claude/skills/parvis-owner/SKILL.md"
  assert_says "Adopted your filled-in profile into parvis-owner"
  assert_says "adopted from the earlier user skill"
  assert_holds "$own" "Sandbox profile, adopted from the user skill."
  assert_holds "$own" "name: parvis-owner"
}

# An uninstall backs a personalized profile up, the next install offers it back, and the write that
# accepting the offer would do puts the saved profile in place
test_restore() {
  local sb base own
  sb="$(sandbox restore)"; base="$sb/base"
  run_install_base "$sb" "$REPO" "$base"
  assert_rc 0
  own="$sb/.claude/skills/parvis-owner/SKILL.md"
  printf '\nSandbox profile, saved by the uninstall.\n' >> "$own"
  run_install_base "$sb" "$REPO" "$base" --uninstall
  assert_rc 0
  assert_says "Backed up the identity profile"
  assert_exists "$base/parvis-memory/MANIFEST.md"
  assert_exists "$sb/.claude/parvis-retired-profile-backup.md"
  run_install_base "$sb" "$REPO" "$base"
  assert_rc 0
  assert_says "a profile backup from"
  assert_says "This run is not interactive, so nothing was restored"
  assert_says "a saved profile backup is waiting"
  # That is the declining half. The accepting half is the write, run here on its own.
  own_from "$sb" "$sb/.claude/parvis-retired-profile-backup.md" || \
    problem "write_owner_from refused the backup the uninstall saved"
  assert_holds "$own" "Sandbox profile, saved by the uninstall."
  assert_holds "$own" "name: parvis-owner"
}

# A release that adds a memory section reaches a home that already exists, row and all
test_section() {
  local sb base b man
  sb="$(sandbox section)"; base="$sb/base"
  run_install_base "$sb" "$REPO" "$base"
  assert_rc 0
  b="$(fake_bundle section)" || { problem "could not build a bundle copy"; return 0; }
  mkdir -p "$b/memory/sections/sandbox-extra"
  printf '# Sandbox extra\n' > "$b/memory/sections/sandbox-extra/README.md"
  printf '| sandbox-extra | test | the sandbox suite | no |\n' >> "$b/memory/MANIFEST.md"
  run_install_base "$sb" "$b" "$base"
  assert_rc 0
  assert_says "Added new section sandbox-extra"
  assert_says "Registered sandbox-extra in the memory manifest"
  man="$base/parvis-memory/MANIFEST.md"
  assert_exists "$base/parvis-memory/sections/sandbox-extra/README.md"
  assert_count "$man" "| sandbox-extra |" 1
  run_install_base "$sb" "$b" "$base"
  assert_rc 0
  assert_count "$man" "| sandbox-extra |" 1
}

# A section the bundle manifest forgot stops the run instead of passing silently
test_section_row_missing() {
  local sb base b
  sb="$(sandbox rowless)"; base="$sb/base"
  run_install_base "$sb" "$REPO" "$base"
  assert_rc 0
  b="$(fake_bundle rowless)" || { problem "could not build a bundle copy"; return 0; }
  mkdir -p "$b/memory/sections/sandbox-rowless"
  printf '# Sandbox rowless\n' > "$b/memory/sections/sandbox-rowless/README.md"
  run_install_base "$sb" "$b" "$base"
  assert_rc 1
  assert_says "has no row for the new section sandbox-rowless"
}

# A release that adds a workspace file reaches an existing home with its manifest row, once
test_ws_file() {
  local sb base b man row
  sb="$(sandbox wsfile)"; base="$sb/base"
  run_install_base "$sb" "$REPO" "$base"
  assert_rc 0
  b="$(fake_bundle wsfile)" || { problem "could not build a bundle copy"; return 0; }
  printf '# Sandbox register\n' > "$b/workspace-seed/tech-plans/sandbox-register.md"
  row='| 2026-09-20 | tech-plans/sandbox-register.md | register | Sandbox suite row | final | system seed |'
  printf '%s\n' "$row" >> "$b/workspace-seed/MANIFEST.md"
  run_install_base "$sb" "$b" "$base"
  assert_rc 0
  assert_says "Added the workspace file tech-plans/sandbox-register.md"
  assert_says "Registered tech-plans/sandbox-register.md in the workspace manifest"
  man="$base/parvis-workspace/MANIFEST.md"
  assert_exists "$base/parvis-workspace/tech-plans/sandbox-register.md"
  assert_count "$man" "tech-plans/sandbox-register.md" 1
  run_install_base "$sb" "$b" "$base"
  assert_rc 0
  assert_count "$man" "tech-plans/sandbox-register.md" 1
}

# A folder whose name ends the way an existing entry does is registered on its own terms, and a file
# the seed manifest says nothing about is passed over without complaint
test_ws_folder() {
  local sb base b line
  sb="$(sandbox wsfolder)"; base="$sb/base"
  run_install_base "$sb" "$REPO" "$base"
  assert_rc 0
  b="$(fake_bundle wsfolder)" || { problem "could not build a bundle copy"; return 0; }
  mkdir -p "$b/workspace-seed/plans"
  : > "$b/workspace-seed/plans/.gitkeep"
  run_install_base "$sb" "$b" "$base"
  assert_rc 0
  assert_says "Added the workspace folder plans"
  assert_says "Registered plans in the workspace manifest"
  assert_silent_on "Could not name"
  line="$(tr -d '\r' < "$base/parvis-workspace/MANIFEST.md" | sed -n 's/^Folders: //p' | head -n 1)"
  printf '%s\n' "$line" | LC_ALL=C awk -F ' · ' '
      { for (i = 1; i <= NF; i++) { n = $i; sub(/ .*$/, "", n); if (n == "plans/") found = 1 } }
      END { exit (found ? 0 : 1) }' || problem "the Folders line does not name plans/ as an entry of its own"
  case "$line" in *tech-plans/*) ;; *) problem "the Folders line lost tech-plans/" ;; esac
}

# A relocation moves both homes and every nested repository, with their histories intact
test_relocate() {
  local sb base base2 before after
  sb="$(sandbox relocate)"; base="$sb/base"; base2="$sb/base-two"
  run_install_base "$sb" "$REPO" "$base"
  assert_rc 0
  before="$(heads "$base")"
  run_install_base "$sb" "$REPO" "$base2" --relocate
  assert_rc 0
  assert_says "relocated"
  assert_absent "$base/parvis-memory"
  assert_exists "$base2/parvis-memory/MANIFEST.md"
  assert_exists "$base2/parvis-workspace/MANIFEST.md"
  after="$(heads "$base2")"
  [ "$before" = "$after" ] || problem "a git HEAD changed across the relocation"
  case "$before" in *none*) problem "a repository had no HEAD before the relocation" ;; esac
  # The managed block writes a home under HOME with a leading tilde, so the tail is what to look for
  assert_holds "$sb/.claude/CLAUDE.md" "base-two/parvis-memory"
}

# The refusals, including the advice an uninstall is given when PARVIS_BASE disagrees
test_refusals() {
  local sb base
  sb="$(sandbox refusals)"; base="$sb/base"
  run_install "$sb" "$REPO" --relocate
  assert_rc 2
  assert_says "--relocate needs PARVIS_BASE"
  run_install "$sb" "$REPO" --purge
  assert_rc 2
  assert_says "--purge only works together with --uninstall"
  run_install_base "$sb" "$REPO" "$sb/.claude"
  assert_rc 1
  assert_says "REFUSED. The data homes cannot be used"
  run_install_base "$sb" "$REPO" "$base"
  assert_rc 0
  run_install_base "$sb" "$REPO" "$sb/elsewhere"
  assert_rc 1
  assert_says "disagrees with the install receipt"
  assert_says "To move them to the new base, run again with --relocate added."
  run_install_base "$sb" "$REPO" "$sb/elsewhere" --uninstall
  assert_rc 1
  assert_says "An uninstall acts on the recorded homes"
  assert_silent_on "run again with --relocate added"
  assert_exists "$base/parvis-memory/MANIFEST.md"
}

# ---- Run --------------------------------------------------------------------------------------

echo "Parvis installer sandbox tests"
echo "  bundle    $REPO"
echo "  sandbox   $WORK"
echo "  real HOME left alone, it is $REAL_HOME"
echo
for t in $TESTS; do run_test "$t"; done
echo
if [ "$FAILED" -gt 0 ]; then
  echo "$PASSED passed, $FAILED FAILED."
  exit 1
fi
echo "$PASSED passed, 0 failed."
exit 0

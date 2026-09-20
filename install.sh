#!/usr/bin/env bash
# Parvis installer for Claude Code on macOS, Linux, WSL, and Windows under Git Bash
#
#   bash install.sh                        install, or update an existing install in place
#   bash install.sh --uninstall            remove skills and the managed block, keep ALL data
#   bash install.sh --uninstall --purge    also remove the data homes, typed confirmation required
#   PARVIS_BASE=/new/base bash install.sh --relocate    move existing homes to a new base, then update
#
# The homes live under a base directory, ~/ai_working_Directory unless PARVIS_BASE names another.
# The first install records the base in its receipt, and later runs keep using it.
# Safe to re-run. Skills are updated in place and existing data homes are never overwritten.
# Needs only bash 3.2 or later plus POSIX tools and git. No jq, python or node, so the install
# receipt is plain JSON laid out one value per line and is read back with grep and sed.
set -euo pipefail

# Git variables inherited from a hook or another tool would point every git call below at the
# wrong repository.
unset GIT_DIR GIT_WORK_TREE GIT_INDEX_FILE GIT_OBJECT_DIRECTORY GIT_COMMON_DIR

MODE="install"
PURGE=0
RELOCATE=0
for arg in "$@"; do
  case "$arg" in
    --uninstall) MODE="uninstall" ;;
    --purge) PURGE=1 ;;
    --relocate) RELOCATE=1 ;;
    -h|--help) sed -n '4,10p' "${BASH_SOURCE[0]}" | sed 's/^# *//'; exit 0 ;;
    *) echo "Unknown option $arg (try --help)" >&2; exit 2 ;;
  esac
done
if [ "$PURGE" -eq 1 ] && [ "$MODE" != "uninstall" ]; then
  echo "--purge only works together with --uninstall." >&2
  exit 2
fi
if [ "$RELOCATE" -eq 1 ] && [ "$MODE" != "install" ]; then
  echo "--relocate cannot be combined with --uninstall." >&2
  exit 2
fi
if [ "$RELOCATE" -eq 1 ] && [ -z "${PARVIS_BASE:-}" ]; then
  echo "--relocate needs PARVIS_BASE set to the new base, for example" >&2
  echo "  PARVIS_BASE=/path/to/new/base bash install.sh --relocate" >&2
  exit 2
fi

# resolve_link PATH prints where a chain of symlinks ends. readlink without -f, for macOS.
resolve_link() {
  local p="$1" l n=0
  while [ -L "$p" ]; do
    n=$((n+1))
    [ "$n" -le 40 ] || return 1
    l="$(readlink "$p")" || return 1
    case "$l" in
      /*) p="$l" ;;
      *) p="$(dirname "$p")/$l" ;;
    esac
  done
  printf '%s\n' "$p"
}

# The bundle is wherever the real install.sh lives, so a symlink to it still finds the skills.
SELF="$(resolve_link "${BASH_SOURCE[0]}")" || SELF="${BASH_SOURCE[0]}"
BUNDLE_DIR="$(cd "$(dirname "$SELF")" && pwd -P)"
SKILLS_DST="$HOME/.claude/skills"
# Base directory for the data homes. PARVIS_BASE wins when set, then the base the receipt records,
# then DEFAULT_BASE. The receipt section below settles the base and the two homes.
DEFAULT_BASE="$HOME/ai_working_Directory"
# strip_slashes PATH prints PATH without trailing slashes, so /a/b/ and /a/b compare equal
strip_slashes() {
  local p="$1"
  while [ "${#p}" -gt 1 ] && [ "${p%/}" != "$p" ]; do p="${p%/}"; done
  printf '%s' "$p"
}
BASE_FROM_ENV="$(strip_slashes "${PARVIS_BASE:-}")"
PARVIS_BASE="${BASE_FROM_ENV:-$DEFAULT_BASE}"
MEM_DST="$PARVIS_BASE/parvis-memory"
WS_DST="$PARVIS_BASE/parvis-workspace"
# The infra installer always wrote its homes here, whatever PARVIS_BASE says
LEGACY_BASE="$HOME/ai_working_Directory"
LEGACY_NAMES=(infra-platform-memory infra-platform-workspace)
CLAUDE_MD="$HOME/.claude/CLAUDE.md"
RECEIPT="$HOME/.claude/.parvis-install.json"
# The base pointer. Uninstall removes the receipt, which was the only record of the base, so the
# base is also kept here, one path on one line. Uninstall leaves this file behind on purpose, and a
# later install with no receipt and no PARVIS_BASE reads it instead of seeding at the default base.
POINTER="$HOME/.claude/.parvis-home"
# tr strips a carriage return that a Windows checkout can leave in VERSION
SYSTEM_VERSION="$( { tr -d ' \t\r\n' < "$BUNDLE_DIR/VERSION"; } 2>/dev/null || true)"

# The roster. Verification checks exactly these twenty names. Release 2.1 added parvis, the
# /parvis session command, 2.2 added parvis-risk-regulatory, 2.3 made the identity skill the
# owner skill parvis-owner, shipped as a template that each person fills in with their own
# background, and 2.4 added parvis-ai-engineering, parvis-sdlc and parvis-software-engineering.
ROSTER=(be-human parvis-owner parvis-ai-engineering parvis-core parvis-exec-writer
        parvis-incident-command parvis-infra-advisor parvis-meeting-prep parvis-memory
        parvis-metrics-advisor parvis-people-leader parvis-portfolio-planning
        parvis-research parvis-reviews parvis-risk-regulatory parvis-sdlc
        parvis-software-engineering parvis-stakeholders parvis-vendor-eval parvis)

# Skills retired by the 2.0 merge. The infra installer never wrote a receipt, so a roster diff
# cannot find these. Every name is spelled out on purpose and no pattern match is ever used.
RETIRED_SKILLS=(infra-platform-advisor infra-platform-comms infra-platform-core
                infra-platform-exec-writer infra-platform-meeting-prep infra-platform-memory
                infra-platform-metrics-advisor infra-platform-org-advisor
                infra-platform-portfolio-planning infra-platform-research infra-platform-reviews
                infra-platform-vendor-eval)

# The owner skill holds the one person's identity and ships as a template. Its first body line is
# this marker, and an installed copy without it has been filled in, so it is never overwritten.
OWNER_SKILL="parvis-owner"
OWNER_MARKER="<!-- parvis:owner-template -->"
# An earlier install shipped the identity skill as user, marked with the older template marker. A
# filled-in copy of it is adopted into the owner skill, and the name is then retired as usual.
OLD_OWNER_SKILL="user"
OLD_OWNER_MARKER="<!-- parvis:user-template -->"
# Where a filled-in identity profile is copied before a skill holding one is removed
PROFILE_BACKUP="$HOME/.claude/parvis-retired-profile-backup.md"

# Memory sections kept as nested local-only repos
CONFIDENTIAL=("people-management" "performance-management" "stakeholders" "risk-regulatory")

# Managed block markers, each spelled once. The opening line is built from VERSION, so the version
# the guard looks for and the version written into the block can never disagree.
MARK="# --- parvis managed block"
END_MARK="# --- end parvis managed block ---"
MARK_LINE="$MARK (v$SYSTEM_VERSION) - do not edit inside, reinstall updates it ---"

# ---- Helpers ---------------------------------------------------------------

# in_list NEEDLE ITEM... succeeds when NEEDLE equals one of the items
in_list() {
  local needle="$1" x
  shift
  for x in "$@"; do [ "$x" = "$needle" ] && return 0; done
  return 1
}

# A skill name must be one plain lowercase path segment. Anything else is refused outright.
# Lowercase only, because macOS APFS and NTFS fold case by default, so a name like SYNCED
# would otherwise resolve to the synced channel. Every roster and retired name is lowercase.
# tools/package-skills.sh loads this exact function from this file, so keep it self-contained.
valid_skill_name() {
  case "$1" in
    ""|.|..|synced|.*|*/*|*[!a-z0-9._-]*) return 1 ;;
  esac
  return 0
}

# is_synced_path PATH succeeds when PATH is the same file as the synced channel. Names are already
# screened by valid_skill_name, so this catches the aliases a name test cannot, such as a link.
is_synced_path() {
  [ -e "$SKILLS_DST/synced" ] && [ "$1" -ef "$SKILLS_DST/synced" ]
}

# remove_skill_dir NAME removes exactly one named skill directory, or a link, under SKILLS_DST.
# Returns 0 when removed, 1 when absent, 2 when refused, 3 when the removal failed. Callers use
# it as "remove_skill_dir n || rc=$?", which turns errexit off inside, so every step is checked here.
remove_skill_dir() {
  local name="$1" target
  if ! valid_skill_name "$name"; then
    echo "      REFUSED to remove '$name', not a plain skill name"
    return 2
  fi
  target="$SKILLS_DST/$name"
  if is_synced_path "$target"; then
    echo "      REFUSED to remove '$name', it resolves to the synced channel"
    return 2
  fi
  if deletes_bundle "$name"; then
    echo "      REFUSED to remove '$name', it is or contains the bundle this script runs from"
    return 2
  fi
  [ -L "$target" ] || [ -d "$target" ] || return 1
  rm -rf "${SKILLS_DST:?}/$name" || true
  if [ -L "$target" ] || [ -e "$target" ]; then
    echo "      FAILED to remove '$name', it is still present"
    return 3
  fi
  return 0
}

# is_template_skill FILE succeeds when FILE still carries a template marker, the owner one or the
# older user one, so it was never filled in. grep -F reads each marker literally, and a trailing CR
# on the line does not matter.
is_template_skill() {
  grep -qF -e "$OWNER_MARKER" -e "$OLD_OWNER_MARKER" "$1" 2>/dev/null
}

# looks_like_profile NAME succeeds when the installed skill NAME holds a filled-in identity profile,
# meaning its SKILL.md lacks the template marker and reads like a profile of a person.
looks_like_profile() {
  local f="$SKILLS_DST/$1/SKILL.md"
  [ -f "$f" ] || return 1
  is_template_skill "$f" && return 1
  LC_ALL=C grep -qiE 'profile version|background about the user' "$f"
}

# backup_profile NAME copies the installed skill NAME's SKILL.md to PROFILE_BACKUP before the skill
# is removed, so a filled-in identity profile is never lost with it. An earlier backup is never
# overwritten, a later one takes a timestamped name beside it. Returns 1 when the copy failed, and
# the caller then keeps the skill.
backup_profile() {
  local src="$SKILLS_DST/$1/SKILL.md" dst="$PROFILE_BACKUP"
  if [ -e "$dst" ]; then
    cmp -s "$src" "$dst" && { echo "      Profile in $1 is already backed up at $(display_path "$dst")."; return 0; }
    dst="${PROFILE_BACKUP%.md}-$(date -u +%Y%m%d%H%M%S).md"
  fi
  mkdir -p "$(dirname "$dst")" && cp "$src" "$dst" || {
    echo "      ERROR. Could not back up the identity profile in $1 to $dst, so $1 was kept."
    return 1
  }
  echo "      Backed up the identity profile in $1 to $(display_path "$dst")."
  echo "      Copy its facts into ~/.claude/skills/$OWNER_SKILL/SKILL.md if that is not filled in yet."
  return 0
}

# newest_profile_backup prints the most recently written profile backup, and nothing when there is
# none. Both spellings count, the first plain one and every timestamped one beside it.
newest_profile_backup() {
  { ls -t "$HOME"/.claude/parvis-retired-profile-backup*.md 2>/dev/null || true; } | head -n 1
}

# profile_backup_stamp FILE prints when the backup was taken, read from the timestamp in its name,
# so a restore offer always says which backup it means.
profile_backup_stamp() {
  local b s
  b="$(basename "$1")"
  s="${b#parvis-retired-profile-backup-}"
  s="${s%.md}"
  case "$s" in
    [0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9])
      printf '%s-%s-%s %s:%s:%s UTC\n' \
        "${s:0:4}" "${s:4:2}" "${s:6:2}" "${s:8:2}" "${s:10:2}" "${s:12:2}" ;;
    *) printf 'an earlier uninstall\n' ;;
  esac
}

# is_own_repo DIR succeeds when DIR is the top level of its own git work tree. A directory that
# only sits inside an enclosing repository, such as a dotfiles repo at $HOME, does not count. A
# worktree or a --separate-git-dir repository, whose .git is a file, does.
is_own_repo() {
  local top
  [ -d "$1" ] || return 1
  top="$(git -C "$1" rev-parse --show-toplevel 2>/dev/null)" || return 1
  [ -n "$top" ] && [ "$top" -ef "$1" ]
}

has_commit() {
  git -C "$1" rev-parse --verify -q HEAD >/dev/null 2>&1
}

# git_commit REPO ARGS... commits with the identity REPO itself sees. Git needs a name and an
# email, so a local fallback is used unless that repository resolves both.
IDENTITY_NOTED=0
git_commit() {
  local repo="$1"
  shift
  if [ -n "$(git -C "$repo" config user.name 2>/dev/null)" ] && \
     [ -n "$(git -C "$repo" config user.email 2>/dev/null)" ]; then
    git -C "$repo" commit "$@"
  else
    if [ "$IDENTITY_NOTED" -eq 0 ]; then
      echo "      No git name and email configured for these repositories, using a local identity."
      echo "      (Optional: git config --global user.name/user.email to use your own.)"
      IDENTITY_NOTED=1
    fi
    git -C "$repo" -c user.name="Parvis User" -c user.email="user@parvis.local" commit "$@"
  fi
}

# ensure_final_newline FILE, so a line appended later never glues onto the last line
ensure_final_newline() {
  [ -s "$1" ] || return 0
  [ -z "$(tail -c 1 "$1")" ] && return 0
  printf '\n' >> "$1"
}

json_escape() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//\"/\\\"}"
  printf '%s' "$s"
}

json_unescape() {
  sed -e 's/\\"/"/g' -e 's/\\\\/\\/g'
}

receipt_valid() {
  [ -f "$RECEIPT" ] && grep -q '^  "system": "parvis",$' "$RECEIPT"
}

# receipt_field KEY prints a scalar written as   "key": "value",
receipt_field() {
  sed -n "s/^  \"$1\": \"\(.*\)\",\{0,1\}\$/\1/p" "$RECEIPT" | head -1 | json_unescape
}

# receipt_list KEY prints one array element per line from the block   "key": [ ... ]
receipt_list() {
  sed -n "/^  \"$1\": \[\$/,/^  \]/p" "$RECEIPT" \
    | sed -n 's/^    "\(.*\)",\{0,1\}$/\1/p' \
    | json_unescape
}

# pointer_base prints the base the pointer file records, trailing slashes stripped, and nothing when
# there is no pointer. Only the first line counts, and a CR a Windows editor left is dropped.
pointer_base() {
  [ -f "$POINTER" ] || return 0
  strip_slashes "$( { head -n 1 "$POINTER" | tr -d '\r'; } 2>/dev/null || true)"
  printf '\n'
}

# write_pointer records the base in use, so the location survives the receipt. Written on every
# install and refreshed on uninstall, which is the run that takes the receipt away.
write_pointer() {
  mkdir -p "$(dirname "$POINTER")" || return 1
  printf '%s\n' "$(dirname "$MEM_DST")" > "$POINTER.tmp" && mv -f "$POINTER.tmp" "$POINTER"
}

# block_scan MODE FILE is the one parser for the managed block. The guard, the version check and
# the strip all use it, so they can never disagree about what a block is.
#   A start line holds the start marker at its beginning, after optional leading whitespace.
#   A block runs from a start line to the NEAREST end line after it. An end line is the end marker
#   alone on its line, leading and trailing whitespace and a CR tolerated.
#   A start followed by another start before any end is an orphan. A start with no end after it is
#   unclosed. Either one makes the file malformed.
# MODE status prints "blocks N", "malformed N" and "version V" for the first block.
# MODE body prints the first block's lines, CR removed.
# MODE strip prints the file without its blocks and changes nothing when the file is malformed.
# Exit status 0 when a block exists, 1 when none does, 2 when the file is malformed.
# LC_ALL=C keeps a file that is not valid UTF-8 readable byte by byte. BINMODE=3 stops GNU awk on
# Windows from dropping CR on read, so a CRLF file keeps its line endings. Any other awk treats
# BINMODE as an unused variable.
block_scan() {
  LC_ALL=C awk -v BINMODE=3 -v mode="$1" -v start="$MARK" -v end="$END_MARK" '
    {
      raw[NR] = $0
      t = $0
      sub(/\r$/, "", t)
      sub(/^[ \t]+/, "", t)
      if (index(t, start) == 1) { kind[NR] = "S"; next }
      sub(/[ \t]+$/, "", t)
      if (t == end) kind[NR] = "E"
    }
    END {
      open = 0; nb = 0; bad = 0; first = 0; firstend = 0
      for (i = 1; i <= NR; i++) {
        if (kind[i] == "S") {
          if (open) bad++
          open = i
        } else if (kind[i] == "E" && open) {
          nb++
          for (j = open; j <= i; j++) inblk[j] = 1
          if (nb == 1) { first = open; firstend = i }
          open = 0
        }
      }
      if (open) bad++
      if (mode == "status") {
        v = ""
        if (first) {
          s = raw[first]
          if (match(s, /\(v[0-9][0-9.]*\)/)) v = substr(s, RSTART + 2, RLENGTH - 3)
        }
        print "blocks " nb
        print "malformed " bad
        print "version " v
      } else if (mode == "body") {
        for (i = first; first && i <= firstend; i++) { s = raw[i]; sub(/\r$/, "", s); print s }
      } else if (mode == "strip" && !bad) {
        for (i = 1; i <= NR; i++) if (!inblk[i]) print raw[i]
      }
      if (bad) exit 2
      exit (nb ? 0 : 1)
    }
  ' "$2"
}

# claude_md_status FIELD prints one field of block_scan status for CLAUDE.md, 0 or empty if absent
claude_md_status() {
  if [ -f "$CLAUDE_MD" ]; then
    { block_scan status "$CLAUDE_MD" || true; } | sed -n "s/^$1 //p"
  elif [ "$1" != "version" ]; then
    echo 0
  fi
}

display_path() {
  case "$1" in
    "$HOME"/*) printf '~/%s' "${1#"$HOME"/}" ;;
    *) printf '%s' "$1" ;;
  esac
}

# print_block writes the current managed block, naming the homes this install actually uses
print_block() {
  printf '%s\n' "$MARK_LINE" \
    "- Load the parvis-owner skill before any substantive work. It is the identity source for who the user is." \
    "- You are Parvis, the user's trusted companion. Prime Directive: make the user better at everything they choose to do, and never let them walk into something blind. Its rules live in parvis-core." \
    "- Apply the be-human skill to ALL generated prose, including the punctuation preferences in the parvis-owner skill. When it states none, use no em dashes and keep colons and semicolons to a minimum." \
    "- For any work matter, check whether a parvis-* skill applies and consult parvis-core (tenets, frameworks) first." \
    "- Memory lives at $(display_path "$MEM_DST"); say \"help\" for the system's own guidance." \
    "- Working documents live in the second home at $(display_path "$WS_DST"), routed by its MANIFEST." \
    "$END_MARK"
}

# rewrite_claude_md ADD rebuilds CLAUDE.md with every managed block removed and, when ADD is 1,
# the current block appended. The new text is written to a temporary file in the same directory
# and renamed over the old one, so the only full copy is never truncated. A symlinked CLAUDE.md
# keeps its link, because the file replaced is the link's target. The temporary file starts as
# a copy of the original, so the file mode carries over. A read-only CLAUDE.md is refused, since
# replacing it would override the user's own protection. Returns 0 on success, 2 when the file
# is malformed, 3 when it is read-only, 1 on any other failure, and on any failure the original
# is left as it was.
rewrite_claude_md() {
  local add="$1" target dir tmp rc=0
  target="$(resolve_link "$CLAUDE_MD")" || return 1
  dir="$(dirname "$target")"
  mkdir -p "$dir" || return 1
  tmp="$dir/.CLAUDE.md.parvis-tmp.$$"
  rm -f "$tmp" || return 1
  if [ -f "$target" ]; then
    [ -w "$target" ] || return 3
    cp -p "$target" "$tmp" || { rm -f "$tmp"; return 1; }
    # The status of block_scan is kept apart from the redirection's own status, so a temporary
    # file that cannot be written is a failure and never passes for the harmless no-block code.
    { block_scan strip "$target" || rc=$?; } > "$tmp" || { rm -f "$tmp"; return 1; }
    if [ "$rc" -gt 1 ]; then rm -f "$tmp"; return "$rc"; fi
  else
    : > "$tmp" || return 1
  fi
  if [ "$add" -eq 1 ]; then
    ensure_final_newline "$tmp" || { rm -f "$tmp"; return 1; }
    # One blank line separates the block from the text above it, and only when that text does not
    # already end in a blank line, so repeated upgrades never pile up blank lines.
    if [ -s "$tmp" ] && [ -n "$(tail -n 1 "$tmp" | LC_ALL=C tr -d ' \t\r')" ]; then
      printf '\n' >> "$tmp" || { rm -f "$tmp"; return 1; }
    fi
    print_block >> "$tmp" || { rm -f "$tmp"; return 1; }
  fi
  mv -f "$tmp" "$target" || { rm -f "$tmp"; return 1; }
  return 0
}

# legacy_homes prints every legacy infra data home under every base this installer knows
legacy_homes() {
  local b n seen
  seen=()
  for b in "$LEGACY_BASE" "$PARVIS_BASE" "$(dirname "$MEM_DST")" "$(dirname "$WS_DST")"; do
    in_list "$b" ${seen[@]+"${seen[@]}"} && continue
    seen+=("$b")
    for n in "${LEGACY_NAMES[@]}"; do
      if [ -e "$b/$n" ] || [ -L "$b/$n" ]; then printf '%s\n' "$b/$n"; fi
    done
  done
}

synced_note() {
  local n
  [ -d "$SKILLS_DST/synced" ] || return 0
  n="$( { find "$SKILLS_DST/synced" -maxdepth 3 -type d \
          \( -name "$OLD_OWNER_SKILL" -o -name 'parvis' -o -name 'parvis-*' -o -name 'be-human' \
             -o -name 'infra-platform-*' \) 2>/dev/null || true; } | wc -l | tr -d ' ')"
  echo
  echo "NOTE. Found $SKILLS_DST/synced, the claude.ai account sync channel."
  echo "      This installer cannot reach it and never modifies anything under it."
  echo "      It holds $n directories named like Parvis, user, be-human or infra-platform skills."
  echo "      Skills delivered by claude.ai sync must be retired on the claude.ai side."
}

# real_path PATH prints PATH with every link resolved. A part of PATH that does not exist yet is
# kept as written below its deepest existing ancestor, so a missing home under a linked base
# still resolves to where it would be created.
real_path() {
  local p="$1" rest="" r
  while [ ! -d "$p" ]; do
    case "$p" in
      /|"") printf '%s\n' "$1"; return 0 ;;
    esac
    rest="/$(basename "$p")$rest"
    p="$(dirname "$p")"
  done
  r="$(cd "$p" 2>/dev/null && pwd -P)" || { printf '%s\n' "$1"; return 0; }
  [ "$r" = "/" ] && [ -n "$rest" ] && r=""
  printf '%s\n' "$r$rest"
}

# lower TEXT prints TEXT in lowercase, for comparing paths the way a case folding disk does
lower() {
  printf '%s\n' "$1" | tr 'ABCDEFGHIJKLMNOPQRSTUVWXYZ' 'abcdefghijklmnopqrstuvwxyz'
}

# home_problem PATH NAME prints why PATH cannot be a data home named NAME, and prints nothing when
# it can. A home path is later given to rm -rf by --purge, so it must be an absolute path with no
# . or .. segment, end in exactly NAME, neither be nor contain $HOME, /, ~/.claude or the skills
# directory, and not sit anywhere inside ~/.claude.
home_problem() {
  local p="$1" want="$2" rp q rq x
  case "$p" in
    "") echo "it is empty"; return 0 ;;
    /*) ;;
    *) echo "it is not an absolute path"; return 0 ;;
  esac
  case "$p" in
    */./*|*/.|*/../*|*/..) echo "it has a . or .. segment"; return 0 ;;
  esac
  [ "$(basename "$p")" = "$want" ] || { echo "its last segment is not $want"; return 0; }
  rp="$(real_path "$p")"
  for q in / "$HOME" "$HOME/.claude" "$SKILLS_DST"; do
    rq="$(real_path "$q")"
    if [ "$p" -ef "$q" ] || [ "$rp" = "$rq" ]; then echo "it is $q"; return 0; fi
    case "$rq/" in
      "$rp"/*) echo "it contains $q"; return 0 ;;
    esac
    case "$q/" in
      "$p"/*) echo "it contains $q"; return 0 ;;
    esac
  done
  # Nothing under ~/.claude can be a home. That tree holds the skills directory and the synced
  # channel, where a home would collide with a skill that uninstall removes, or be rm -rf'd by
  # --purge from inside the channel. Both the written and the resolved path are tested, and in
  # lowercase too, because a case folding disk treats .Claude as .claude. Every existing ancestor
  # is also compared with -ef, because one place can have two spellings, such as a Windows
  # junction that pwd -P reports under a different mount.
  rq="$(real_path "$HOME/.claude")"
  for q in "$p" "$rp"; do
    for x in "$q" "$(lower "$q")"; do
      case "$x/" in
        "$HOME/.claude"/*|"$rq"/*|"$(lower "$HOME/.claude")"/*|"$(lower "$rq")"/*)
          echo "it is inside $HOME/.claude"; return 0 ;;
      esac
    done
    x="$q"
    while [ "$x" != "/" ] && [ -n "$x" ]; do
      if [ -e "$x" ] && [ -e "$HOME/.claude" ] && [ "$x" -ef "$HOME/.claude" ]; then
        echo "it is inside $HOME/.claude"; return 0
      fi
      x="$(dirname "$x")"
    done
  done
  return 0
}

# path_within A B succeeds when A is B or lies anywhere below B. Resolved paths are compared as
# strings, in lowercase too for a case folding disk, and every existing ancestor of A is also
# compared with -ef, because one place can have two spellings, such as a Windows junction that
# pwd -P reports under a different mount. This is the same approach home_problem uses.
path_within() {
  local a="$1" b="$2" ra rb x
  [ -e "$b" ] || [ -L "$b" ] || return 1
  ra="$(real_path "$a")"
  rb="$(real_path "$b")"
  for x in "$ra/" "$(lower "$ra")/"; do
    case "$x" in
      "$rb"/*|"$(lower "$rb")"/*) return 0 ;;
    esac
  done
  x="$a"
  while [ "$x" != "/" ] && [ -n "$x" ]; do
    if [ -e "$x" ] && [ "$x" -ef "$b" ]; then return 0; fi
    x="$(dirname "$x")"
  done
  return 1
}

# deletes_bundle NAME succeeds when removing $SKILLS_DST/NAME would destroy the bundle this script
# runs from, because the bundle or that skill's own source is that directory or lies inside it.
# Replacing a skill deletes its old copy first, and rm -rf through a link or a junction reaches the
# source, so this is checked at every point where a skill directory is about to be removed.
deletes_bundle() {
  local t="$SKILLS_DST/$1"
  [ -e "$t" ] || [ -L "$t" ] || return 1
  path_within "$BUNDLE_DIR" "$t" && return 0
  [ -e "$BUNDLE_DIR/skills/$1" ] && path_within "$BUNDLE_DIR/skills/$1" "$t" && return 0
  return 1
}

# homes_problem MEM WS prints why this pair of homes cannot be used, and nothing when it can
homes_problem() {
  local why
  why="$(home_problem "$1" parvis-memory)"
  [ -z "$why" ] || { echo "memory home $1 is refused, $why"; return 0; }
  why="$(home_problem "$2" parvis-workspace)"
  [ -z "$why" ] || { echo "workspace home $2 is refused, $why"; return 0; }
  if [ "$1" = "$2" ] || [ "$1" -ef "$2" ]; then
    echo "the memory and workspace homes are the same directory"
  fi
  return 0
}

# ---- Relocation helpers ------------------------------------------------------

# existing_ancestor PATH prints PATH, or its deepest ancestor that exists
existing_ancestor() {
  local p="$1"
  while [ ! -e "$p" ] && [ "$p" != "/" ] && [ "$p" != "." ]; do p="$(dirname "$p")"; done
  printf '%s\n' "$p"
}

# volume_of PATH prints the device number of PATH's deepest existing ancestor, and nothing when the
# platform cannot tell. GNU stat, Git Bash included, takes -c, and BSD stat on macOS takes -f.
volume_of() {
  local p
  p="$(existing_ancestor "$1")"
  stat -c %d "$p" 2>/dev/null || stat -f %d "$p" 2>/dev/null || true
}

# head_of REPO prints the commit REPO's HEAD names, or none for a repository with no commit
head_of() {
  git -C "$1" rev-parse -q --verify HEAD 2>/dev/null || echo none
}

# repo_clean REPO succeeds when git status in REPO reports nothing, untracked files included
repo_clean() {
  local out
  out="$(git -C "$1" status --porcelain 2>/dev/null)" || return 1
  [ -z "$out" ]
}

# nested_repos HOME prints, relative to HOME, every git repository nested anywhere below it, such as
# the confidential sections. The home's own .git is skipped and never searched.
nested_repos() {
  local h="$1" g
  find "$h" \( -path "$h/.git" -prune \) -o \( -name .git -prune -print \) 2>/dev/null |
    while IFS= read -r g; do
      g="$(dirname "$g")"
      printf '%s\n' "${g#"$h"/}"
    done
}

# ---- The base and the homes: PARVIS_BASE, then the receipt, then the default -
REC_MEM_RAW=""
REC_WS_RAW=""
REC_MEM=""
REC_WS=""
REC_BASE=""
# Where --relocate moves the homes from. Empty unless the recorded homes differ from the new ones.
RELOC_FROM_MEM=""
RELOC_FROM_WS=""
# The receipt is a plain file anyone can edit, so a recorded base or home is checked before it is
# used. A recorded home that fails the check is never used. --purge and --relocate then refuse
# outright, and any other mode falls back to the default homes and says so.
if receipt_valid; then
  # A normal run without PARVIS_BASE keeps the base the receipt records
  REC_BASE="$(strip_slashes "$(receipt_field base)")"
  if [ -z "$BASE_FROM_ENV" ] && [ -n "$REC_BASE" ]; then
    why="$(homes_problem "$REC_BASE/parvis-memory" "$REC_BASE/parvis-workspace")"
    if [ -z "$why" ]; then
      PARVIS_BASE="$REC_BASE"
      MEM_DST="$PARVIS_BASE/parvis-memory"
      WS_DST="$PARVIS_BASE/parvis-workspace"
    else
      echo "WARNING. The install receipt records the base $REC_BASE, which cannot be used, $why."
      echo "      It is ignored."
    fi
  fi
  REC_MEM="$(receipt_field memory_home)"
  REC_WS="$(receipt_field workspace_home)"
  # Kept even when untrusted, so uninstall never removes a skill directory a receipt calls a home
  REC_MEM_RAW="$REC_MEM"
  REC_WS_RAW="$REC_WS"
  REC_WHY=""
  if [ -n "$REC_MEM" ] || [ -n "$REC_WS" ]; then
    REC_WHY="$(homes_problem "$REC_MEM" "$REC_WS")"
  fi
  if [ -n "$REC_WHY" ]; then
    if [ "$PURGE" -eq 1 ] || [ "$RELOCATE" -eq 1 ]; then
      echo "REFUSED. The install receipt $RECEIPT records data homes that cannot be trusted," >&2
      echo "  $REC_WHY." >&2
      echo "--purge and --relocate never touch a path they cannot trust. Nothing was changed." >&2
      exit 1
    fi
    # A recorded home that still holds data, where the default home does not exist yet, is most
    # likely an older install's home under a former name. Seeding empty homes beside it would split
    # the user's memory in two, so install stops and says how to move it.
    if [ "$MODE" = "install" ]; then
      for pair in "$REC_MEM|$MEM_DST" "$REC_WS|$WS_DST"; do
        r="${pair%%|*}"
        d="${pair#*|}"
        if [ -n "$r" ] && [ -d "$r" ] && [ ! -e "$d" ]; then
          echo "REFUSED. The install receipt records data homes that cannot be used as they are," >&2
          echo "  $REC_WHY." >&2
          echo "  The recorded home $r still holds data and $d does not exist yet, so installing now would seed an" >&2
          echo "  empty home beside it. Move it first, for example" >&2
          echo "    mv \"$r\" \"$d\"" >&2
          echo "  then run the installer again. Nothing was changed." >&2
          exit 1
        fi
      done
    fi
    echo "WARNING. The install receipt records data homes that cannot be trusted, $REC_WHY."
    echo "      They are ignored. This run uses $MEM_DST and $WS_DST instead."
    REC_MEM=""
    REC_WS=""
  fi
  if [ -n "$REC_MEM" ] && [ -n "$REC_WS" ] && { [ "$REC_MEM" != "$MEM_DST" ] || [ "$REC_WS" != "$WS_DST" ]; }; then
    if [ -n "$BASE_FROM_ENV" ] && [ "$RELOCATE" -eq 1 ]; then
      RELOC_FROM_MEM="$REC_MEM"
      RELOC_FROM_WS="$REC_WS"
    elif [ -n "$BASE_FROM_ENV" ] && [ ! -e "$REC_MEM" ] && [ ! -L "$REC_MEM" ] && \
         [ ! -e "$REC_WS" ] && [ ! -L "$REC_WS" ]; then
      # Both recorded homes are gone, removed by the user to start fresh, so the new base wins
      echo "NOTE. The homes the receipt records no longer exist, so this run uses PARVIS_BASE=$BASE_FROM_ENV."
    elif [ -n "$BASE_FROM_ENV" ]; then
      echo "REFUSED. PARVIS_BASE=$BASE_FROM_ENV disagrees with the install receipt, which records" >&2
      echo "  memory at $REC_MEM" >&2
      echo "  workspace at $REC_WS" >&2
      echo "To keep the recorded homes, run again without PARVIS_BASE." >&2
      echo "To move them to the new base, run again with --relocate added." >&2
      echo "To start fresh at the new base, remove the old homes yourself first." >&2
      echo "Nothing was changed." >&2
      exit 1
    else
      MEM_DST="$REC_MEM"
      WS_DST="$REC_WS"
    fi
  fi
fi
# The pointer file, read only when there is no receipt at all and no PARVIS_BASE. It is what an
# uninstall leaves behind, so a plain reinstall finds the real homes instead of seeding a second,
# empty pair at the default base. A pointed-at base passes the same path checks as any other, so a
# pointer naming $HOME, a parent of it or anything under ~/.claude is refused like any other path.
POINTER_BASE="$(pointer_base)"
if [ -n "$POINTER_BASE" ] && [ -z "$BASE_FROM_ENV" ] && ! receipt_valid; then
  why="$(homes_problem "$POINTER_BASE/parvis-memory" "$POINTER_BASE/parvis-workspace")"
  if [ -n "$why" ]; then
    echo "WARNING. $(display_path "$POINTER") names the base $POINTER_BASE, which cannot be used, $why."
    echo "      It is ignored."
    POINTER_BASE=""
  else
    PARVIS_BASE="$POINTER_BASE"
    MEM_DST="$PARVIS_BASE/parvis-memory"
    WS_DST="$PARVIS_BASE/parvis-workspace"
    echo "NOTE. No install receipt. The base $PARVIS_BASE comes from $(display_path "$POINTER")."
  fi
fi
if [ "$RELOCATE" -eq 1 ] && [ -z "$RELOC_FROM_MEM" ] && { [ -z "$REC_MEM" ] || [ -z "$REC_WS" ]; }; then
  echo "REFUSED. --relocate moves the homes the install receipt records, and $RECEIPT records none." >&2
  echo "Run bash install.sh once without --relocate first. Nothing was changed." >&2
  exit 1
fi
# The homes in use, from the receipt or from PARVIS_BASE, pass the same check. Install and --purge
# refuse before changing anything. A plain uninstall never touches the homes, so it goes on.
HOMES_WHY="$(homes_problem "$MEM_DST" "$WS_DST")"
if [ -n "$HOMES_WHY" ] && { [ "$MODE" = "install" ] || [ "$PURGE" -eq 1 ]; }; then
  echo "REFUSED. The data homes cannot be used, $HOMES_WHY." >&2
  echo "Set PARVIS_BASE to an absolute directory of its own. Nothing was changed." >&2
  exit 1
fi

# The safety net under the pointer. Before a home is seeded fresh, every base this machine has a
# record of is checked for homes that already exist. Seeding beside them would split the user's
# memory in two, silently, so the run stops and names the command that uses the real homes.
if [ "$MODE" = "install" ] && [ "$RELOCATE" -eq 0 ] && { [ ! -d "$MEM_DST" ] || [ ! -d "$WS_DST" ]; }; then
  for cand in "$REC_BASE" "$POINTER_BASE"; do
    [ -n "$cand" ] || continue
    [ "$cand" = "$(dirname "$MEM_DST")" ] && continue
    if [ -d "$cand/parvis-memory" ] || [ -d "$cand/parvis-workspace" ]; then
      echo "REFUSED. Parvis homes already exist at the base" >&2
      echo "  $cand" >&2
      echo "and this run would seed a second, empty pair at" >&2
      echo "  $(dirname "$MEM_DST")" >&2
      echo "To install against the homes you already have, run" >&2
      echo "  PARVIS_BASE=\"$cand\" bash install.sh" >&2
      echo "To move them to the new base instead, add --relocate to that command." >&2
      echo "To start fresh at the new base, move or remove the homes at $cand first." >&2
      echo "Nothing was changed." >&2
      exit 1
    fi
  done
fi

# ---- Uninstall mode --------------------------------------------------------
if [ "$MODE" = "uninstall" ]; then
  echo "Parvis uninstaller, bundle release ${SYSTEM_VERSION:-unknown}"
  echo
  problems=0

  PURGE_LIST=()
  if [ "$PURGE" -eq 1 ]; then
    # Refuse before changing anything, so a pipe or a script can never trigger a purge
    if [ ! -t 0 ]; then
      echo "REFUSED. --purge needs an interactive terminal on stdin and will not run from a pipe or script." >&2
      echo "Nothing was changed." >&2
      exit 1
    fi
    # rm -rf on a link removes only the link, so a linked home is refused rather than reported
    # as purged while its data survives at the other end.
    linked=0
    for h in "$MEM_DST" "$WS_DST"; do
      if [ -L "$h" ]; then
        echo "REFUSED. $h is a link to $(cd "$h" 2>/dev/null && pwd -P || echo 'a missing target')." >&2
        echo "      --purge never deletes through a link. Delete the real directory by hand if you" >&2
        echo "      mean to, then remove the link." >&2
        linked=1
      elif [ -d "$h" ]; then
        PURGE_LIST+=("$h")
      fi
    done
    if [ "$linked" -eq 1 ]; then
      echo "Nothing was changed." >&2
      exit 1
    fi
    echo "--purge will PERMANENTLY DELETE these data homes and everything in them."
    if [ "${#PURGE_LIST[@]}" -eq 0 ]; then
      echo "      (none present at $MEM_DST or $WS_DST)"
    else
      for h in "${PURGE_LIST[@]}"; do
        echo "      $h  ($(find "$h" -type f | wc -l | tr -d ' ') files, git history included)"
      done
      for s in "${CONFIDENTIAL[@]}"; do
        is_own_repo "$MEM_DST/sections/$s" && \
          echo "      includes the local-only repo sections/$s, which has no copy anywhere else"
      done
    fi
    while IFS= read -r h; do
      [ -n "$h" ] && echo "      NOT deleted, legacy home $h (remove it by hand if you mean to)"
    done < <(legacy_homes)
    printf 'Type the word purge to proceed, anything else cancels: '
    answer=""
    read -r answer || true
    if [ "$answer" != "purge" ]; then
      echo "Purge not confirmed. Nothing was changed."
      exit 1
    fi
  fi

  echo "[1/4] Removing skills from $SKILLS_DST"
  UNINSTALL_LIST=()
  if receipt_valid; then
    while IFS= read -r n; do
      [ -n "$n" ] && ! in_list "$n" ${UNINSTALL_LIST[@]+"${UNINSTALL_LIST[@]}"} && UNINSTALL_LIST+=("$n")
    done < <(receipt_list skills)
    echo "      Receipt found, release $(receipt_field release), ${#UNINSTALL_LIST[@]} skills claimed."
  else
    echo "      No install receipt at $RECEIPT."
    echo "      Only the hardcoded retired infra-platform skills will be removed. Nothing else is"
    echo "      claimed, so nothing else is touched."
  fi
  for n in "${RETIRED_SKILLS[@]}"; do
    in_list "$n" ${UNINSTALL_LIST[@]+"${UNINSTALL_LIST[@]}"} || UNINSTALL_LIST+=("$n")
  done
  removed=0
  remove_failed=0
  home_refused=0
  profile_kept=0
  for n in ${UNINSTALL_LIST[@]+"${UNINSTALL_LIST[@]}"}; do
    rc=0
    # A skill directory that is also a data home, as an older install could have left it, holds
    # user data. It is never removed here, and --purge is the only way to delete a home.
    for h in "$MEM_DST" "$WS_DST" "$REC_MEM_RAW" "$REC_WS_RAW"; do
      if [ -n "$h" ] && [ -e "$SKILLS_DST/$n" ] && \
         { [ "$SKILLS_DST/$n" -ef "$h" ] || [ "$(real_path "$SKILLS_DST/$n")" = "$(real_path "$h")" ]; }; then
        echo "      REFUSED to remove '$n', it is the data home $h. Move your data out, then remove it by hand."
        rc=2
        home_refused=1
        break
      fi
    done
    # A filled-in identity profile, the owner skill or an older one, is user data too. It is backed
    # up before removal, and kept when the backup fails.
    if [ "$rc" -eq 0 ] && valid_skill_name "$n" && ! is_synced_path "$SKILLS_DST/$n" && looks_like_profile "$n"; then
      backup_profile "$n" || { rc=2; profile_kept=1; }
    fi
    [ "$rc" -eq 0 ] && { remove_skill_dir "$n" || rc=$?; }
    case "$rc" in
      0) echo "      removed  $n"; removed=$((removed+1)) ;;
      3) remove_failed=1 ;;
    esac
  done
  echo "      $removed skill directories removed. Nothing else under $SKILLS_DST was touched."
  if [ "$remove_failed" -eq 1 ]; then
    echo "      ERROR. At least one skill directory could not be removed, see above."
    problems=1
  fi
  if [ "$home_refused" -eq 1 ]; then
    echo "      ERROR. A skill directory is also a data home and was left in place, see above."
    problems=1
  fi
  if [ "$profile_kept" -eq 1 ]; then
    echo "      ERROR. An identity profile could not be backed up, so its skill was left in place."
    problems=1
  fi

  echo "[2/4] Managed block in $CLAUDE_MD"
  if [ "$(claude_md_status malformed)" != "0" ]; then
    echo "      WARNING. A start marker has no end marker of its own. File left unchanged, edit it by hand."
    problems=1
  elif [ "$(claude_md_status blocks)" = "0" ]; then
    echo "      No managed block present."
  else
    rc=0
    rewrite_claude_md 0 || rc=$?
    # Removal is reported only once the file is read back and holds no block
    if [ "$rc" -eq 0 ] && [ "$(claude_md_status blocks)" = "0" ]; then
      echo "      Managed block removed."
    elif [ "$rc" -eq 3 ]; then
      echo "      ERROR. The file is read-only, so the managed block was NOT removed. Make it"
      echo "      writable and run the uninstall again, or delete the block by hand."
      problems=1
    else
      echo "      ERROR. Could not rewrite the file, so the managed block was NOT removed."
      problems=1
    fi
  fi

  echo "[3/4] Data homes"
  if [ "$PURGE" -eq 1 ]; then
    for h in ${PURGE_LIST[@]+"${PURGE_LIST[@]}"}; do
      case "$h" in
        "$MEM_DST") rm -rf "${MEM_DST:?}" || true ;;
        "$WS_DST") rm -rf "${WS_DST:?}" || true ;;
      esac
      if [ -e "$h" ] || [ -L "$h" ]; then
        echo "      FAILED to purge $h, some of it is still there."
        problems=1
      else
        echo "      purged   $h"
      fi
    done
    for b in "$(dirname "$MEM_DST")" "$(dirname "$WS_DST")"; do
      [ -d "$b" ] && rmdir "$b" 2>/dev/null && echo "      removed empty $b"
    done
  else
    for h in "$MEM_DST" "$WS_DST"; do
      if [ -d "$h" ] || [ -L "$h" ]; then echo "      retained $h"; fi
    done
    echo "      Data homes are kept. Use --uninstall --purge to delete them."
  fi
  # The receipt goes next, and it was the only record of the base. The pointer keeps it, so a plain
  # reinstall finds these homes again instead of seeding an empty pair at the default base.
  if write_pointer; then
    echo "      Base $(dirname "$MEM_DST") remembered in $(display_path "$POINTER"), which is left behind."
  else
    echo "      WARNING. Could not write $(display_path "$POINTER"), so the base is not remembered."
    echo "      Reinstall with the PARVIS_BASE command printed at the end of this run."
  fi
  while IFS= read -r h; do
    [ -n "$h" ] && [ "$PURGE" -eq 0 ] && echo "      legacy home left untouched  $h"
  done < <(legacy_homes)

  echo "[4/4] Install receipt"
  # Deleted last, so an interrupted uninstall can simply be run again. Kept when a skill could
  # not be removed, because the receipt is the only record that lets a re-run claim it.
  if [ "$remove_failed" -eq 1 ] || [ "$home_refused" -eq 1 ] || [ "$profile_kept" -eq 1 ]; then
    echo "      Receipt KEPT, so a re-run can still claim the skills that were not removed."
  elif [ -f "$RECEIPT" ]; then
    rm -f "$RECEIPT" || true
    if [ -e "$RECEIPT" ]; then
      echo "      ERROR. Could not remove the receipt."
      problems=1
    else
      echo "      Receipt removed."
    fi
  else
    echo "      No receipt present."
  fi

  synced_note
  echo
  # The base, spelled out, and the one command that reinstalls against it. Printed whether the run
  # succeeded or not, because this is the fact the user needs and the receipt no longer holds it.
  echo "Base   $(dirname "$MEM_DST")"
  if [ "$PURGE" -eq 1 ]; then
    echo "       The data homes there were deleted by --purge. A reinstall seeds new ones."
  else
    echo "       Your data homes are still there, untouched."
  fi
  echo "Reinstall with"
  echo "  PARVIS_BASE=\"$(dirname "$MEM_DST")\" bash install.sh"
  echo "A plain bash install.sh finds the same base, from $(display_path "$POINTER")."
  echo
  if [ "$problems" -eq 0 ]; then
    echo "Uninstall complete. Restart Claude Code so it drops the removed skills."
    exit 0
  fi
  echo "Uninstall finished WITH ERRORS above. Fix them and run it again (safe to re-run)."
  exit 1
fi

# ---- Install or update mode ------------------------------------------------
echo "Parvis installer, release ${SYSTEM_VERSION:-unknown}"
echo "Bundle: $BUNDLE_DIR"

# Detect a previous install. Receipt first, then the managed-block marker, then the skill header.
PREV_VERSION=""
PREV_SOURCE=""
PREV_ROSTER=()
if receipt_valid; then
  PREV_VERSION="$(receipt_field release)"
  PREV_SOURCE="install receipt"
  while IFS= read -r n; do [ -n "$n" ] && PREV_ROSTER+=("$n"); done < <(receipt_list skills)
elif [ -f "$RECEIPT" ]; then
  echo "WARNING. $RECEIPT is not a Parvis receipt, ignoring it."
fi
if [ -z "$PREV_VERSION" ]; then
  PREV_VERSION="$(claude_md_status version)"
  [ -n "$PREV_VERSION" ] && PREV_SOURCE="managed block marker"
fi
if [ -z "$PREV_VERSION" ] && [ -f "$SKILLS_DST/parvis-core/SKILL.md" ]; then
  PREV_VERSION="$(LC_ALL=C sed -n -e 's/.*Parvis release \([0-9][0-9.]*\).*/\1/p' \
    "$SKILLS_DST/parvis-core/SKILL.md" | head -1)"
  [ -n "$PREV_VERSION" ] && PREV_SOURCE="parvis-core skill header"
fi
if [ -n "$PREV_VERSION" ]; then
  echo "Mode: update, found release $PREV_VERSION (from the $PREV_SOURCE)"
  [ "$PREV_SOURCE" = "install receipt" ] || \
    echo "      No receipt, so the previous roster is unknown. Only the hardcoded retired list applies."
else
  echo "Mode: fresh install"
fi
echo

# ---- 0. Preflight, before anything is changed -------------------------------
# Everything that can make a run fail halfway is checked here first. A symlinked install.sh, a
# partial bundle, a skills directory that is really the bundle's own, or a damaged CLAUDE.md
# stops the run here with nothing changed.
echo "[0/5] Preflight"
pre_fail=0
pre_error() { echo "      ERROR. $*"; pre_fail=1; }
command -v git >/dev/null 2>&1 || pre_error "git is not installed."
[ -n "$SYSTEM_VERSION" ] || pre_error "The bundle at $BUNDLE_DIR has no VERSION file."
BUNDLE_SKILLS=()
for d in "$BUNDLE_DIR"/skills/*/ ; do
  [ -d "$d" ] || continue
  name="$(basename "$d")"
  valid_skill_name "$name" || { echo "      SKIPPED bundle entry '$name', not a plain skill name"; continue; }
  is_synced_path "$SKILLS_DST/$name" && { echo "      SKIPPED bundle entry '$name', it resolves to the synced channel"; continue; }
  BUNDLE_SKILLS+=("$name")
done
for n in "${ROSTER[@]}"; do
  [ -f "$BUNDLE_DIR/skills/$n/SKILL.md" ] || pre_error "The bundle lacks roster skill $n."
done
for n in ${BUNDLE_SKILLS[@]+"${BUNDLE_SKILLS[@]}"}; do
  in_list "$n" "${ROSTER[@]}" || echo "      WARNING. Bundle skill $n is not in the frozen roster"
done
[ -f "$BUNDLE_DIR/memory/MANIFEST.md" ] || pre_error "The bundle lacks memory/MANIFEST.md."
[ -f "$BUNDLE_DIR/workspace-seed/MANIFEST.md" ] || pre_error "The bundle lacks workspace-seed/MANIFEST.md."
# Replacing a skill deletes its old copy first, so the run must never be able to delete its own
# source. Refuse when the bundle sits anywhere inside the skills directory, such as a checkout cloned
# under ~/.claude/skills, and when any skill directory the run would replace or retire is, or
# contains, the bundle or that skill's own source. path_within compares resolved paths and every
# ancestor with -ef, so a junction reported under another mount is caught as well. The same check
# also runs at each deletion, so a name missed here is still refused there.
if [ -d "$SKILLS_DST" ] && path_within "$BUNDLE_DIR" "$SKILLS_DST"; then
  pre_error "The bundle $BUNDLE_DIR is inside $SKILLS_DST. Move the checkout out of the skills directory first."
fi
for n in ${BUNDLE_SKILLS[@]+"${BUNDLE_SKILLS[@]}"} "${RETIRED_SKILLS[@]}"; do
  if deletes_bundle "$n"; then
    pre_error "$SKILLS_DST/$n is, or contains, the bundle or its own source. Installing would delete the source."
  fi
done
if [ "$(claude_md_status malformed)" != "0" ]; then
  pre_error "$CLAUDE_MD has a managed-block start line with no end line of its own. Fix it by hand."
fi
if [ "$pre_fail" -eq 1 ]; then
  echo
  echo "Install stopped before changing anything. Nothing was changed."
  exit 1
fi
echo "      ok  bundle complete, ${#BUNDLE_SKILLS[@]} skills, release $SYSTEM_VERSION"

ADDED=()
UPDATED=()
RETIRED_DONE=()
CLAIMED=()
KEPT_OWNER=0
fail=0

# Fixed layout, one value per line, so receipt_field and receipt_list can read it back
write_list() {
  local key="$1" last="$2" i=0 total v
  shift 2
  total=$#
  echo "  \"$key\": ["
  for v in "$@"; do
    i=$((i+1))
    if [ "$i" -lt "$total" ]; then echo "    \"$(json_escape "$v")\","; else echo "    \"$(json_escape "$v")\""; fi
  done
  if [ "$last" = "last" ]; then echo "  ]"; else echo "  ],"; fi
}

# write_receipt records what is actually installed. It runs as soon as skills are copied and again
# after every later step, so a run that fails partway still leaves every installed skill claimed.
write_receipt() {
  mkdir -p "$(dirname "$RECEIPT")" || return 1
  {
    echo "{"
    echo "  \"system\": \"parvis\","
    echo "  \"release\": \"$(json_escape "${RECEIPT_RELEASE:-$SYSTEM_VERSION}")\","
    echo "  \"installed_at\": \"$(date -u +%Y-%m-%dT%H:%M:%SZ)\","
    echo "  \"marker_version\": \"$(json_escape "$SYSTEM_VERSION")\","
    echo "  \"base\": \"$(json_escape "$(dirname "$MEM_DST")")\","
    echo "  \"memory_home\": \"$(json_escape "$MEM_DST")\","
    echo "  \"workspace_home\": \"$(json_escape "$WS_DST")\","
    write_list skills last ${CLAIMED[@]+"${CLAIMED[@]}"}
    echo "}"
  } > "$RECEIPT.tmp" && mv -f "$RECEIPT.tmp" "$RECEIPT"
}

save_receipt() {
  if ! write_receipt; then
    echo "      ERROR. Could not write the install receipt $RECEIPT"
    fail=1
  fi
  # The pointer is refreshed with the receipt, so the two can never name different bases
  if ! write_pointer; then
    echo "      WARNING. Could not write $(display_path "$POINTER"), so an uninstall would forget the base."
  fi
}

# ---- 0.5 Relocate the data homes (only with --relocate) ----------------------
# Every check runs before anything moves. Each home is then moved with mv, a rename on one volume,
# which carries its .git and every nested confidential repository with it. After the move each
# repository must answer with the same HEAD as before. Any failure after the first move puts back
# what was moved, and the receipt and the managed block are rewritten only once the move is proven.
RELOCATED=0
if [ "$RELOCATE" -eq 1 ]; then
  echo "[0.5] Relocating the data homes to $PARVIS_BASE"
  if [ -z "$RELOC_FROM_MEM" ]; then
    echo "      The receipt already records $MEM_DST and $WS_DST, so nothing needs to move."
  else
    rel_fail=0
    rel_error() { echo "      REFUSED. $*"; rel_fail=1; }
    RELOC_SRC=()
    RELOC_DST=()
    RELOC_HEADS=()
    for pair in "$RELOC_FROM_MEM|$MEM_DST" "$RELOC_FROM_WS|$WS_DST"; do
      src="${pair%%|*}"
      dst="${pair#*|}"
      if [ "$src" = "$dst" ] || { [ -e "$src" ] && [ -e "$dst" ] && [ "$src" -ef "$dst" ]; }; then
        echo "      $src is already in place."
        continue
      fi
      RELOC_SRC+=("$src")
      RELOC_DST+=("$dst")
      RELOC_HEADS+=("")
      if [ -L "$src" ]; then
        rel_error "$src is a link. Move the real directory by hand."
        continue
      fi
      if [ ! -d "$src" ]; then
        rel_error "$src does not exist, so there is nothing to move."
        continue
      fi
      if ! is_own_repo "$src"; then
        rel_error "$src is not a git repository of its own."
        continue
      fi
      repo_clean "$src" || rel_error "$src has uncommitted changes (git status is not clean). Commit them first."
      # Every repository in the home, its own first, recorded as path|HEAD, one per line
      heads=".|$(head_of "$src")"
      while IFS= read -r r; do
        [ -n "$r" ] || continue
        if ! is_own_repo "$src/$r"; then
          rel_error "$src/$r holds a .git that git does not read as a repository."
        elif ! repo_clean "$src/$r"; then
          rel_error "The nested repository $src/$r has uncommitted changes. Commit them first."
        fi
        heads="$heads
$r|$(head_of "$src/$r")"
      done < <(nested_repos "$src")
      RELOC_HEADS[${#RELOC_HEADS[@]}-1]="$heads"
      if [ -L "$dst" ]; then
        rel_error "The destination $dst is a link."
      elif [ -e "$dst" ]; then
        if [ ! -d "$dst" ]; then
          rel_error "The destination $dst exists and is not a directory."
        elif [ -n "$(ls -A "$dst" 2>/dev/null)" ]; then
          rel_error "The destination $dst exists and is not empty."
        fi
      fi
      if path_within "$dst" "$BUNDLE_DIR"; then
        rel_error "The destination $dst is inside the bundle $BUNDLE_DIR."
      fi
      for h in "$RELOC_FROM_MEM" "$RELOC_FROM_WS"; do
        if path_within "$dst" "$h"; then rel_error "The destination $dst is inside the home $h."; fi
      done
      anc="$(existing_ancestor "$dst")"
      top="$(git -C "$anc" rev-parse --show-toplevel 2>/dev/null || true)"
      [ -z "$top" ] || rel_error "The destination $dst is inside the git working tree $top."
      vs="$(volume_of "$src")"
      vd="$(volume_of "$dst")"
      if [ -z "$vs" ] || [ -z "$vd" ]; then
        rel_error "Cannot tell whether $src and $dst are on the same volume, so the move might copy."
      elif [ "$vs" != "$vd" ]; then
        rel_error "$src and $dst are on different volumes, so the move would be a copy, not a rename."
      fi
      # Where the platform offers lsof, a file held open inside the home refuses the move. Windows has
      # no such tool, and there a failed rename is the signal, handled at the move itself.
      if command -v lsof >/dev/null 2>&1 && [ -n "$(lsof +D "$src" 2>/dev/null | tail -n +2)" ]; then
        rel_error "A process holds a file open inside $src. Close it first."
      fi
    done
    # The outer memory repository must already ignore the confidential sections
    if in_list "$RELOC_FROM_MEM" ${RELOC_SRC[@]+"${RELOC_SRC[@]}"} && is_own_repo "$RELOC_FROM_MEM"; then
      for s in "${CONFIDENTIAL[@]}"; do
        [ -e "$RELOC_FROM_MEM/sections/$s" ] || continue
        git -C "$RELOC_FROM_MEM" check-ignore -q "sections/$s/" || \
          rel_error "The memory home does not ignore sections/$s. Run bash install.sh once without --relocate first."
      done
    fi
    # The receipt and the managed block are rewritten after the move, so both must be writable now
    if [ -e "$CLAUDE_MD" ]; then
      t="$(resolve_link "$CLAUDE_MD")" || t="$CLAUDE_MD"
      [ -w "$t" ] || rel_error "$CLAUDE_MD is read-only, so its managed block could not name the new homes."
    fi
    [ -w "$(dirname "$RECEIPT")" ] || rel_error "The receipt directory $(dirname "$RECEIPT") is not writable."
    if [ "$rel_fail" -eq 1 ]; then
      echo
      echo "Relocation stopped before moving anything. Nothing was changed."
      exit 1
    fi
    echo "      ok  preflight, the homes and every nested repository are clean and can move"

    MOVED=()
    EMPTIED=()
    CREATED=()
    RECEIPT_BAK=""
    BLOCK_REWRITTEN=0
    # move_back puts every moved home back where it was, newest first, and restores any empty
    # destination directory that was removed so mv could take its name.
    move_back() {
      local i k
      i=$((${#MOVED[@]} - 1))
      while [ "$i" -ge 0 ]; do
        k="${MOVED[$i]}"
        if mv "${RELOC_DST[$k]}" "${RELOC_SRC[$k]}"; then
          echo "      moved back  ${RELOC_DST[$k]}  to  ${RELOC_SRC[$k]}"
        else
          echo "      ERROR. Could not move ${RELOC_DST[$k]} back. It is still at the new path."
        fi
        i=$((i - 1))
      done
      for k in ${EMPTIED[@]+"${EMPTIED[@]}"}; do mkdir -p "$k" 2>/dev/null || true; done
      # A base directory this run created is removed again, and only while it is empty
      for k in ${CREATED[@]+"${CREATED[@]}"}; do rmdir "$k" 2>/dev/null && echo "      removed the empty $k"; done
      MOVED=()
      CREATED=()
    }
    # relocation_failed MESSAGE reports, puts the homes, the receipt and the block back, and stops
    relocation_failed() {
      echo "      ERROR. $*"
      move_back
      MEM_DST="$RELOC_FROM_MEM"
      WS_DST="$RELOC_FROM_WS"
      if [ -n "$RECEIPT_BAK" ] && [ -f "$RECEIPT_BAK" ]; then
        mv -f "$RECEIPT_BAK" "$RECEIPT" || echo "      ERROR. Could not restore the receipt from $RECEIPT_BAK."
      fi
      if [ "$BLOCK_REWRITTEN" -eq 1 ]; then
        rewrite_claude_md 1 || echo "      ERROR. The managed block in $CLAUDE_MD may still name the new homes."
      fi
      echo
      echo "Relocation FAILED and was undone as reported above. The homes are at"
      for h in "$MEM_DST" "$WS_DST"; do
        if [ -d "$h" ]; then echo "  $h"; else echo "  $h  (MISSING, see the errors above)"; fi
      done
      exit 1
    }
    k=0
    while [ "$k" -lt "${#RELOC_SRC[@]}" ]; do
      src="${RELOC_SRC[$k]}"
      dst="${RELOC_DST[$k]}"
      parent="$(dirname "$dst")"
      if [ ! -d "$parent" ]; then
        CREATED+=("$parent")
        mkdir -p "$parent" || relocation_failed "Could not create $parent."
        echo "      Created the base directory $parent."
      fi
      # mv into an existing directory would put the home inside it, so an empty one is removed first
      if [ -d "$dst" ]; then
        rmdir "$dst" || relocation_failed "Could not remove the empty directory $dst to take its place."
        EMPTIED+=("$dst")
      fi
      if ! mv "$src" "$dst"; then
        if [ -e "$dst" ] && [ -e "$src" ]; then
          echo "      ERROR. The move left both $src and $dst in place. $dst is not touched further,"
          echo "      compare the two by hand and remove the incomplete one."
        fi
        relocation_failed "Could not move $src to $dst. On Windows this usually means an editor, terminal or sync client holds a file open inside it. Close it and run again."
      fi
      MOVED+=("$k")
      if [ -e "$src" ] || [ ! -d "$dst" ]; then
        relocation_failed "After the move $src still exists or $dst is missing."
      fi
      echo "      moved  $src  to  $dst"
      k=$((k + 1))
    done

    # Each moved home and every nested repository must answer with the HEAD it had before
    k=0
    while [ "$k" -lt "${#RELOC_SRC[@]}" ]; do
      dst="${RELOC_DST[$k]}"
      while IFS= read -r line; do
        [ -n "$line" ] || continue
        r="${line%%|*}"
        want="${line#*|}"
        if [ "$r" = "." ]; then p="$dst"; else p="$dst/$r"; fi
        is_own_repo "$p" || relocation_failed "$p is no longer its own git repository after the move."
        got="$(head_of "$p")"
        [ "$got" = "$want" ] || relocation_failed "$p has HEAD $got after the move, $want before."
        echo "      ok  $p at $got"
      done <<< "${RELOC_HEADS[$k]}"
      k=$((k + 1))
    done
    if [ -d "$MEM_DST" ]; then
      for s in "${CONFIDENTIAL[@]}"; do
        [ -e "$MEM_DST/sections/$s" ] || continue
        git -C "$MEM_DST" check-ignore -q "sections/$s/" || \
          relocation_failed "The moved memory home no longer ignores sections/$s."
      done
      echo "      ok  the memory home still ignores its confidential sections"
    fi

    # Record the new homes. The receipt keeps its previous release and skills until step 1 updates
    # them. A failure here moves the homes back and restores both files.
    RECEIPT_BAK="$RECEIPT.parvis-relocate.$$"
    cp -p "$RECEIPT" "$RECEIPT_BAK" || relocation_failed "Could not back up the receipt before rewriting it."
    BLOCK_REWRITTEN=1
    rc=0
    rewrite_claude_md 1 || rc=$?
    if [ "$rc" -ne 0 ] || [ "$(claude_md_status blocks)" != "1" ] || \
       [ "$(block_scan body "$CLAUDE_MD" || true)" != "$(print_block)" ]; then
      relocation_failed "Could not rewrite the managed block in $CLAUDE_MD for the new homes."
    fi
    RECEIPT_RELEASE="$(receipt_field release)"
    CLAIMED=(${PREV_ROSTER[@]+"${PREV_ROSTER[@]}"})
    write_receipt || relocation_failed "Could not write the install receipt $RECEIPT."
    rm -f "$RECEIPT_BAK"
    RECEIPT_BAK=""
    RECEIPT_RELEASE=""
    CLAIMED=()
    RELOCATED=1
    echo "      ok  the receipt and the managed block now name the new homes"
    echo
    echo "      Memory     $RELOC_FROM_MEM"
    echo "             ->  $MEM_DST"
    echo "      Workspace  $RELOC_FROM_WS"
    echo "             ->  $WS_DST"
    echo "      Reopen any editor or terminal that still points at the old paths."
  fi
  echo
fi

# ---- 1. Skills -------------------------------------------------------------
echo "[1/5] Installing skills to $SKILLS_DST"
mkdir -p "$SKILLS_DST"
install_fail=0
for name in ${BUNDLE_SKILLS[@]+"${BUNDLE_SKILLS[@]}"}; do
  dst="$SKILLS_DST/$name"
  # Checked at the deletion itself, not only in preflight. A directory that is the bundle, or a data
  # home, is never replaced and never claimed, so a later uninstall will not remove it either.
  skip=""
  if deletes_bundle "$name"; then
    skip="it is, or contains, the bundle this script runs from"
  else
    for h in "$MEM_DST" "$WS_DST"; do
      if [ -n "$h" ] && [ -e "$dst" ] && [ -e "$h" ] && \
         { [ "$dst" -ef "$h" ] || [ "$(real_path "$dst")" = "$(real_path "$h")" ]; }; then
        skip="it is the data home $h"
        break
      fi
    done
  fi
  if [ -n "$skip" ]; then
    echo "      ERROR. Not replacing $name, $skip."
    install_fail=1
    continue
  fi
  # The owner skill is copied only while the installed one is missing or still the untouched
  # template. A filled-in copy holds the user's own background and is kept as it is.
  if [ "$name" = "$OWNER_SKILL" ] && [ -f "$dst/SKILL.md" ] && ! is_template_skill "$dst/SKILL.md"; then
    CLAIMED+=("$name")
    KEPT_OWNER=1
    echo "      Kept the personalized owner skill at $(display_path "$dst"), not overwritten."
    continue
  fi
  # Claimed before the copy, so even a half-copied directory belongs to the receipt
  CLAIMED+=("$name")
  if [ -L "$dst" ] || [ -e "$dst" ]; then UPDATED+=("$name"); else ADDED+=("$name"); fi
  rm -rf "${SKILLS_DST:?}/$name" || true
  if [ -L "$dst" ] || [ -e "$dst" ]; then
    echo "      ERROR. Could not remove the old copy of $name."
    install_fail=1
    continue
  fi
  if ! cp -R "$BUNDLE_DIR/skills/$name" "$dst"; then
    echo "      ERROR. Could not copy $name."
    install_fail=1
  fi
done
for n in "${ROSTER[@]}"; do
  [ -f "$SKILLS_DST/$n/SKILL.md" ] || { echo "      ERROR. Roster skill $n is not installed."; install_fail=1; }
done
# Previously claimed skills stay claimed until they are actually gone
for n in ${PREV_ROSTER[@]+"${PREV_ROSTER[@]}"}; do
  in_list "$n" ${CLAIMED[@]+"${CLAIMED[@]}"} && continue
  valid_skill_name "$n" && { [ -L "$SKILLS_DST/$n" ] || [ -d "$SKILLS_DST/$n" ]; } && CLAIMED+=("$n")
done
save_receipt
echo "      ${#BUNDLE_SKILLS[@]} skills installed (${#ADDED[@]} added, ${#UPDATED[@]} updated, $KEPT_OWNER kept)."
if [ "$install_fail" -eq 1 ]; then
  echo
  echo "Install STOPPED. Skills could not be installed, so nothing was retired and neither"
  echo "CLAUDE.md nor the data homes were touched. The receipt claims what was copied. Fix the"
  echo "errors above and re-run (safe to re-run)."
  exit 1
fi

# Adopt a filled-in identity skill from an earlier install, before retirement removes it. It runs
# only while the owner skill is still the template, and only for an old skill without a template
# marker that the previous receipt claims or that reads like a profile. The copy takes the owner
# skill's name, and retirement below then backs the old skill up and removes it. A second run finds
# the owner skill filled in, or the old skill gone, and does nothing.
ADOPTED=0
ADOPT_FAILED=0
OLD_F="$SKILLS_DST/$OLD_OWNER_SKILL/SKILL.md"
OWN_F="$SKILLS_DST/$OWNER_SKILL/SKILL.md"

# write_owner_from FILE writes FILE into the owner skill, with the name line inside the leading
# frontmatter set to the owner skill's name and a CR at its end kept. Nothing else changes. Used by
# the adoption below and by the restore from a profile backup. Returns 1 when the result would
# still read as the untouched template, and then the owner skill is left exactly as it was.
write_owner_from() {
  local src="$1" tmp="$OWN_F.parvis-tmp"
  if mkdir -p "$(dirname "$OWN_F")" && \
     LC_ALL=C awk -v BINMODE=3 -v name="$OWNER_SKILL" '
       { t = $0; cr = ""; if (t ~ /\r$/) { cr = "\r"; sub(/\r$/, "", t) } }
       NR == 1 && t == "---" { fm = 1; print; next }
       fm == 1 && t == "---" { fm = 2 }
       fm == 1 && !done && t ~ /^name:/ { print "name: " name cr; done = 1; next }
       { print }
     ' "$src" > "$tmp" && ! is_template_skill "$tmp" && mv -f "$tmp" "$OWN_F"; then
    return 0
  fi
  rm -f "$tmp"
  return 1
}
if valid_skill_name "$OLD_OWNER_SKILL" && ! is_synced_path "$SKILLS_DST/$OLD_OWNER_SKILL" && \
   [ ! -L "$SKILLS_DST/$OLD_OWNER_SKILL" ] && [ -f "$OLD_F" ] && ! is_template_skill "$OLD_F" && \
   { in_list "$OLD_OWNER_SKILL" ${PREV_ROSTER[@]+"${PREV_ROSTER[@]}"} || looks_like_profile "$OLD_OWNER_SKILL"; } && \
   { [ ! -f "$OWN_F" ] || is_template_skill "$OWN_F"; }; then
  if write_owner_from "$OLD_F"; then
    ADOPTED=1
    echo "      Adopted your filled-in profile into $OWNER_SKILL, from $(display_path "$OLD_F")."
  else
    ADOPT_FAILED=1
    fail=1
    echo "      ERROR. Could not adopt $(display_path "$OLD_F") into $OWNER_SKILL, so $OLD_OWNER_SKILL is kept."
  fi
fi

# Retire what the previous roster had and this release dropped, plus the hardcoded list.
# A name that is in this release is never retired, whatever list it appears on.
RETIRE_CANDIDATES=()
for n in ${PREV_ROSTER[@]+"${PREV_ROSTER[@]}"} "${RETIRED_SKILLS[@]}"; do
  in_list "$n" ${BUNDLE_SKILLS[@]+"${BUNDLE_SKILLS[@]}"} && continue
  in_list "$n" "${ROSTER[@]}" && continue
  in_list "$n" ${RETIRE_CANDIDATES[@]+"${RETIRE_CANDIDATES[@]}"} && continue
  RETIRE_CANDIDATES+=("$n")
done
for n in ${RETIRE_CANDIDATES[@]+"${RETIRE_CANDIDATES[@]}"}; do
  rc=0
  # An old identity skill that could not be adopted stays, so its profile is not lost
  if [ "$n" = "$OLD_OWNER_SKILL" ] && [ "$ADOPT_FAILED" -eq 1 ]; then
    echo "      kept     $n, its profile was not adopted"
    continue
  fi
  # A skill the previous receipt names that holds a filled-in identity profile is backed up before
  # it is retired, so an older identity skill never takes the user's background with it. The old
  # identity skill counts whenever it lacks the template marker. When the backup fails the skill is
  # kept, and verification reports it.
  if in_list "$n" ${PREV_ROSTER[@]+"${PREV_ROSTER[@]}"} && valid_skill_name "$n" && \
     ! is_synced_path "$SKILLS_DST/$n" && \
     { looks_like_profile "$n" || { [ "$n" = "$OLD_OWNER_SKILL" ] && [ -f "$SKILLS_DST/$n/SKILL.md" ] && \
         ! is_template_skill "$SKILLS_DST/$n/SKILL.md"; }; }; then
    backup_profile "$n" || { fail=1; continue; }
  fi
  remove_skill_dir "$n" || rc=$?
  case "$rc" in
    0) echo "      retired  $n"; RETIRED_DONE+=("$n") ;;
    3) fail=1 ;;
  esac
done
echo "      ${#RETIRED_DONE[@]} retired skills removed."
# A previously claimed skill that could not be retired stays claimed
KEEP=()
for n in ${CLAIMED[@]+"${CLAIMED[@]}"}; do
  if in_list "$n" ${BUNDLE_SKILLS[@]+"${BUNDLE_SKILLS[@]}"} || [ -L "$SKILLS_DST/$n" ] || [ -d "$SKILLS_DST/$n" ]; then
    KEEP+=("$n")
  fi
done
CLAIMED=(${KEEP[@]+"${KEEP[@]}"})
save_receipt

# Offer back a profile an earlier uninstall saved. Uninstall copies a filled-in identity profile to
# ~/.claude/parvis-retired-profile-backup*.md, and nothing ever read it again, so a reinstall on a
# machine whose bundle ships the template left the owner skill blank. This runs only while the
# installed owner skill is still the untouched template, so a filled-in one is never overwritten,
# and it says nothing at all in that case. The newest backup is the one offered.
RESTORED=0
RESTORE_SRC=""
if [ -f "$OWN_F" ] && is_template_skill "$OWN_F" && [ "$ADOPTED" -eq 0 ]; then
  RESTORE_SRC="$(newest_profile_backup)"
  [ -n "$RESTORE_SRC" ] && [ -f "$RESTORE_SRC" ] && ! is_template_skill "$RESTORE_SRC" || RESTORE_SRC=""
fi
if [ -n "$RESTORE_SRC" ]; then
  stamp="$(profile_backup_stamp "$RESTORE_SRC")"
  echo "      The owner skill is still the unfilled template, and a profile backup from $stamp is here"
  echo "        $(display_path "$RESTORE_SRC")"
  if [ -t 0 ]; then
    printf '      Restore it into %s? Type yes to restore, anything else keeps the template: ' "$OWNER_SKILL"
    answer=""
    read -r answer || true
    if [ "$answer" = "yes" ]; then
      if write_owner_from "$RESTORE_SRC"; then
        RESTORED=1
        echo "      Restored your profile into $OWNER_SKILL from the backup of $stamp."
      else
        echo "      ERROR. Could not restore that backup, so $OWNER_SKILL is still the template."
        fail=1
      fi
    else
      echo "      Kept the template. The backup is left where it is."
    fi
  else
    # No terminal, so nothing is asked and nothing hangs. The one command is printed instead.
    echo "      This run is not interactive, so nothing was restored. To restore it yourself, run"
    echo "        cp \"$RESTORE_SRC\" \"$OWN_F\""
    echo "      then check that its name line reads name: $OWNER_SKILL."
  fi
fi

# ---- 1.5 Always-on instructions (guaranteed context via user CLAUDE.md) ----
echo "[1.5] User instructions: ~/.claude/CLAUDE.md"
BLOCK_STATUS="untouched"
[ "$RELOCATED" -eq 1 ] && BLOCK_STATUS="rewritten for the relocated homes"
nblocks="$(claude_md_status blocks)"
if [ "$nblocks" = "1" ] && [ "$(block_scan body "$CLAUDE_MD" || true)" = "$(print_block)" ]; then
  echo "      Managed block already present at v$SYSTEM_VERSION, untouched."
else
  rc=0
  rewrite_claude_md 1 || rc=$?
  # Success is judged by reading the file back, never by the rewrite's own status alone
  if [ "$rc" -eq 0 ] && { [ "$(claude_md_status blocks)" != "1" ] || \
       [ "$(block_scan body "$CLAUDE_MD" || true)" != "$(print_block)" ]; }; then
    rc=4
  fi
  if [ "$rc" -ne 0 ]; then
    if [ "$rc" -eq 3 ]; then
      echo "      ERROR. $CLAUDE_MD is read-only. It was left as it was. Make it writable and re-run."
    elif [ "$rc" -eq 4 ]; then
      echo "      ERROR. $CLAUDE_MD was rewritten but does not read back with exactly one current block."
    else
      echo "      ERROR. Could not write $CLAUDE_MD. It was left as it was."
    fi
    BLOCK_STATUS="not written"
    fail=1
  else
    if [ "$nblocks" != "0" ]; then
      echo "      Out-of-date managed block found, replaced with v$SYSTEM_VERSION."
      BLOCK_STATUS="replaced with v$SYSTEM_VERSION"
    else
      BLOCK_STATUS="appended at v$SYSTEM_VERSION"
    fi
    echo "      Managed block written, identity and prose hygiene now guaranteed in every Claude Code session."
  fi
fi

# ---- 2. Memory (never overwrite) ------------------------------------------
echo "[2/5] Memory home: $MEM_DST"
# A home missing at the chosen base is created there and seeded, and the run names the full path
for b in "$(dirname "$MEM_DST")" "$(dirname "$WS_DST")"; do
  [ -d "$b" ] && continue
  mkdir -p "$b"
  echo "      Created the base directory $b."
done
if [ -d "$MEM_DST" ]; then
  echo "      Exists, leaving untouched (updates to memory are the system's job, not the installer's)."
else
  cp -R "$BUNDLE_DIR/memory" "$MEM_DST"
  nsec="$(find "$BUNDLE_DIR/memory/sections" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
  echo "      Created $MEM_DST, seeded from the bundle ($nsec sections plus manifest)."
fi

# A release can add a memory section. An existing home gets each section it lacks, copied whole from
# the seed, with its manifest row inserted after the last row of the routing table. Nothing already
# present is changed. A confidential new section is left for step 4, which makes it a local-only
# repository, so only the manifest and non-confidential sections are committed here.
ADDED_SECTIONS=()
if [ -d "$MEM_DST/sections" ] && [ -f "$MEM_DST/MANIFEST.md" ]; then
  for sd in "$BUNDLE_DIR"/memory/sections/*/ ; do
    s="$(basename "$sd")"
    [ -e "$MEM_DST/sections/$s" ] && continue
    if cp -R "$BUNDLE_DIR/memory/sections/$s" "$MEM_DST/sections/$s"; then
      ADDED_SECTIONS+=("$s")
      echo "      Added new section $s from the $SYSTEM_VERSION seed."
    else
      echo "      ERROR. Could not add new section $s."
      fail=1
    fi
  done
  for s in ${ADDED_SECTIONS[@]+"${ADDED_SECTIONS[@]}"}; do
    tr -d '\r' < "$MEM_DST/MANIFEST.md" | grep -q "^| $s |" && continue
    row="$(tr -d '\r' < "$BUNDLE_DIR/memory/MANIFEST.md" | grep "^| $s |" | head -n 1 || true)"
    [ -n "$row" ] || continue
    tmp="$MEM_DST/MANIFEST.md.parvis-tmp"
    if awk -v row="$row" '
        { lines[NR] = $0; t = $0; sub(/\r$/, "", t); if (t ~ /^\| /) last = NR }
        END { for (i = 1; i <= NR; i++) {
                print lines[i]
                if (i == last) { cr = (lines[i] ~ /\r$/) ? "\r" : ""; print row cr } } }
      ' "$MEM_DST/MANIFEST.md" > "$tmp" && mv "$tmp" "$MEM_DST/MANIFEST.md"; then
      echo "      Registered $s in the memory manifest."
    else
      rm -f "$tmp"
      echo "      ERROR. Could not register $s in the manifest. Add its row by hand from the bundle."
      fail=1
    fi
  done
  if [ "${#ADDED_SECTIONS[@]}" -gt 0 ] && is_own_repo "$MEM_DST" && has_commit "$MEM_DST"; then
    paths=(MANIFEST.md)
    for s in "${ADDED_SECTIONS[@]}"; do in_list "$s" "${CONFIDENTIAL[@]}" || paths+=("sections/$s"); done
    if git -C "$MEM_DST" add -- "${paths[@]}" && \
       git_commit "$MEM_DST" -qm "add sections from the $SYSTEM_VERSION seed: ${ADDED_SECTIONS[*]}" -- "${paths[@]}"; then
      echo "      Committed the new sections to the memory home."
    else
      echo "      WARNING. The new sections are in place but uncommitted. Commit them in $MEM_DST."
    fi
  fi
fi

# ---- 3. Workspace (never overwrite) ---------------------------------------
echo "[3/5] Workspace home: $WS_DST"
if [ -d "$WS_DST" ]; then
  echo "      Exists, leaving its files untouched (working documents are yours, not the installer's)."
else
  cp -R "$BUNDLE_DIR/workspace-seed" "$WS_DST"
  echo "      Created $WS_DST, seeded from the bundle."
fi

# A release can add a workspace folder or a seed file, the way it can add a memory section, and
# until now that addition never reached an existing home. Each seed path the home lacks is created
# or copied, additive only. Nothing already there is rewritten, whatever it now holds.
# ws_manifest_add REL names REL in the Folders line of the home's manifest, in the seed's own
# wording when the seed describes it. Returns 0 when the line was rewritten, 2 when it already
# names REL and nothing was touched, and 1 when the manifest could not be rewritten.
ws_manifest_add() {
  local rel="$1" man="$WS_DST/MANIFEST.md" frag tmp
  [ -f "$man" ] || return 1
  tr -d '\r' < "$man" | sed -n 's/^Folders: //p' | head -n 1 | grep -qF "$rel/" && return 2
  frag="$(tr -d '\r' < "$BUNDLE_DIR/workspace-seed/MANIFEST.md" | sed -n 's/^Folders: //p' | head -n 1 \
    | LC_ALL=C awk -v r="$rel/" -F ' · ' '{ for (i = 1; i <= NF; i++) if (index($i, r) == 1) { print $i; exit } }')"
  [ -n "$frag" ] || frag="$rel/"
  tmp="$man.parvis-tmp"
  if LC_ALL=C awk -v BINMODE=3 -v frag="$frag" '
      { t = $0; cr = ""; if (t ~ /\r$/) { cr = "\r"; sub(/\r$/, "", t) } }
      !done && t ~ /^Folders: / { print t " · " frag cr; done = 1; next }
      { print }
      END { exit (done ? 0 : 1) }
    ' "$man" > "$tmp" && mv -f "$tmp" "$man"; then
    return 0
  fi
  rm -f "$tmp"
  return 1
}
ADDED_WS=()
WS_MAN_CHANGED=0
if [ -d "$WS_DST" ]; then
  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    if [ -e "$WS_DST/$rel" ] || [ -L "$WS_DST/$rel" ]; then continue; fi
    if [ -d "$BUNDLE_DIR/workspace-seed/$rel" ]; then
      if mkdir -p "$WS_DST/$rel"; then
        ADDED_WS+=("$rel")
        echo "      Added the workspace folder $rel from the $SYSTEM_VERSION seed."
      else
        echo "      ERROR. Could not add the workspace folder $rel."
        fail=1
      fi
    elif cp "$BUNDLE_DIR/workspace-seed/$rel" "$WS_DST/$rel"; then
      ADDED_WS+=("$rel")
      echo "      Added the workspace file $rel from the $SYSTEM_VERSION seed."
    else
      echo "      ERROR. Could not add the workspace file $rel."
      fail=1
    fi
  done < <(cd "$BUNDLE_DIR/workspace-seed" && find . -mindepth 1 | sed 's|^\./||' | LC_ALL=C sort)
fi
for rel in ${ADDED_WS[@]+"${ADDED_WS[@]}"}; do
  [ -d "$WS_DST/$rel" ] || continue
  rc=0
  ws_manifest_add "$rel" || rc=$?
  case "$rc" in
    0) WS_MAN_CHANGED=1; echo "      Registered $rel in the workspace manifest." ;;
    2) ;;
    *) echo "      ERROR. Could not name $rel in the Folders line of $WS_DST/MANIFEST.md. Add it by hand."
       fail=1 ;;
  esac
done
if [ "${#ADDED_WS[@]}" -gt 0 ] && is_own_repo "$WS_DST" && has_commit "$WS_DST"; then
  paths=(${ADDED_WS[@]+"${ADDED_WS[@]}"})
  [ "$WS_MAN_CHANGED" -eq 1 ] && paths+=(MANIFEST.md)
  if git -C "$WS_DST" add -- "${paths[@]}" && \
     git_commit "$WS_DST" -qm "add workspace seed paths from the $SYSTEM_VERSION seed: ${ADDED_WS[*]}" -- "${paths[@]}"; then
    echo "      Committed the new workspace paths."
  else
    echo "      WARNING. The new workspace paths are in place but uncommitted. Commit them in $WS_DST."
  fi
fi
# Repository state is asked of git itself, never guessed from a .git directory. A home that is
# not its own repository is made one, and a repository with no commit gets its seed commit, so a
# seed commit that failed on an earlier run is repaired here.
if ! is_own_repo "$WS_DST"; then
  if git -C "$WS_DST" init -q; then echo "      Put under git."; else echo "      ERROR. git init failed."; fail=1; fi
fi
if is_own_repo "$WS_DST" && ! has_commit "$WS_DST"; then
  if git -C "$WS_DST" add -A && git_commit "$WS_DST" -qm "seed workspace (Parvis $SYSTEM_VERSION)"; then
    echo "      Seed commit made."
  else
    echo "      ERROR. The workspace seed commit failed. Re-run to retry it."
    fail=1
  fi
fi

# ---- 4. Git: outer repo + nested local-only repos for confidential sections
echo "[4/5] Version control"
CONF_IGNORE="$MEM_DST/.gitignore"
if ! is_own_repo "$MEM_DST"; then
  if git -C "$MEM_DST" init -q; then
    # Confidential sections become independent, machine-local repos.
    # The outer repo ignores them, so adding a remote later NEVER pushes them.
    ensure_final_newline "$CONF_IGNORE" 2>/dev/null || true
    {
      echo "# Confidential sections: independent local-only repos (see install-guide §0)"
      for s in "${CONFIDENTIAL[@]}"; do echo "sections/$s/"; done
    } >> "$CONF_IGNORE"
    echo "      Outer repo initialized, confidential sections excluded from it."
  else
    echo "      ERROR. git init failed for the memory home."
    fail=1
  fi
else
  echo "      Outer repo already present."
fi

# The outer repo must ignore every confidential section on EVERY run, not only when it is first
# created. An older, relocated or cloned memory home can lack these lines, and a remote added later
# would then carry people data off the machine. Appending an ignore line is idempotent and never
# removes anything. The comparison strips CR so a CRLF .gitignore does not collect duplicates, and
# the file is given a final newline first so the rule never glues onto the user's last line.
for s in "${CONFIDENTIAL[@]}"; do
  if ! tr -d '\r' < "$CONF_IGNORE" 2>/dev/null | grep -qxF "sections/$s/"; then
    ensure_final_newline "$CONF_IGNORE" 2>/dev/null || true
    echo "sections/$s/" >> "$CONF_IGNORE"
    echo "      Added the missing ignore line for confidential section $s."
    IGNORE_ADDED=1
  fi
done
# An ignore line added to a home that already has history is committed on its own, so the home is
# left clean. A home with no commit yet takes it in its seed commit below.
if [ "${IGNORE_ADDED:-0}" -eq 1 ] && is_own_repo "$MEM_DST" && has_commit "$MEM_DST"; then
  if git -C "$MEM_DST" add -- .gitignore &&      git_commit "$MEM_DST" -qm "ignore confidential sections (Parvis $SYSTEM_VERSION)" -- .gitignore; then
    echo "      Committed the updated ignore lines."
  else
    echo "      WARNING. The ignore lines are in place but uncommitted. Commit .gitignore in $MEM_DST."
  fi
fi
# The ignore lines are in place before any commit, so a first or repaired seed commit never takes
# a confidential section into the outer history.
if is_own_repo "$MEM_DST" && ! has_commit "$MEM_DST"; then
  if git -C "$MEM_DST" add -A && git_commit "$MEM_DST" -qm "seed memory (Parvis $SYSTEM_VERSION)"; then
    echo "      Seed commit made in the outer repo."
  else
    echo "      ERROR. The memory seed commit failed. Re-run to retry it."
    fail=1
  fi
fi
for s in "${CONFIDENTIAL[@]}"; do
  # An ignore rule cannot untrack what the outer repo already tracks. Warn and show the exact fix,
  # but never rewrite the user's history from the installer.
  if git -C "$MEM_DST" ls-files --error-unmatch "sections/$s" >/dev/null 2>&1; then
    echo "      WARNING. Confidential section $s is already TRACKED by the outer repo, so ignoring it"
    echo "      now does not remove it. Before adding any remote, untrack it with"
    echo "        git -C \"$MEM_DST\" rm -r --cached \"sections/$s\""
    echo "      and commit. This keeps the files on disk and only stops the outer repo carrying them."
  fi
done
for s in "${CONFIDENTIAL[@]}"; do
  sd="$MEM_DST/sections/$s"
  mkdir -p "$sd"
  if ! is_own_repo "$sd"; then
    git -C "$sd" init -q || { echo "      ERROR. git init failed for sections/$s."; fail=1; continue; }
  fi
  if ! has_commit "$sd"; then
    if git -C "$sd" add -A && git_commit "$sd" -qm "seed $s (local-only)" --allow-empty; then
      echo "      Local-only repo: sections/$s (never leaves this machine via the outer repo)."
    else
      echo "      ERROR. The seed commit for sections/$s failed. Re-run to retry it."
      fail=1
    fi
  fi
done

# Every home repo gets the LF .gitattributes, older homes included, so core.autocrlf=true stops
# warning on each register write. Only a missing file is written, and only that file is committed,
# so nothing else the user has staged or changed is touched.
for r in "$WS_DST" "$MEM_DST" "${CONFIDENTIAL[@]/#/$MEM_DST/sections/}"; do
  is_own_repo "$r" || continue
  [ -f "$r/.gitattributes" ] && continue
  if cp "$BUNDLE_DIR/memory/.gitattributes" "$r/.gitattributes" && git -C "$r" add .gitattributes &&      git_commit "$r" -qm "add LF .gitattributes (Parvis $SYSTEM_VERSION)" -- .gitattributes; then
    echo "      Added .gitattributes in $r."
  else
    echo "      WARNING. Could not add .gitattributes in $r. Copy it from the bundle by hand."
  fi
done

# ---- 4.5 Legacy infra data homes, detected and reported, never migrated ------
LEGACY_FOUND=()
while IFS= read -r h; do [ -n "$h" ] && LEGACY_FOUND+=("$h"); done < <(legacy_homes)
if [ "${#LEGACY_FOUND[@]}" -gt 0 ]; then
  echo "[4.5] Legacy infra data homes"
  for h in "${LEGACY_FOUND[@]}"; do echo "      Found  $h"; done
  echo "      Parvis does not migrate legacy infra homes, in this release or a later one. Each one"
  echo "      listed above was left completely untouched. Nothing was copied from it and nothing was"
  echo "      committed. Keep it where it is. The by-hand steps are the supported route, in"
  echo "      docs/install-guide.md, under upgrading from the infra-platform system."
fi

# ---- 5. Verify -------------------------------------------------------------
echo "[5/5] Verification"
for n in "${ROSTER[@]}"; do
  if [ -f "$SKILLS_DST/$n/SKILL.md" ]; then echo "      ok  $n"; else echo "      MISSING $n"; fail=1; fi
done
# Every retired name must be gone, not only the ones this run removed. The candidate list holds
# every hardcoded retired name and every dropped name from the receipt, minus this release.
for n in ${RETIRE_CANDIDATES[@]+"${RETIRE_CANDIDATES[@]}"}; do
  # A name that is not a plain skill name came from a tampered receipt. It was refused above
  # and is dropped from the receipt, and on a case-folding disk it would alias another directory.
  valid_skill_name "$n" || continue
  if [ -L "$SKILLS_DST/$n" ] || [ -d "$SKILLS_DST/$n" ]; then echo "      STILL PRESENT retired $n"; fail=1; fi
done
[ -f "$MEM_DST/MANIFEST.md" ] && echo "      ok  memory manifest" || { echo "      MISSING memory manifest"; fail=1; }
is_own_repo "$MEM_DST" && has_commit "$MEM_DST" && echo "      ok  memory git history" || { echo "      MISSING memory git"; fail=1; }
[ -f "$WS_DST/MANIFEST.md" ] && echo "      ok  workspace manifest" || { echo "      MISSING workspace manifest"; fail=1; }
is_own_repo "$WS_DST" && has_commit "$WS_DST" && echo "      ok  workspace git history" || { echo "      MISSING workspace git"; fail=1; }

save_receipt
[ "$fail" -eq 0 ] && echo "      ok  install receipt $RECEIPT"

# ---- Summary ---------------------------------------------------------------
join_names() { if [ "$#" -eq 0 ]; then echo "none"; else echo "$*"; fi; }
echo
echo "Summary"
echo "  Added    (${#ADDED[@]})  $(join_names ${ADDED[@]+"${ADDED[@]}"})"
echo "  Updated  (${#UPDATED[@]})  $(join_names ${UPDATED[@]+"${UPDATED[@]}"})"
echo "  Retired  (${#RETIRED_DONE[@]})  $(join_names ${RETIRED_DONE[@]+"${RETIRED_DONE[@]}"})"
if [ "$ADOPTED" -eq 1 ]; then
  echo "  Owner skill  filled in, adopted from the earlier $OLD_OWNER_SKILL skill"
elif [ "$RESTORED" -eq 1 ]; then
  echo "  Owner skill  filled in, restored from $(display_path "$RESTORE_SRC")"
elif [ -n "$RESTORE_SRC" ]; then
  echo "  Owner skill  still the unfilled template, and a saved profile backup is waiting, see above"
elif [ -f "$OWN_F" ] && ! is_template_skill "$OWN_F"; then
  echo "  Owner skill  filled in, personalized copy kept"
else
  echo "  Owner skill  still the unfilled template, fill it in during initialization step 3"
fi
if [ "$ADOPTED" -eq 1 ] && ! in_list "$OLD_OWNER_SKILL" ${PREV_ROSTER[@]+"${PREV_ROSTER[@]}"} &&    { [ -L "$SKILLS_DST/$OLD_OWNER_SKILL" ] || [ -d "$SKILLS_DST/$OLD_OWNER_SKILL" ]; }; then
  echo "  NOTE. No receipt claims $(display_path "$SKILLS_DST/$OLD_OWNER_SKILL"), so it was left in place."
  echo "        Its profile now lives in $OWNER_SKILL. Remove the old one by hand once you have checked it."
fi
if [ "$RELOCATED" -eq 1 ]; then
  echo "  Homes  relocated to the base $(dirname "$MEM_DST"), reopen anything that used the old paths"
else
  echo "  Homes  base $(dirname "$MEM_DST")"
fi
if [ "${#LEGACY_FOUND[@]}" -gt 0 ]; then
  echo "  Legacy infra homes found (${#LEGACY_FOUND[@]}), left untouched and not migrated"
fi
echo "  Managed block  $BLOCK_STATUS"

synced_note

echo
if [ "$fail" -eq 0 ]; then
  echo "Install complete (Parvis $SYSTEM_VERSION)."
  INIT_FILE="$MEM_DST/sections/system/init-status.md"
  INIT_STATE=""
  INIT_NEXT=""
  if [ -f "$INIT_FILE" ]; then
    INIT_STATE="$(tr -d '' < "$INIT_FILE" | sed -n 's/^Status: *//p' | head -n 1)"
    INIT_NEXT="$(tr -d '' < "$INIT_FILE" | sed -n 's/^Next step: *//p' | head -n 1)"
  fi
  echo
  if [ "$INIT_STATE" = "complete" ]; then
    echo "Initialization: complete. Nothing further to set up."
    echo "Next: restart Claude Code and type /parvis."
  elif [ -n "$INIT_STATE" ] && [ "$INIT_STATE" != "not started" ]; then
    echo "Initialization: in progress${INIT_NEXT:+, next step $INIT_NEXT}."
    echo "Next: restart Claude Code, type /parvis, then say \"continue initialization\"."
  else
    echo "Initialization: not started. The system is installed but knows nothing yet."
    echo "Next steps"
    echo "  1. Restart Claude Code and run /skills to confirm twenty skills."
    echo "  2. If an employer manages this machine, read install-guide section 0 before any real data."
    echo "  3. Type /parvis, then say \"run the shakedown\" (about 30 to 45 minutes, test data only)."
    echo "  4. Gather the seed pack listed in docs/initialization.md into $WS_DST/inbox/seed/"
    echo "  5. Say \"initialize my system\". It is resumable across sittings."
    echo "  With one machine only, it is both the rehearsal and the real thing, so work straight through."
  fi
  echo "Anytime, say \"help\" and the system explains itself."
else
  echo "Install finished WITH ERRORS above. Fix them and re-run (safe to re-run)."
  echo "The receipt still claims every skill that was installed, so --uninstall can remove them."
  exit 1
fi

#!/usr/bin/env bash
# package-skills.sh, maintainer tool. Builds one .skill bundle per skill for upload to claude.ai.
#
#   bash tools/package-skills.sh                    build every skill under skills/ into dist/
#   bash tools/package-skills.sh parvis-core        build only the named skills
#   bash tools/package-skills.sh --out DIR          write bundles somewhere other than dist/
#   bash tools/package-skills.sh --tool node        force one archiver (zip, powershell or node)
#
# A .skill file is a zip archive. Every entry sits under one top-level directory named for the
# skill, for example parvis-core/SKILL.md and parvis-core/references/methods.md, with forward-slash
# separators and no separate directory entries.
#
# Only files git tracks are packed, listed with git ls-files. A gitignored private note, an editor
# backup or an untracked draft sitting in a skill directory never reaches a bundle. Skill names are
# checked with the same valid_skill_name function install.sh uses, loaded from install.sh itself.
#
# Text files are packed with LF line endings whatever the checkout uses, so a bundle built on a
# Windows clone with core.autocrlf=true is byte-identical in content to one built on macOS or Linux.
# Binary files are packed untouched.
#
# Archiver fallback chain, first one present wins.
#   1. zip          the Info-ZIP binary, standard on macOS and most Linux installs.
#   2. powershell   System.IO.Compression.ZipFile with explicit forward-slash entry names. Never
#                   Compress-Archive, which writes backslash separators under Windows PowerShell 5.1
#                   and produces a bundle that is broken everywhere except Windows.
#   3. node         a small built-in zip writer using zlib, no npm packages.
# Under WSL, node comes before powershell, and powershell.exe is given Windows paths through
# wslpath. The WSL path is simulated, not tested on a WSL machine.
#
# Every bundle is verified before the script reports success. Its raw entry names are listed and
# checked for forward slashes and the single top-level directory, then it is extracted and compared
# byte for byte against the LF-normalized skill directory. A bundle that fails is deleted, and so is
# one whose archiver failed or was interrupted partway.
#
# Output goes to dist/, which .gitignore excludes along with *.skill. Built bundles are never
# committed. install.sh does not use this script and does not depend on anything it needs.

set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILLS_DIR="$REPO/skills"
OUT_DIR="$REPO/dist"
TOOL="${PACKAGE_SKILLS_TOOL:-}"
NAMES=()

die() { printf 'package-skills: %s\n' "$*" >&2; exit 1; }

while [ $# -gt 0 ]; do
  case "$1" in
    --out)  [ $# -ge 2 ] || die "--out needs a directory"; OUT_DIR="$2"; shift 2 ;;
    --tool) [ $# -ge 2 ] || die "--tool needs zip, powershell or node"; TOOL="$2"; shift 2 ;;
    -h|--help) sed -n '2,36p' "${BASH_SOURCE[0]}" | sed 's/^# \{0,1\}//'; exit 0 ;;
    -*) die "unknown option $1" ;;
    *)  NAMES+=("$1"); shift ;;
  esac
done

git -C "$REPO" rev-parse --show-toplevel >/dev/null 2>&1 || die "$REPO is not a git checkout, and only tracked files are packed"

# The installer's own name validator, loaded from install.sh so the two can never drift apart
VALIDATOR="$(sed -n '/^valid_skill_name() {$/,/^}$/p' "$REPO/install.sh" | tr -d '\r')"
[ -n "$VALIDATOR" ] || die "could not load valid_skill_name from install.sh"
eval "$VALIDATOR"
if ! valid_skill_name parvis-core || valid_skill_name Synced; then
  die "valid_skill_name loaded from install.sh does not behave as expected"
fi

IS_WSL=0
if [ -n "${WSL_DISTRO_NAME:-}" ] || grep -qi microsoft /proc/version 2>/dev/null; then IS_WSL=1; fi

# Convert a POSIX path to one a native Windows program understands. A no-op off Windows.
native_path() {
  if command -v cygpath >/dev/null 2>&1; then cygpath -m "$1"; else printf '%s\n' "$1"; fi
}

# powershell.exe under WSL is a Windows program reading Linux paths, so it gets wslpath's form
ps_path() {
  if [ "$IS_WSL" -eq 1 ] && command -v wslpath >/dev/null 2>&1; then wslpath -m "$1"; else native_path "$1"; fi
}

POWERSHELL=""
for ps in powershell.exe pwsh; do
  if command -v "$ps" >/dev/null 2>&1; then POWERSHELL="$ps"; break; fi
done

if [ -z "$TOOL" ]; then
  if command -v zip >/dev/null 2>&1; then TOOL=zip
  elif [ -n "$POWERSHELL" ] && [ "$IS_WSL" -eq 0 ]; then TOOL=powershell
  elif command -v node >/dev/null 2>&1; then TOOL=node
  elif [ -n "$POWERSHELL" ]; then TOOL=powershell
  else die "no archiver found. Install zip, or make PowerShell or node available."
  fi
fi
case "$TOOL" in
  zip)        command -v zip >/dev/null 2>&1 || die "zip was requested but is not installed" ;;
  powershell) [ -n "$POWERSHELL" ] || die "powershell was requested but is not installed" ;;
  node)       command -v node >/dev/null 2>&1 || die "node was requested but is not installed" ;;
  *)          die "unknown tool $TOOL, expected zip, powershell or node" ;;
esac

# The verifier needs something that can list raw entry names and extract. unzip reads names
# without rewriting separators, node reads the central directory directly, and PowerShell is last
# because .NET extraction on Windows silently treats a backslash as a separator.
VERIFIER=""
if command -v unzip >/dev/null 2>&1; then VERIFIER=unzip
elif command -v node >/dev/null 2>&1; then VERIFIER=node
elif [ -n "$POWERSHELL" ]; then VERIFIER=powershell
else die "nothing available to verify bundles with. Install unzip or node."
fi

is_tracked() { git -C "$REPO" ls-files --error-unmatch -- "$1" >/dev/null 2>&1; }

if [ ${#NAMES[@]} -eq 0 ]; then
  for d in "$SKILLS_DIR"/*/; do
    [ -d "$d" ] || continue
    n="$(basename "$d")"
    valid_skill_name "$n" && is_tracked "skills/$n/SKILL.md" && NAMES+=("$n")
  done
fi
[ ${#NAMES[@]} -gt 0 ] || die "no skills found under $SKILLS_DIR"
for n in "${NAMES[@]}"; do
  valid_skill_name "$n" || die "not a plain skill name: $n"
  is_tracked "skills/$n/SKILL.md" || die "no such skill tracked by git: $n"
done

mkdir -p "$OUT_DIR"
OUT_DIR="$(cd "$OUT_DIR" && pwd)"
WORK="$(mktemp -d "${TMPDIR:-/tmp}/package-skills.XXXXXX")"
# CURRENT_OUT names the bundle being built, so an interrupted build never leaves a partial one
CURRENT_OUT=""
trap 'rm -rf "$WORK"; [ -z "$CURRENT_OUT" ] || rm -f "$CURRENT_OUT"' EXIT

# ---------------------------------------------------------------------------------------------
# Helpers written once into the work directory.

cat > "$WORK/zip.ps1" <<'PS1'
param([string]$Root, [string]$List, [string]$Out)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem
if (Test-Path -LiteralPath $Out) { Remove-Item -LiteralPath $Out -Force }
$zip = [System.IO.Compression.ZipFile]::Open($Out, [System.IO.Compression.ZipArchiveMode]::Create)
try {
  foreach ($rel in [System.IO.File]::ReadAllLines($List)) {
    if ($rel -eq '') { continue }
    $entry = $rel.Replace('\', '/')
    $src = [System.IO.Path]::Combine($Root, $rel.Replace('/', [System.IO.Path]::DirectorySeparatorChar))
    [void][System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $src, $entry, [System.IO.Compression.CompressionLevel]::Optimal)
  }
} finally { $zip.Dispose() }
PS1

cat > "$WORK/list.ps1" <<'PS1'
param([string]$Zip)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
$z = [System.IO.Compression.ZipFile]::OpenRead($Zip)
try { foreach ($e in $z.Entries) { [Console]::Out.WriteLine($e.FullName) } } finally { $z.Dispose() }
PS1

cat > "$WORK/extract.ps1" <<'PS1'
param([string]$Zip, [string]$Dest)
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory($Zip, $Dest)
PS1

cat > "$WORK/zip.js" <<'JS'
// Minimal zip tool. "create ROOT LIST OUT" writes deflated entries named exactly as LIST gives
// them. "list ZIP" prints raw entry names. "extract ZIP DEST" unpacks.
const fs = require('fs'), zlib = require('zlib'), path = require('path');
const T = new Uint32Array(256);
for (let n = 0; n < 256; n++) { let c = n; for (let k = 0; k < 8; k++) c = c & 1 ? 0xEDB88320 ^ (c >>> 1) : c >>> 1; T[n] = c >>> 0; }
const crc32 = b => { let c = 0xFFFFFFFF; for (const x of b) c = T[(c ^ x) & 255] ^ (c >>> 8); return (c ^ 0xFFFFFFFF) >>> 0; };
function entries(buf) {
  let e = buf.length - 22;
  while (e >= 0 && buf.readUInt32LE(e) !== 0x06054b50) e--;
  if (e < 0) throw new Error('not a zip archive');
  const count = buf.readUInt16LE(e + 10); let p = buf.readUInt32LE(e + 16); const out = [];
  for (let i = 0; i < count; i++) {
    const nl = buf.readUInt16LE(p + 28), xl = buf.readUInt16LE(p + 30), cl = buf.readUInt16LE(p + 32);
    out.push({ method: buf.readUInt16LE(p + 10), csize: buf.readUInt32LE(p + 20), offset: buf.readUInt32LE(p + 42),
               name: buf.slice(p + 46, p + 46 + nl).toString('utf8') });
    p += 46 + nl + xl + cl;
  }
  return out;
}
const [cmd, a, b, c] = process.argv.slice(2);
if (cmd === 'create') {
  const names = fs.readFileSync(b, 'utf8').split('\n').filter(Boolean);
  const parts = [], central = []; let off = 0;
  for (const rel of names) {
    const name = Buffer.from(rel.replace(/\\/g, '/'), 'utf8');
    const data = fs.readFileSync(path.join(a, ...rel.split('/')));
    const comp = zlib.deflateRawSync(data, { level: 9 }), crc = crc32(data);
    const lh = Buffer.alloc(30);
    lh.writeUInt32LE(0x04034b50, 0); lh.writeUInt16LE(20, 4); lh.writeUInt16LE(0x0800, 6); lh.writeUInt16LE(8, 8);
    lh.writeUInt16LE(0, 10); lh.writeUInt16LE(0x21, 12); lh.writeUInt32LE(crc, 14);
    lh.writeUInt32LE(comp.length, 18); lh.writeUInt32LE(data.length, 22); lh.writeUInt16LE(name.length, 26); lh.writeUInt16LE(0, 28);
    const ch = Buffer.alloc(46);
    ch.writeUInt32LE(0x02014b50, 0); ch.writeUInt16LE((3 << 8) | 20, 4); ch.writeUInt16LE(20, 6); ch.writeUInt16LE(0x0800, 8);
    ch.writeUInt16LE(8, 10); ch.writeUInt16LE(0, 12); ch.writeUInt16LE(0x21, 14); ch.writeUInt32LE(crc, 16);
    ch.writeUInt32LE(comp.length, 20); ch.writeUInt32LE(data.length, 24); ch.writeUInt16LE(name.length, 28);
    ch.writeUInt32LE((0o100644 << 16) >>> 0, 38); ch.writeUInt32LE(off, 42);
    parts.push(lh, name, comp); central.push(ch, name); off += 30 + name.length + comp.length;
  }
  const cd = Buffer.concat(central), end = Buffer.alloc(22);
  end.writeUInt32LE(0x06054b50, 0); end.writeUInt16LE(names.length, 8); end.writeUInt16LE(names.length, 10);
  end.writeUInt32LE(cd.length, 12); end.writeUInt32LE(off, 16);
  fs.writeFileSync(c, Buffer.concat([...parts, cd, end]));
} else if (cmd === 'list') {
  for (const e of entries(fs.readFileSync(a))) console.log(e.name);
} else if (cmd === 'extract') {
  const buf = fs.readFileSync(a);
  for (const e of entries(buf)) {
    if (e.name.endsWith('/')) continue;
    const p = e.offset, start = p + 30 + buf.readUInt16LE(p + 26) + buf.readUInt16LE(p + 28);
    const raw = buf.slice(start, start + e.csize);
    const data = e.method === 8 ? zlib.inflateRawSync(raw) : raw;
    const dest = path.join(b, ...e.name.split('/'));
    fs.mkdirSync(path.dirname(dest), { recursive: true }); fs.writeFileSync(dest, data);
  }
} else { throw new Error('usage: create ROOT LIST OUT | list ZIP | extract ZIP DEST'); }
JS

run_ps() { "$POWERSHELL" -NoProfile -NonInteractive -ExecutionPolicy Bypass -File "$(ps_path "$1")" "${@:2}"; }

# Stage one skill as NAME/..., tracked files only, text files LF-normalized, OS junk left out.
# Writes the list of entry names, relative to the stage root, to NAME.list. Returns non-zero on
# any failure. It runs under "if", where errexit is off, so every step is checked here.
stage_skill() {
  local name="$1" stage="$WORK/stage/$1" path src rel
  rm -rf "$stage" && mkdir -p "$stage" || return 1
  : > "$WORK/$name.list" || return 1
  while IFS= read -r -d '' path; do
    src="$REPO/$path"
    rel="${path#"skills/$name/"}"
    case "$(basename "$src")" in .DS_Store|Thumbs.db|desktop.ini) continue ;; esac
    if [ ! -f "$src" ]; then
      echo "  FAIL $name: tracked file $path is missing from the working tree"
      return 1
    fi
    mkdir -p "$(dirname "$stage/$rel")" || return 1
    if [ -s "$src" ] && ! grep -Iq . "$src"; then
      cp "$src" "$stage/$rel" || return 1          # binary, packed untouched
    else
      tr -d '\r' < "$src" > "$stage/$rel" || return 1
    fi
    printf '%s/%s\n' "$name" "$rel" >> "$WORK/$name.list" || return 1
  done < <(git -C "$REPO" ls-files -z -- "skills/$name/")
  [ -s "$WORK/$name.list" ]
}

build_bundle() {
  local name="$1" out="$OUT_DIR/$1.skill"
  rm -f "$out"
  case "$TOOL" in
    zip)
      ( cd "$WORK/stage" && zip -q -X -D "$out" -@ < "$WORK/$name.list" ) ;;
    powershell)
      run_ps "$WORK/zip.ps1" -Root "$(ps_path "$WORK/stage")" -List "$(ps_path "$WORK/$name.list")" \
        -Out "$(ps_path "$out")" ;;
    node)
      node "$(native_path "$WORK/zip.js")" create "$(native_path "$WORK/stage")" \
        "$(native_path "$WORK/$name.list")" "$(native_path "$out")" ;;
  esac
}

list_bundle() {
  case "$VERIFIER" in
    unzip)      unzip -Z1 "$1" ;;
    node)       node "$(native_path "$WORK/zip.js")" list "$(native_path "$1")" ;;
    powershell) run_ps "$WORK/list.ps1" -Zip "$(ps_path "$1")" ;;
  esac | tr -d '\r'
}

extract_bundle() {
  case "$VERIFIER" in
    unzip)      unzip -q "$1" -d "$2" ;;
    node)       node "$(native_path "$WORK/zip.js")" extract "$(native_path "$1")" "$(native_path "$2")" ;;
    powershell) run_ps "$WORK/extract.ps1" -Zip "$(ps_path "$1")" -Dest "$(ps_path "$2")" ;;
  esac
}

verify_bundle() {
  local name="$1" out="$OUT_DIR/$1.skill" x="$WORK/extract/$1" bad=0
  list_bundle "$out" > "$WORK/$name.entries"
  if grep -q '\\' "$WORK/$name.entries"; then
    echo "  FAIL $name: backslash in an entry name"; bad=1
  fi
  if grep -v "^$name/" "$WORK/$name.entries" | grep -q .; then
    echo "  FAIL $name: an entry sits outside the $name/ directory"; bad=1
  fi
  if ! grep -qx "$name/SKILL.md" "$WORK/$name.entries"; then
    echo "  FAIL $name: no $name/SKILL.md entry"; bad=1
  fi
  if ! diff <(LC_ALL=C sort "$WORK/$name.entries") <(LC_ALL=C sort "$WORK/$name.list") >/dev/null; then
    echo "  FAIL $name: entry list differs from the skill's files"; bad=1
  fi
  rm -rf "$x"; mkdir -p "$x"
  if ! extract_bundle "$out" "$x"; then
    echo "  FAIL $name: extraction failed"; bad=1
  elif ! diff -r "$WORK/stage/$name" "$x/$name" >/dev/null; then
    echo "  FAIL $name: extracted files differ from the skill directory"; bad=1
  fi
  [ "$bad" -eq 0 ]
}

# ---------------------------------------------------------------------------------------------

echo "Packaging ${#NAMES[@]} skill(s) into $OUT_DIR with $TOOL, verifying with $VERIFIER"
failed=0
for name in "${NAMES[@]}"; do
  CURRENT_OUT="$OUT_DIR/$name.skill"
  if ! stage_skill "$name"; then
    echo "  FAIL $name: could not stage its tracked files"
    rm -f "$CURRENT_OUT"; failed=$((failed + 1))
  elif ! build_bundle "$name"; then
    echo "  FAIL $name: the $TOOL archiver failed"
    rm -f "$CURRENT_OUT"; failed=$((failed + 1))
  elif verify_bundle "$name"; then
    printf '  ok   %-34s %3d files  %7d bytes\n' "$name.skill" \
      "$(wc -l < "$WORK/$name.list" | tr -d ' ')" "$(wc -c < "$OUT_DIR/$name.skill" | tr -d ' ')"
  else
    rm -f "$CURRENT_OUT"; failed=$((failed + 1))
  fi
  CURRENT_OUT=""
done

if [ "$failed" -gt 0 ]; then
  echo "$failed bundle(s) failed and were removed."; exit 1
fi
echo "All ${#NAMES[@]} bundle(s) built and verified."

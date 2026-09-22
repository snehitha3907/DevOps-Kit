#!/usr/bin/env bash
# setup-gitattributes-filters-and-merge.sh — Reusable .gitattributes setup
#
# last_verified: 2026-09-22 · git (n/a)
#
# Purpose: Write a .gitattributes file covering line-ending normalization,
#   clean/smudge filters, custom diff drivers for binary and notebook files,
#   and merge drivers for whitespace-sensitive and generated files. Then wire
#   up the matching local git config entries the attributes point at.
#
# When to use: a fresh checkout (or a repo template) where line endings,
#   noisy notebook diffs, and generated-file merge conflicts keep recurring.
#   This is one way to do it; the docs also show setting each attribute by
#   hand per file type.
#
# Usage: ./setup-gitattributes-filters-and-merge.sh [--target <dir>] [--force]
#
# Verify:
#   git check-attr -a -- <path>     # e.g. git check-attr -a -- app.ipynb
#   git config --local --list | grep -E 'diff\.|filter\.|merge\.'
set -euo pipefail

TARGET="."
FORCE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --target) TARGET="$2"; shift 2 ;;
    --force) FORCE=true; shift ;;
    -h|--help)
      sed -n '2,20p' "$0" | sed 's/^# \?//'
      exit 0
      ;;
    *) echo "Unknown argument: $1" >&2; exit 1 ;;
  esac
done

if [[ ! -d "$TARGET" ]]; then
  echo "Error: target directory not found: $TARGET" >&2
  exit 1
fi

if ! command -v git >/dev/null 2>&1; then
  echo "Error: git is not installed or not in PATH" >&2
  exit 1
fi

ATTR_FILE="$TARGET/.gitattributes"
if [[ -f "$ATTR_FILE" && "$FORCE" == false ]]; then
  echo "Error: $ATTR_FILE already exists (pass --force to overwrite)" >&2
  exit 1
fi

# I hit mangled scripts once after a Windows checkout, so line endings go
# first: normalize everything, pin scripts to LF, batch files to CRLF.
cat > "$ATTR_FILE" <<'EOF'
# Line endings: normalize on commit, check out per rule below.
* text=auto
*.sh text eol=lf
*.bat text eol=crlf
*.ps1 text eol=crlf

# Trailing-whitespace cleanup on commit for plain-text sources.
*.py filter=trimtrail
*.md filter=trimtrail

# Custom diff drivers: readable notebook diffs, listing for zips,
# binary marker for images and PDFs so git never tries a text diff.
*.ipynb diff=notebook
*.zip diff=ziplist
*.png binary
*.jpg binary
*.pdf binary

# Merge drivers: keep the local lockfile on conflict, union-merge the
# changelog, and renormalize whitespace-sensitive files before merging.
package-lock.json merge=ours
*.lock merge=ours
CHANGELOG.md merge=union
Makefile text eol=lf merge=text
*.tsv text eol=lf merge=text
EOF

# Wire up the drivers the attributes file references. Each git config call
# is idempotent, so re-running the script just re-applies the same values.
git -C "$TARGET" config filter.trimtrail.clean "sed 's/[[:space:]]*$//'"
git -C "$TARGET" config filter.trimtrail.smudge "cat"
git -C "$TARGET" config diff.notebook.textconv "python3 -m json.tool"
git -C "$TARGET" config diff.ziplist.textconv "unzip -l"
git -C "$TARGET" config merge.ours.driver "true"

echo "Wrote $ATTR_FILE and configured filter/diff/merge drivers."

echo "--- verify: sample attribute lookups ---"
git -C "$TARGET" check-attr -a -- run.sh app.ipynb logo.png package-lock.json CHANGELOG.md Makefile || true

#!/usr/bin/env bash
# last_verified: 2026-10-25 · git n/a
# changelog-generator.sh — generate changelog from conventional commits
#
# Generates a changelog in Markdown format based on conventional
# commit messages since the last version tag.
#
# Usage: ./changelog-generator.sh [--version <version>] [--output <file>] [--since <tag>]

set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() {
  echo -e "${BLUE}info:${NC} $*"
}

success() {
  echo -e "${GREEN}success:${NC} $*"
}

warn() {
  echo -e "${YELLOW}warning:${NC} $*"
}

error() {
  echo -e "${RED}error:${NC} $*" >&2
}

usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

Options:
  --version VERSION   Version to generate changelog for (default: auto-detect)
  --output FILE       Output file (default: stdout)
  --since TAG         Generate changelog since this tag (default: last version tag)
  --prefix PREFIX     Tag prefix (default: v)
  --help              Show this help message

Outputs:
  Markdown changelog to stdout or specified file.

Examples:
  $0                              # Generate changelog for next version
  $0 --version 1.2.3             # Generate for specific version
  $0 --output CHANGELOG.md       # Write to file
  $0 --since v1.0.0              # Generate since specific tag
EOF
}

VERSION=""
OUTPUT=""
SINCE_TAG=""
TAG_PREFIX="v"

while [ $# -gt 0 ]; do
  case "$1" in
    --version)
      VERSION="$2"
      shift 2
      ;;
    --output)
      OUTPUT="$2"
      shift 2
      ;;
    --since)
      SINCE_TAG="$2"
      shift 2
      ;;
    --prefix)
      TAG_PREFIX="$2"
      shift 2
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      error "unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

if [ -z "$REPO_ROOT" ]; then
  error "not in a Git repository"
  exit 1
fi

# Determine since tag
if [ -z "$SINCE_TAG" ]; then
  SINCE_TAG=$(git tag -l "${TAG_PREFIX}*" --sort=-v:refname | head -1 || echo "")
fi

# Determine version
if [ -z "$VERSION" ]; then
  if [ -z "$SINCE_TAG" ]; then
    VERSION="0.1.0"
  else
    VERSION="${SINCE_TAG#"${TAG_PREFIX}"}"
  fi
fi

# Get commits since tag
if [ -z "$SINCE_TAG" ]; then
  COMMITS=$(git log --pretty=format:"%H|%s|%b" --reverse 2>/dev/null || echo "")
else
  COMMITS=$(git log --pretty=format:"%H|%s|%b" --reverse "${SINCE_TAG}..HEAD" 2>/dev/null || echo "")
fi

if [ -z "$COMMITS" ]; then
  warn "No commits found in range"
  COMMITS=""
fi

# Categorize commits
FEATURES=()
FIXES=()
DOCS=()
STYLES=()
REFACTORS=()
PERF=()
TESTS=()
CHORES=()
CI=()
BUILDS=()
REVERTS=()
BREAKING=()

while IFS='|' read -r hash subject body; do
  # Skip non-conventional commits
  if ! echo "$subject" | grep -qE '^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\(.+\))?!?:'; then
    continue
  fi

  TYPE=$(echo "$subject" | sed -E 's/^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\(.+\))?!?:.*/\1/')
  SCOPE=$(echo "$subject" | sed -E 's/^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\((.+)\))?!?:.*/\3/')
  DESC=$(echo "$subject" | sed -E 's/^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\(.+\))?!?:\s*//')

  # Check for breaking change
  IS_BREAKING=false
  if echo "$subject" | grep -qE '^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\(.+\))?!:'; then
    IS_BREAKING=true
  fi
  if echo "$body" | grep -qi "BREAKING CHANGE"; then
    IS_BREAKING=true
  fi

  ENTRY="- $DESC"
  if [ -n "$SCOPE" ]; then
    ENTRY="**$SCOPE:** $ENTRY"
  fi
  if [ -n "$hash" ]; then
    REPO_URL=$(git remote get-url origin 2>/dev/null | sed -E 's/.*[:/]([^/]+\/[^/]+)(\.git)?$/\1/')
    GITHUB_BASE="https://github.com"
    ENTRY="$ENTRY ([\`${hash:0:7}\`](https://github.com/${REPO_URL}/commit/$hash))"
  fi

  case "$TYPE" in
    feat)
      if [ "$IS_BREAKING" = true ]; then
        BREAKING+=("$ENTRY")
      else
        FEATURES+=("$ENTRY")
      fi
      ;;
    fix)
      FIXES+=("$ENTRY")
      ;;
    docs)
      DOCS+=("$ENTRY")
      ;;
    style)
      STYLES+=("$ENTRY")
      ;;
    refactor)
      REFACTORS+=("$ENTRY")
      ;;
    perf)
      PERF+=("$ENTRY")
      ;;
    test)
      TESTS+=("$ENTRY")
      ;;
    chore)
      CHORES+=("$ENTRY")
      ;;
    ci)
      CI+=("$ENTRY")
      ;;
    build)
      BUILDS+=("$ENTRY")
      ;;
    revert)
      REVERTS+=("$ENTRY")
      ;;
  esac
done <<< "$COMMITS"

# Generate changelog
DATE=$(date +"%Y-%m-%d")
CHANGELOG="# Changelog

## [$VERSION] - $DATE"

if [ ${#BREAKING[@]} -gt 0 ]; then
  CHANGELOG="$CHANGELOG

### ⚠ BREAKING CHANGES
$(printf '%s\n' "${BREAKING[@]}")"
fi

if [ ${#FEATURES[@]} -gt 0 ]; then
  CHANGELOG="$CHANGELOG

### ✨ Features
$(printf '%s\n' "${FEATURES[@]}")"
fi

if [ ${#FIXES[@]} -gt 0 ]; then
  CHANGELOG="$CHANGELOG

### 🐛 Bug Fixes
$(printf '%s\n' "${FIXES[@]}")"
fi

if [ ${#PERF[@]} -gt 0 ]; then
  CHANGELOG="$CHANGELOG

### ⚡ Performance Improvements
$(printf '%s\n' "${PERF[@]}")"
fi

if [ ${#REFACTORS[@]} -gt 0 ]; then
  CHANGELOG="$CHANGELOG

### ♻ Code Refactoring
$(printf '%s\n' "${REFACTORS[@]}")"
fi

if [ ${#DOCS[@]} -gt 0 ]; then
  CHANGELOG="$CHANGELOG

### 📝 Documentation
$(printf '%s\n' "${DOCS[@]}")"
fi

if [ ${#TESTS[@]} -gt 0 ]; then
  CHANGELOG="$CHANGELOG

### ✅ Tests
$(printf '%s\n' "${TESTS[@]}")"
fi

if [ ${#STYLES[@]} -gt 0 ]; then
  CHANGELOG="$CHANGELOG

### 💄 Styles
$(printf '%s\n' "${STYLES[@]}")"
fi

if [ ${#CI[@]} -gt 0 ]; then
  CHANGELOG="$CHANGELOG

### 🔧 Continuous Integration
$(printf '%s\n' "${CI[@]}")"
fi

if [ ${#BUILDS[@]} -gt 0 ]; then
  CHANGELOG="$CHANGELOG

### 🏗 Build System
$(printf '%s\n' "${BUILDS[@]}")"
fi

if [ ${#CHORES[@]} -gt 0 ]; then
  CHANGELOG="$CHANGELOG

### 🏠 Chores
$(printf '%s\n' "${CHORES[@]}")"
fi

if [ ${#REVERTS[@]} -gt 0 ]; then
  CHANGELOG="$CHANGELOG

### ⏪ Reverts
$(printf '%s\n' "${REVERTS[@]}")"
fi

# Output
if [ -n "$OUTPUT" ]; then
  echo "$CHANGELOG" > "$OUTPUT"
  success "Changelog written to $OUTPUT"
else
  echo "$CHANGELOG"
fi
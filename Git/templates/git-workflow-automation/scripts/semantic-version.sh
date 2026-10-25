#!/usr/bin/env bash
# semantic-version.sh — calculate next semantic version from conventional commits
#
# Analyzes commit history since the last version tag and determines
# the next semantic version (major, minor, or patch) based on
# conventional commit types.
#
# Usage: ./semantic-version.sh [--dry-run] [--prefix <tag-prefix>]

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
  --dry-run         Show what version would be calculated without outputting it
  --prefix PREFIX   Tag prefix to use (default: v)
  --help            Show this help message

Outputs:
  The next semantic version (e.g., 1.2.3) to stdout.
  Use with command substitution: VERSION=\$(./semantic-version.sh)

Examples:
  $0                    # Calculate and output next version
  $0 --dry-run          # Show analysis without output
  $0 --prefix release-  # Use 'release-' as tag prefix
EOF
}

DRY_RUN=false
TAG_PREFIX="v"

while [ $# -gt 0 ]; do
  case "$1" in
    --dry-run)
      DRY_RUN=true
      shift
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

# Get the latest version tag
LATEST_TAG=$(git tag -l "${TAG_PREFIX}*" --sort=-v:refname | head -1 || echo "")

if [ -z "$LATEST_TAG" ]; then
  # No tags found, start at 0.1.0
  CURRENT_MAJOR=0
  CURRENT_MINOR=1
  CURRENT_PATCH=0
  info "No version tags found, starting at 0.1.0"
else
  # Parse current version
  VERSION="${LATEST_TAG#"${TAG_PREFIX}"}"
  if ! echo "$VERSION" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+(-[a-zA-Z0-9.-]+)?(\+[a-zA-Z0-9.-]+)?$'; then
    warn "Latest tag '$LATEST_TAG' is not a valid semver, starting at 0.1.0"
    CURRENT_MAJOR=0
    CURRENT_MINOR=1
    CURRENT_PATCH=0
  else
    CURRENT_MAJOR=$(echo "$VERSION" | cut -d. -f1)
    CURRENT_MINOR=$(echo "$VERSION" | cut -d. -f2)
    CURRENT_PATCH=$(echo "$VERSION" | cut -d. -f3 | cut -d- -f1)
    info "Latest version tag: $LATEST_TAG (parsed: $CURRENT_MAJOR.$CURRENT_MINOR.$CURRENT_PATCH)"
  fi
fi

# Determine commit range
if [ -z "$LATEST_TAG" ]; then
  COMMIT_RANGE="HEAD"
else
  COMMIT_RANGE="${LATEST_TAG}..HEAD"
fi

# Analyze commits since last tag
info "Analyzing commits in range: $COMMIT_RANGE"

MAJOR_BUMP=false
MINOR_BUMP=false
PATCH_BUMP=false

# Get commits with conventional format
COMMITS=$(git log --pretty=format:"%s" "$COMMIT_RANGE" 2>/dev/null | grep -E '^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\(.+\))?!?:' || echo "")

if [ -z "$COMMITS" ]; then
  warn "No conventional commits found since last tag"
  PATCH_BUMP=true
else
  echo "$COMMITS" | while IFS= read -r commit; do
    # Check for breaking change (! or BREAKING CHANGE in footer)
    if echo "$commit" | grep -qE '^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\(.+\))?!:'; then
      MAJOR_BUMP=true
      info "Breaking change detected: $commit"
    elif echo "$commit" | grep -qE '^feat('; then
      MINOR_BUMP=true
      info "Feature detected: $commit"
    elif echo "$commit" | grep -qE '^fix('; then
      PATCH_BUMP=true
      info "Fix detected: $commit"
    elif echo "$commit" | grep -qE '^(docs|style|refactor|perf|test|chore|ci|build|revert)('; then
      PATCH_BUMP=true
      info "Other change detected: $commit"
    fi
  done

  # Check for BREAKING CHANGE in commit bodies
  BREAKING_COMMITS=$(git log --pretty=format:"%b" "$COMMIT_RANGE" 2>/dev/null | grep -i "BREAKING CHANGE" || echo "")
  if [ -n "$BREAKING_COMMITS" ]; then
    MAJOR_BUMP=true
    info "Breaking change found in commit footer"
  fi
fi

# Calculate next version
NEXT_MAJOR=$CURRENT_MAJOR
NEXT_MINOR=$CURRENT_MINOR
NEXT_PATCH=$CURRENT_PATCH

if [ "$MAJOR_BUMP" = true ]; then
  NEXT_MAJOR=$((CURRENT_MAJOR + 1))
  NEXT_MINOR=0
  NEXT_PATCH=0
  info "Major version bump: $CURRENT_MAJOR.$CURRENT_MINOR.$CURRENT_PATCH -> $NEXT_MAJOR.$NEXT_MINOR.$NEXT_PATCH"
elif [ "$MINOR_BUMP" = true ]; then
  NEXT_MINOR=$((CURRENT_MINOR + 1))
  NEXT_PATCH=0
  info "Minor version bump: $CURRENT_MAJOR.$CURRENT_MINOR.$CURRENT_PATCH -> $NEXT_MAJOR.$NEXT_MINOR.$NEXT_PATCH"
elif [ "$PATCH_BUMP" = true ]; then
  NEXT_PATCH=$((CURRENT_PATCH + 1))
  info "Patch version bump: $CURRENT_MAJOR.$CURRENT_MINOR.$CURRENT_PATCH -> $NEXT_MAJOR.$NEXT_MINOR.$NEXT_PATCH"
else
  info "No version bump needed"
fi

NEXT_VERSION="$NEXT_MAJOR.$NEXT_MINOR.$NEXT_PATCH"

if [ "$DRY_RUN" = true ]; then
  echo ""
  echo "Analysis Summary:"
  echo "  Current version: $CURRENT_MAJOR.$CURRENT_MINOR.$CURRENT_PATCH"
  echo "  Next version:    $NEXT_VERSION"
  echo "  Major bump:      $MAJOR_BUMP"
  echo "  Minor bump:      $MINOR_BUMP"
  echo "  Patch bump:      $PATCH_BUMP"
else
  echo "$NEXT_VERSION"
fi
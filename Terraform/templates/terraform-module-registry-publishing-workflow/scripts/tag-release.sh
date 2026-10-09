#!/usr/bin/env bash
# last_verified: 2026-10-09 · bash · n/a
# Create and push a semantic version tag for module release.
# Usage:
#   ./tag-release.sh patch|minor|major|<version>
#   ./tag-release.sh 1.2.3
#   ./tag-release.sh minor

set -euo pipefail

# Get current latest tag
get_latest_tag() {
  git tag -l 'v*.*.*' --sort=-v:refname 2>/dev/null | head -1 || echo ""
}

# Parse semantic version
parse_version() {
  local version="$1"
  # Remove leading 'v' if present
  version="${version#v}"
  # Validate format
  if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "Error: Invalid version format '$version'. Expected X.Y.Z (e.g., 1.2.3 or v1.2.3)" >&2
    exit 1
  fi
  IFS='.' read -r MAJOR MINOR PATCH <<< "$version"
}

# Increment version
increment_version() {
  local bump_type="$1"
  case "$bump_type" in
    major)
      MAJOR=$((MAJOR + 1))
      MINOR=0
      PATCH=0
      ;;
    minor)
      MINOR=$((MINOR + 1))
      PATCH=0
      ;;
    patch)
      PATCH=$((PATCH + 1))
      ;;
    *)
      echo "Error: Invalid bump type '$bump_type'. Use major, minor, or patch." >&2
      exit 1
      ;;
  esac
}

# Main
BUMP_OR_VERSION="${1:-patch}"

# Check for uncommitted changes
if ! git diff --quiet || ! git diff --cached --quiet; then
  echo "Error: Working directory has uncommitted changes. Commit or stash them first."
  exit 1
fi

# Get latest tag
LATEST_TAG=$(get_latest_tag)

if [[ -z "$LATEST_TAG" ]]; then
  echo "No existing tags found. Starting at v1.0.0"
  MAJOR=1
  MINOR=0
  PATCH=0
else
  echo "Latest tag: ${LATEST_TAG}"
  parse_version "$LATEST_TAG"
fi

# Determine new version
if [[ "$BUMP_OR_VERSION" =~ ^(major|minor|patch)$ ]]; then
  increment_version "$BUMP_OR_VERSION"
  NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
else
  # Explicit version provided
  parse_version "$BUMP_OR_VERSION"
  NEW_VERSION="${MAJOR}.${MINOR}.${PATCH}"
fi

NEW_TAG="v${NEW_VERSION}"

echo "Creating release tag: ${NEW_TAG}"

# Check if tag already exists
if git rev-parse "${NEW_TAG}" >/dev/null 2>&1; then
  echo "Error: Tag '${NEW_TAG}' already exists locally."
  exit 1
fi

if git ls-remote --tags origin | grep -q "refs/tags/${NEW_TAG}$"; then
  echo "Error: Tag '${NEW_TAG}' already exists on remote."
  exit 1
fi

# Create annotated tag
git tag -a "${NEW_TAG}" -m "Release ${NEW_TAG}"

echo "Tag created locally. Push with:"
echo "  git push origin ${NEW_TAG}"
echo ""
echo "To push now, run:"
echo "  git push origin ${NEW_TAG}"

# Ask for confirmation to push
read -r -p "Push tag to origin now? [y/N] " response
if [[ "$response" =~ ^[Yy]$ ]]; then
  git push origin "${NEW_TAG}"
  echo "Tag pushed. GitHub Actions release workflow will trigger."
else
  echo "Tag not pushed. Run 'git push origin ${NEW_TAG}' when ready."
fi
#!/usr/bin/env bash
# last_verified: 2026-08-24 · Git

set -euo pipefail

REPO_DIR="${1:-.}"
BASE_BRANCH="${2:-main}"

if [[ ! -d "$REPO_DIR/.git" ]]; then
    echo "Error: ${REPO_DIR} is not a git repository" >&2
    exit 1
fi

cd "$REPO_DIR"

if ! git show-ref --verify --quiet "refs/heads/${BASE_BRANCH}"; then
    echo "Error: base branch '${BASE_BRANCH}' does not exist locally" >&2
    exit 1
fi

echo "Updating ${BASE_BRANCH}..."
git checkout "$BASE_BRANCH"
git pull origin "$BASE_BRANCH" --ff-only 2>/dev/null \
    || echo "Remote update skipped (no remote or non-FF). Using local ${BASE_BRANCH}."

FEATURE_NAME="feature/$(date +%Y%m%d)-automation"
git checkout -b "$FEATURE_NAME"

echo "Created feature branch: ${FEATURE_NAME}"
echo "Workflow:"
echo "  1. Make changes and commit:"
echo "     git add -A && git commit -m 'describe your change'"
echo "  2. Merge back to ${BASE_BRANCH}:"
echo "     git checkout ${BASE_BRANCH} && git merge --no-ff ${FEATURE_NAME}"
echo "  3. Tag the release and push:"
echo "     git tag v1.0.0 ${BASE_BRANCH}"
echo "     git push origin ${BASE_BRANCH} --tags"

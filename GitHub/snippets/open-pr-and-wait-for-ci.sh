#!/usr/bin/env bash
# last_verified: 2026-08-22 · GitHub CLI (gh)
# Open a PR for the current branch and block until its CI checks finish reporting.
# Companion to GitHub/docs/branch-protection-and-required-reviews-for-ci.md — useful
# once a required-status-check rule means "merge" depends on the checks passing.
set -euo pipefail

BASE="${1:-main}"
TITLE="${2:-$(git log -1 --pretty=%s)}"

branch="$(git rev-parse --abbrev-ref HEAD)"
if [ "$branch" = "$BASE" ]; then
  echo "Refusing to open a PR from '$BASE' into itself — switch to a feature branch first." >&2
  exit 1
fi

# gh pr create needs the branch to exist on the remote, so push it first.
git push --set-upstream origin "$branch"

# Reuse an already-open PR instead of failing on a second run of this script.
if url="$(gh pr view "$branch" --json url --jq .url 2>/dev/null)"; then
  echo "Reusing open PR: $url"
else
  url="$(gh pr create --base "$BASE" --head "$branch" --title "$TITLE" \
    --body "Opened by open-pr-and-wait-for-ci.sh")"
  echo "Opened PR: $url"
fi

# --watch blocks until every reported check finishes, then exits non-zero if any failed.
# A repo with no checks configured also exits non-zero, which is why the message below
# points at the PR rather than claiming a test failure.
if gh pr checks "$branch" --watch; then
  echo "Checks passed for $branch — merge is gated on review from here."
else
  echo "Checks did not pass (or none reported) for $branch — see $url" >&2
  exit 1
fi

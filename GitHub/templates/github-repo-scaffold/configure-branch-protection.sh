#!/usr/bin/env bash
# last_verified: 2026-09-19 · GitHub n/a
# configure-branch-protection.sh — Apply branch protection rules to a GitHub repository
# Usage: ./configure-branch-protection.sh <owner> <repo> [branch]
# Requires: gh CLI authenticated with repo admin permissions

set -euo pipefail

OWNER="${1:-}"
REPO="${2:-}"
BRANCH="${3:-main}"

if [[ -z "$OWNER" || -z "$REPO" ]]; then
  echo "Usage: $0 <owner> <repo> [branch]"
  echo "Example: $0 myorg myrepo main"
  exit 1
fi

echo "Configuring branch protection for $OWNER/$REPO on branch '$BRANCH'..."

# Require PR reviews before merging
gh api \
  --method PUT \
  "/repos/$OWNER/$REPO/branches/$BRANCH/protection" \
  --input - <<EOF
{
  "required_status_checks": {
    "strict": true,
    "contexts": ["ci/build", "ci/test", "ci/lint"]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "dismissal_restrictions": {},
    "dismiss_stale_reviews": true,
    "require_code_owner_reviews": true,
    "required_approving_review_count": 2
  },
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false,
  "required_conversation_resolution": true,
  "lock_branch": false,
  "allow_fork_syncing": true
}
EOF

echo "Branch protection configured for $BRANCH"
echo "Required checks: ci/build, ci/test, ci/lint"
echo "Required reviews: 2 (including code owners)"
echo "Force pushes: disabled"
echo "Deletions: disabled"
echo "Conversation resolution: required"
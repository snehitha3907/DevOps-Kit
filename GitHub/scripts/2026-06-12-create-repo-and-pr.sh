#!/bin/bash
# 2026-06-12-create-repo-and-pr.sh
# Create a repo and open a PR with gh CLI — first time doing the full flow

set -e

REPO="test-pr-flow-$(date +%s)"
TMPDIR=$(mktemp -d)

trap 'rm -rf "$TMPDIR"; gh repo delete "$REPO" --yes 2>/dev/null || true' EXIT

echo "=== Creating repo $REPO ==="
gh repo create "$REPO" --public --clone --push --remote origin --directory "$TMPDIR"

cd "$TMPDIR"

echo "=== Adding a file on main ==="
echo "# Test PR Flow" > README.md
git add README.md
git commit -m "chore: add README"

echo "=== Creating feature branch ==="
git checkout -b add-feature
echo "feature: hello from the PR branch" > feature.txt
git add feature.txt
git commit -m "feat: add feature file"

echo "=== Pushing and opening PR ==="
git push origin add-feature
gh pr create --base main --head add-feature --title "Add feature file" --body "Testing the gh PR flow"

echo "Done — PR opened in repo $REPO"
gh pr view --web

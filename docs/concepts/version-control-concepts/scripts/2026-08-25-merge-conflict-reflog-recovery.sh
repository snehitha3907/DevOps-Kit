#!/usr/bin/env bash
# last_verified: 2026-08-25 · Git · n/a
#
# Version control concepts practice — resolving merge conflicts and recovering with reflog.
# I built this to walk through the two scariest git moments: hitting a merge conflict,
# and accidentally losing a commit. The script creates a throwaway repo, engineers both
# situations, then shows how to fix them.

WORKDIR=$(mktemp -d)
trap 'rm -rf "$WORKDIR"' EXIT
cd "$WORKDIR" || { echo "could not enter ${WORKDIR}"; exit 1; }

echo "=== Merge Conflict & Reflog Recovery Sandbox ==="
echo "Sandbox repo: ${WORKDIR}"
echo ""

# --- Step 1: Create initial commit ---
# I always start with a clean file so the conflict is easy to follow.
git init -q -b main
git config user.email "sandbox@local"
git config user.name "Sandbox User"

echo "line one" > file.txt
git add file.txt
git commit -q -m "initial: add file.txt"
echo "[main] initial commit"
echo ""

# --- Step 2: Create a branch and diverge ---
# This simulates a teammate's branch — they edit the same file I'm about
# to edit on main, which will cause a conflict when I merge.
git checkout -q -b feature
echo "feature change" >> file.txt
git add file.txt
git commit -q -m "feature: append to file.txt"
echo "[feature] branch created with one commit"
echo ""

# --- Step 3: Go back to main and make a conflicting change ---
# I edit the same line my "teammate" touched — this guarantees a conflict
# because both branches appended to file.txt without seeing each other's work.
git checkout -q main
echo "main change" >> file.txt
git add file.txt
git commit -q -m "main: append different line to file.txt"
echo "[main] conflicting commit on main"
echo ""

# --- Step 4: Merge — this will conflict ---
echo "[merge] Attempting merge (expect conflict)..."
if git merge feature -m "merge feature into main" 2>/dev/null; then
  echo "No conflict — unexpected. Manually creating conflict."
else
  echo "Conflict detected as expected."
fi

# --- Step 5: Resolve the conflict ---
# I keep both lines — the "right" resolution depends on context, but for
# a sandbox the point is just to see the mechanics of git add + commit.
echo "[resolve] Keeping both lines..."
cat > file.txt <<'EOF'
line one
main change
feature change
EOF
git add file.txt
git commit -q -m "resolve: keep both lines from main and feature"

echo "[log] Conflict resolution log:"
git log --oneline -5
echo ""

# --- Step 6: Simulate a mistake — reset hard to lose the merge ---
# This is the "oh no" moment. I reset to before the merge so the commit
# looks gone. In real life this happens when you fat-finger a rebase or
# reset and lose work you thought was safe.
echo "[mistake] Hard reset to before merge (simulating lost work)..."
MERGE_PARENT=$(git rev-parse HEAD~1)
git reset --hard "$MERGE_PARENT" -q

echo "[log] Current log (merge commit is gone):"
git log --oneline -3
echo ""

# --- Step 7: Recover the lost commit via reflog ---
# Git never really loses anything — reflog tracks every HEAD movement.
# I grep for the merge commit message, grab its SHA, and merge it back.
# This is the "phew" moment after the "oh no."
echo "[recover] Searching reflog for the lost merge..."
REFLOG_ENTRY=$(git reflog | grep "merge feature" | head -1 | awk '{print $1}')
if [ -n "$REFLOG_ENTRY" ]; then
  echo "Found reflog entry: $REFLOG_ENTRY"
  git merge "$REFLOG_ENTRY" --no-edit -q
  echo "[recover] Restored! Log after recovery:"
  git log --oneline -5
else
  echo "Direct grep missed — falling back to HEAD@{1}..."
  git merge "HEAD@{1}" --no-edit -q
  echo "[recover] Restored via HEAD@{1}. Log:"
  git log --oneline -5
fi
echo ""

echo "=== Final file contents ==="
cat file.txt
echo ""

echo "=== Sandbox cleaned up — temp repo removed ==="

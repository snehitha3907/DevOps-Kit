#!/usr/bin/env bash
# last_verified: 2026-08-08 · bash n/a

# Feature-branch workflow sandbox — L2 concept exercise for
# Version Control Concepts.
#
# I built this as a throwaway script that spins up a temp git repo,
# walks through the rebase-then-merge-then-tag flow, and cleans up
# afterward. Running it repeatedly helps the steps stick.

work_dir="$(mktemp -d)"
cd "${work_dir}" || { echo "could not enter ${work_dir}"; exit 1; }

echo "=== Git Feature-Branch Workflow Sandbox ==="
echo "Sandbox repo: ${work_dir}"
echo ""

# --- Step 1: init + initial commit on main ---
# I always start with a commit on main so there's a base to branch from.
git init -q -b main
git config user.email "sandbox@local"
git config user.name "Sandbox User"

echo "# README" > README.md
git add README.md
git commit -q -m "chore: initial commit"

echo "[main] init + initial commit"
echo ""

# --- Step 2: main moves forward while I'm away ---
# This is the situation that makes rebase useful: someone else already
# pushed to main before I finished my feature, so my branch is behind.
echo "v1" > app.txt
git add app.txt
git commit -q -m "feat: add app.txt with v1 content"

echo "v2" > app.txt
git add app.txt
git commit -q -m "feat: update app.txt to v2"

echo "[main] two commits landed on main ahead of my branch"
echo ""

# --- Step 3: create feature branch and commit ---
git checkout -q -b feature/user-profile

echo "profile base" > profile.txt
git add profile.txt
git commit -q -m "feat: add user profile scaffold"

echo "profile handler" >> profile.txt
git add profile.txt
git commit -q -m "feat: add profile update handler"

echo "[feature] two commits on feature/user-profile"
echo ""

# --- Step 4: rebase feature onto the updated main ---
# I rebase instead of merging main into the feature branch because
# rebase keeps history linear — no extra merge bubbles. My feature
# commits get replayed on top of the latest main, so it looks like
# I started from the current state.
git rebase -q main
echo "[rebase] feature branch rebased onto updated main"
echo ""

# --- Step 5: merge back to main with --no-ff ---
# --no-ff forces a merge-commit even though a fast-forward is
# possible. I do this so the feature's existence stays visible in
# git log --oneline --graph — useful when I need to find all the
# work that went into a particular release.
git checkout -q main
git merge -q --no-ff feature/user-profile -m "merge: integrate feature/user-profile"

echo "[merge] feature/user-profile merged into main (--no-ff)"
echo ""

# --- Step 6: tag a release ---
# I tag the merge commit with an annotated tag so I can check out
# the exact release state later: git checkout v0.1.0
git tag -a v0.1.0 -m "Release v0.1.0"

echo "[tag] annotated tag v0.1.0 created"
echo ""

# --- Results ---
echo "=== Results ==="
echo "Current branch: $(git branch --show-current)"
echo ""
echo "Tags:"
git tag -l
echo ""
echo "Commit graph:"
git --no-pager log --oneline --graph --decorate --all
echo ""

# --- Cleanup ---
cd / || echo "warning: could not leave ${work_dir}"
rm -rf "${work_dir}"
echo "=== Sandbox cleaned up — temp repo removed ==="

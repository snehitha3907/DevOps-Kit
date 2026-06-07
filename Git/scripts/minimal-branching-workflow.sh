#!/bin/bash
# Minimal branching workflow — create, merge, and rebase branches
# I'm using a temp dir so I don't mess up any real repos

TMPDIR=$(mktemp -d)
cd "$TMPDIR" || exit 1

git init

# Make a few commits on main so there's history to branch from
echo "# Branching Lab" > README.md
git add README.md && git commit -m "initial commit"
echo "second line" >> README.md
git add README.md && git commit -m "second commit"

# Create a feature branch and add work there
git checkout -b feature/add-greeting

echo "Hello from the feature branch" > greeting.txt
git add greeting.txt && git commit -m "add greeting file"

echo "echo 'hi'" > greet.sh
chmod +x greet.sh
git add greet.sh && git commit -m "add greet script"

# Go back to main and merge the feature branch (fast-forward since main hasn't diverged)
git checkout main
git merge feature/add-greeting

# Now simulate a non-fast-forward merge: branch off an older commit and let main advance
git checkout -b feature/alt-greeting HEAD~1
echo "Alternative greeting" > alt-greeting.txt
git add alt-greeting.txt && git commit -m "add alternative greeting"

git checkout main
echo "main-only change" >> README.md
git add README.md && git commit -m "main-only update"

# Divergent branches — this creates a real merge commit
git merge feature/alt-greeting -m "merge alt-greeting into main"

# Try rebase instead of merge for a clean linear history
git checkout -b feature/rebase-test
echo "rebase content" > rebase-test.txt
git add rebase-test.txt && git commit -m "commit for rebase practice"

git checkout main
echo "another main change" >> README.md
git add README.md && git commit -m "main before rebase"

# Rebase the feature branch onto updated main
git checkout feature/rebase-test
git rebase main

# Verify the result is linear
git log --oneline --all --graph

# Clean up
rm -rf "$TMPDIR"
echo "Done — branching workflow verified"

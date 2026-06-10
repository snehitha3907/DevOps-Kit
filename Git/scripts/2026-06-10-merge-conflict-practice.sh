#!/bin/bash
# Simulate a merge conflict and resolve it — practicing the full cycle
# I set up two branches that edit the same lines so Git can't auto-merge

set -e

LABDIR=$(mktemp -d)
cd "$LABDIR"

git init

# Create a base file on main
cat > story.txt <<'EOF'
Chapter 1: The Beginning
It was a dark and stormy night.
The wind howled through the trees.
EOF
git add story.txt && git commit -m "initial story"

# Branch off and make changes that'll conflict later
git checkout -b alice
cat > story.txt <<'EOF'
Chapter 1: The Beginning
It was a dark and stormy night.
Alice's version: the wind whispered secrets.
EOF
git add story.txt && git commit -m "alice edits line 3"

git checkout main
cat > story.txt <<'EOF'
Chapter 1: The Beginning
It was a dark and stormy night.
Bob's version: the trees danced wildly.
EOF
git add story.txt && git commit -m "bob edits line 3"

# Merge attempt — this should produce a conflict
git merge alice 2>&1 || echo "(merge conflict triggered as expected)"

# Show what's in conflict
echo "=== Conflict markers in story.txt ==="
cat story.txt

# Resolve by editing the file — I'll keep both changes
cat > story.txt <<'EOF'
Chapter 1: The Beginning
It was a dark and stormy night.
Alice heard the wind whisper secrets, while outside the trees danced wildly.
EOF

git add story.txt && git commit --no-edit

echo "=== Merge conflict resolved ==="
git log --oneline --graph --all

rm -rf "$LABDIR"
echo "Done — merge conflict simulated and resolved"

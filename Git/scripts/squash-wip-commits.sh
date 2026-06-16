#!/usr/bin/env bash
# squash-wip-commits.sh — automate interactive rebase to squash WIP commits before PR
#
# Finds all commits on the current branch that aren't on main, opens
# an interactive rebase so I can squash/fixup/reword them.  Defaults to
# the last N non-merge commits if called with a count argument.
#
# Usage:
#   ./squash-wip-commits.sh          # rebase all commits since branching from main
#   ./squash-wip-commits.sh 3        # rebase last 3 commits from HEAD
#   ./squash-wip-commits.sh -m       # rebase all + mark as fixup the ones starting with "wip"

set -e

# --- helpers ----------------------------------------------------------
branch_base() {
  if git merge-base HEAD main >/dev/null 2>&1; then
    git merge-base HEAD main
  else
    echo "fatal: no common ancestor with main" >&2
    exit 1
  fi
}

# --- main -------------------------------------------------------------

if [ "$1" = "-m" ]; then
  # mark-all mode: rebase and auto-squash commits whose message starts with "wip"
  base=$(branch_base)
  # set GIT_SEQUENCE_EDITOR to a script that replaces "pick" with "fixup" for wip commits
  export GIT_SEQUENCE_EDITOR
  GIT_SEQUENCE_EDITOR="sed -i '/^pick .*^wip/s/pick/fixup/'"
  git rebase -i "$base"
  echo "Rebased. Any commit starting with 'wip' was marked as fixup."
elif [ -n "$1" ]; then
  # rebase last N commits
  git rebase -i "HEAD~$1"
else
  # rebase all commits on this branch that aren't on main
  base=$(branch_base)
  git rebase -i "$base"
fi

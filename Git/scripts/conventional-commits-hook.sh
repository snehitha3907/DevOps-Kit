#!/bin/bash
# conventional-commits-hook.sh — enforce conventional commit message format on commit-msg
#
# Validates commit messages against conventional commit format:
#   type(scope): description
#   or
#   type: description
#
# Valid types: feat, fix, docs, style, refactor, test, chore
#
# Usage: place this file in .git/hooks/commit-msg and make it executable

COMMIT_MSG_FILE="$1"
COMMIT_MSG=$(cat "$COMMIT_MSG_FILE")

# Regex for conventional commit format: type(scope): desc OR type: desc
CONVENTIONAL_REGEX="^(feat|fix|docs|style|refactor|test|chore)(\(.+\))?: .+"

if ! [[ "$COMMIT_MSG" =~ $CONVENTIONAL_REGEX ]]; then
    echo "ERROR: Commit message does not follow conventional format"
    echo "Expected: type(scope): description"
    echo "  where type is one of: feat, fix, docs, style, refactor, test, chore"
    echo ""
    echo "Your message:"
    echo "  $COMMIT_MSG"
    exit 1
fi

exit 0
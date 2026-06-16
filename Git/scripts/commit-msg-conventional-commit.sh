#!/usr/bin/env bash
# commit-msg hook — enforce conventional commit message format
#
# Accepts: type(scope): description
#   type:     feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert
#   scope:    optional, alphanumeric + hyphens
#   desc:     required, >=1 characters
#
# Install: cp this file into .git/hooks/commit-msg

set -e

INPUT_FILE="$1"

if [ ! -f "$INPUT_FILE" ]; then
  echo "error: commit message file not found: $INPUT_FILE" >&2
  exit 1
fi

COMMIT_MSG=$(head -1 "$INPUT_FILE")

# skip merge commits
if echo "$COMMIT_MSG" | grep -qE '^Merge '; then
  exit 0
fi

# skip fixup!/squash! commits used in interactive rebase
if echo "$COMMIT_MSG" | grep -qE '^(fixup|squash)!'; then
  exit 0
fi

PATTERN='^(feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert)(\([a-zA-Z0-9._-]+\))?!?: .+$'

if ! echo "$COMMIT_MSG" | grep -qE "$PATTERN"; then
  echo "error: commit message does not follow conventional commit format" >&2
  echo "" >&2
  echo "  expected: type(scope): description" >&2
  echo "  types:    feat|fix|docs|style|refactor|perf|test|chore|ci|build|revert" >&2
  echo "  example:  feat(api): add rate limiting middleware" >&2
  exit 1
fi

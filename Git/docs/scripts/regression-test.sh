#!/usr/bin/env bash
# last_verified: 2026-09-25 · git (n/a)
#
# regression-test.sh — companion to automating-git-bisect-with-scripted-regression-tests.md
#
# Purpose: deterministic regression probe for `git bisect run`.
#   Exit 0 means the checked-out commit is good, exit 1 means it is bad,
#   exit 125 means the commit cannot be tested (bisect skips it and tries
#   the next one instead of blaming it).
#
# When to use: point `git bisect run` (or the `bisect-automation-runner.sh`
#   wrapper) at this script. Configure what "regressed" means through the
#   environment instead of editing the script per investigation.
#
# Prerequisites: the tool under test and its dependencies are installed;
#   bisect moves HEAD on every iteration, so anything derived from the
#   checkout must be rebuilt inside the run — use PRE_CMD for that.
#
# Configuration (environment variables):
#   TEST_CMD          command proving the regression is absent (default: pytest tests/ -q).
#                     Exit 0 = good, any other exit = bad.
#   PRE_CMD           optional rebuild step run before TEST_CMD on every
#                     iteration (e.g. reinstalling dependencies after checkout).
#   TEST_TIMEOUT_SECS bound the TEST_CMD run (default 300); honoured only
#                     when the `timeout` command is available.
#
# Usage:
#   TEST_CMD="pytest tests/test_checkout.py -q" git bisect run ./Git/docs/scripts/regression-test.sh
#   PRE_CMD="pip install -q -e ." TEST_CMD="make check" ./Git/docs/scripts/regression-test.sh; echo $?
#
# Verify: run this script on the known-good bound (expect exit 0) and on the
#   known-bad bound (expect exit 1) before starting bisect. A script that is
#   not green-on-good and red-on-bad makes bisect isolate the wrong commit.

set -euo pipefail

TEST_CMD="${TEST_CMD:-pytest tests/ -q}"
PRE_CMD="${PRE_CMD:-}"
TEST_TIMEOUT_SECS="${TEST_TIMEOUT_SECS:-300}"

if [[ -n "$PRE_CMD" ]]; then
  echo "regression-test: rebuild step: $PRE_CMD"
  if ! bash -c "$PRE_CMD"; then
    echo "regression-test: SKIP (rebuild step failed; not the commit's fault)" >&2
    exit 125
  fi
fi

# The binary under test must exist independently of the checkout under test.
# A missing binary is an environment problem, so skip instead of failing.
FIRST_WORD="${TEST_CMD%% *}"
if ! command -v "$FIRST_WORD" >/dev/null 2>&1; then
  echo "regression-test: SKIP (command not found: $FIRST_WORD)" >&2
  exit 125
fi

echo "regression-test: running: $TEST_CMD"

set +e
if command -v timeout >/dev/null 2>&1; then
  timeout "$TEST_TIMEOUT_SECS" bash -c "$TEST_CMD"
  STATUS=$?
  if [[ "$STATUS" -eq 124 ]]; then
    echo "regression-test: SKIP (timed out after ${TEST_TIMEOUT_SECS}s)" >&2
    exit 125
  fi
else
  bash -c "$TEST_CMD"
  STATUS=$?
fi
set -e

if [[ "$STATUS" -eq 0 ]]; then
  echo "regression-test: GOOD (exit 0)"
  exit 0
elif [[ "$STATUS" -eq 125 ]]; then
  echo "regression-test: SKIP (test itself reported 125)" >&2
  exit 125
else
  echo "regression-test: BAD (exit $STATUS)"
  exit 1
fi

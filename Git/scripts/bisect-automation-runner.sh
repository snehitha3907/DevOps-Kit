#!/usr/bin/env bash
# last_verified: 2026-09-25 · git (n/a)
#
# bisect-automation-runner.sh
#
# Purpose: drive `git bisect run` end to end for a scripted regression test.
#   Validates the repo state and the good/bad bounds, starts bisect, runs the
#   test script unattended, saves the search log, always resets the session,
#   and reports the first bad commit.
#
# When to use: a regression is confirmed on the bad ref, the good ref is
#   known, and a deterministic test script exits 0 on good commits and
#   non-zero on bad ones. Fits ranges too wide to step through by hand and
#   reruns inside CI jobs.
#
# Prerequisites: git on PATH; run from inside the repository under test;
#   clean working tree; resolvable good and bad refs; an executable test
#   script (see the companion `regression-test.sh` next to the bisect guide).
#
# Usage:
#   bisect-automation-runner.sh --good <ref> --bad <ref> --test <script> [--log <file>]
#
# Verify: the reported hash sits between the bounds
#   (`git merge-base --is-ancestor <good> <culprit>` and
#   `git merge-base --is-ancestor <culprit> <bad>`), then re-run the test
#   script on that commit in isolation. Rollback: the runner resets via trap;
#   if it is ever interrupted before the trap runs, execute
#   `git bisect reset` once by hand.

set -euo pipefail

LOG_FILE="bisect-run.log"
GOOD_REF=""
BAD_REF=""
TEST_SCRIPT=""

usage() {
  cat <<'EOF'
Usage: bisect-automation-runner.sh --good <ref> --bad <ref> --test <script> [--log <file>]

  --good <ref>     last known-good commit, tag, or branch
  --bad <ref>      known-bad commit, tag, or branch (usually HEAD)
  --test <script>  executable regression probe: exit 0 = good, non-zero = bad
  --log <file>     where to store the bisect transcript (default: bisect-run.log)
EOF
}

die() {
  echo "bisect-automation-runner: ERROR: $*" >&2
  exit "${2:-1}"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --good) GOOD_REF="${2:-}"; shift 2 ;;
    --bad) BAD_REF="${2:-}"; shift 2 ;;
    --test) TEST_SCRIPT="${2:-}"; shift 2 ;;
    --log) LOG_FILE="${2:-}"; shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) die "unknown argument: $1" 1 ;;
  esac
done

[[ -n "$GOOD_REF" ]] || { usage >&2; die "--good is required" 1; }
[[ -n "$BAD_REF" ]] || { usage >&2; die "--bad is required" 1; }
[[ -n "$TEST_SCRIPT" ]] || { usage >&2; die "--test is required" 1; }

command -v git >/dev/null 2>&1 || die "git is not on PATH" 2
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "not inside a git repository" 2

GIT_DIR="$(git rev-parse --git-dir)"
if [[ -e "$GIT_DIR/BISECT_LOG" ]]; then
  die "a bisect session is already active here (found $GIT_DIR/BISECT_LOG); run 'git bisect reset' first" 2
fi

if [[ -n "$(git status --porcelain)" ]]; then
  die "working tree is not clean; commit or stash changes before bisecting" 2
fi

GOOD_SHA="$(git rev-parse --verify "$GOOD_REF^{commit}" 2>/dev/null)" \
  || die "cannot resolve --good ref: $GOOD_REF" 2
BAD_SHA="$(git rev-parse --verify "$BAD_REF^{commit}" 2>/dev/null)" \
  || die "cannot resolve --bad ref: $BAD_REF" 2
[[ "$GOOD_SHA" != "$BAD_SHA" ]] || die "--good and --bad resolve to the same commit ($GOOD_SHA)" 1

[[ -f "$TEST_SCRIPT" ]] || die "test script not found: $TEST_SCRIPT" 2
[[ -x "$TEST_SCRIPT" ]] || die "test script is not executable: $TEST_SCRIPT (chmod +x it)" 2

BISECT_ACTIVE=0
cleanup() {
  if [[ "$BISECT_ACTIVE" -eq 1 ]]; then
    git bisect reset >/dev/null 2>&1 || true
  fi
}
trap cleanup EXIT INT TERM

echo "bisect-automation-runner: good=$GOOD_SHA bad=$BAD_SHA test=$TEST_SCRIPT log=$LOG_FILE"

git bisect start >/dev/null
BISECT_ACTIVE=1
git bisect bad "$BAD_SHA" >/dev/null
git bisect good "$GOOD_SHA" >/dev/null

set +e
git bisect run "$TEST_SCRIPT" 2>&1 | tee "$LOG_FILE"
RUN_STATUS="${PIPESTATUS[0]}"
set -e

git bisect log >>"$LOG_FILE" 2>/dev/null || true
git bisect reset >/dev/null
BISECT_ACTIVE=0

CULPRIT="$(grep -Eo '[0-9a-f]{7,40} is the first bad commit' "$LOG_FILE" | tail -n 1 | awk '{print $1}' || true)"

if [[ -n "$CULPRIT" ]]; then
  echo "bisect-automation-runner: first bad commit: $CULPRIT"
  echo "bisect-automation-runner: confirm with: git checkout $CULPRIT && $TEST_SCRIPT; echo \$?"
  exit 0
fi

echo "bisect-automation-runner: bisect finished without isolating a commit (run exit=$RUN_STATUS); see $LOG_FILE" >&2
exit 3

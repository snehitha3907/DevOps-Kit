#!/usr/bin/env bash
# last_verified: 2026-10-06 · OpenTofu n/a
# ot-011: wrapper around init/plan/apply with policy gates before apply.
#
# Purpose: run the same plan/apply sequence in every environment and stop
#   before apply when the plan violates a team policy.
# When to use: promoting a change through dev/staging/prod where apply must
#   never run on a plan that was not just reviewed by this script.
# Prerequisites: an OpenTofu working directory with configuration already
#   written; the caller runs this from a shell that already has cloud
#   credentials exported.
#
# Usage:
#   ./tofu-plan-apply-with-policy-checks.sh --working-dir ./live/dev
#   ./tofu-plan-apply-with-policy-checks.sh --working-dir ./live/prod --allow-destroy --auto-approve
#
# Inputs (flags, also readable as environment variables):
#   --working-dir DIR   directory holding the configuration (or WORKING_DIR).
#   --plan-file NAME    plan file name inside the working dir (default plan.out,
#                       or PLAN_FILE). The script always plans to this file and
#                       applies exactly this file, so apply cannot drift from
#                       what was reviewed.
#   --allow-destroy     permit resource deletions. Without it, any planned
#                       delete/destroy fails the policy gate (exit 2).
#   --auto-approve      actually run apply after the gates pass. Without it
#                       the script stops after writing the plan (safe default).
#
# Verify: re-run with --working-dir pointing at a no-change configuration;
#   expect "no changes" and exit 0 without calling apply.

set -euo pipefail

WORKING_DIR="${WORKING_DIR:-}"
PLAN_FILE="${PLAN_FILE:-plan.out}"
ALLOW_DESTROY=0
AUTO_APPROVE=0

usage() {
  sed -n '2,30p' "$0"
  echo "Flags: --working-dir DIR [--plan-file NAME] [--allow-destroy] [--auto-approve]"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --working-dir)
      WORKING_DIR="${2:?--working-dir needs a directory}"
      shift 2
      ;;
    --plan-file)
      PLAN_FILE="${2:?--plan-file needs a file name}"
      shift 2
      ;;
    --allow-destroy)
      ALLOW_DESTROY=1
      shift
      ;;
    --auto-approve)
      AUTO_APPROVE=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "error: unknown argument: $1 (see --help)" >&2
      exit 2
      ;;
  esac
done

if [[ -z "$WORKING_DIR" ]]; then
  echo "error: --working-dir is required" >&2
  usage >&2
  exit 2
fi

if [[ ! -d "$WORKING_DIR" ]]; then
  echo "error: working directory not found: $WORKING_DIR" >&2
  exit 1
fi

case "$PLAN_FILE" in
  */*|*..*|'')
    echo "error: plan file must be a plain file name, got: $PLAN_FILE" >&2
    exit 2
    ;;
esac

PLAN_PATH="$WORKING_DIR/$PLAN_FILE"

echo "step 1/4: init"
tofu -chdir="$WORKING_DIR" init -input=false

echo "step 2/4: format check and validate"
tofu -chdir="$WORKING_DIR" fmt -check -diff
tofu -chdir="$WORKING_DIR" validate

echo "step 3/4: plan"
tofu -chdir="$WORKING_DIR" plan -input=false -out="$PLAN_FILE"

PLAN_TEXT="$(tofu -chdir="$WORKING_DIR" show -no-color "$PLAN_FILE")"

# Policy gate 1: without --allow-destroy, no resource may be deleted.
if [[ "$ALLOW_DESTROY" -eq 0 ]]; then
  if printf '%s\n' "$PLAN_TEXT" | grep -Eq 'will be destroyed|must be replaced|Plan: .* to destroy'; then
    echo "policy gate FAILED: plan destroys or replaces resources but --allow-destroy was not given" >&2
    echo "re-run with --allow-destroy once the deletions have been reviewed," >&2
    echo "or revise the configuration so nothing is destroyed." >&2
    exit 2
  fi
  echo "policy gate 1 passed: no destructions planned"
else
  echo "policy gate 1 skipped: --allow-destroy given, deletions permitted"
fi

# Policy gate 2: the plan must contain at least one actionable change summary.
# A plan that renders with no resource summary usually means the wrong
# directory was targeted, so stop instead of applying an empty plan.
if ! printf '%s\n' "$PLAN_TEXT" | grep -Eq 'Plan: |No changes\.|has been saved to'; then
  echo "policy gate FAILED: plan output has no recognisable summary; refusing to continue" >&2
  exit 2
fi
echo "policy gate 2 passed: plan summary present"

if printf '%s\n' "$PLAN_TEXT" | grep -q 'No changes\.'; then
  echo "no changes planned; nothing to apply."
  exit 0
fi

echo "plan written to $PLAN_PATH; review it before applying."

if [[ "$AUTO_APPROVE" -eq 0 ]]; then
  echo "stopping before apply (pass --auto-approve to apply $PLAN_PATH)."
  exit 0
fi

echo "step 4/4: apply the reviewed plan file"
tofu -chdir="$WORKING_DIR" apply -input=false "$PLAN_FILE"
echo "apply finished for $WORKING_DIR"

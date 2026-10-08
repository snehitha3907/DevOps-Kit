#!/usr/bin/env bash
# last_verified: 2026-10-08 · Azure CLI (n/a)
#
# Purpose: delete leftover Azure resource groups that share a name prefix,
# skipping any group that carries a management lock. This is one way to
# automate cleanup of short-lived environments; the portal delete flow and
# deployment-stack cleanup cover the same ground for one-off cases.
#
# When to use: on a schedule or at the end of a test run, to remove groups
# named like rg-tmp-<something> that would otherwise linger and collect cost.
#
# Prerequisites: Azure CLI signed in (az login already done), and write
# permission on the subscription holding the groups.
#
# Usage:
#   NAME_PREFIX="rg-tmp-" ./resource-group-cleanup.sh          # lists only
#   NAME_PREFIX="rg-tmp-" CONFIRM=yes ./resource-group-cleanup.sh  # deletes
#
# Inputs (environment):
#   NAME_PREFIX  group name prefix to select (default: rg-tmp-)
#   CONFIRM      must be exactly "yes" for anything to be deleted
#
# Verify:
#   az group list --query "[].name" -o tsv | grep "^$NAME_PREFIX" || echo "clean"

set -euo pipefail

NAME_PREFIX="${NAME_PREFIX:-rg-tmp-}"
CONFIRM="${CONFIRM:-no}"

fail() {
  echo "ERROR: $1" >&2
  exit 1
}

echo "Selecting resource groups with prefix '$NAME_PREFIX'..."
CANDIDATES="$(az group list --query "[].name" -o tsv | grep "^${NAME_PREFIX}" || true)"

if [ -z "$CANDIDATES" ]; then
  echo "No resource groups match prefix '$NAME_PREFIX'. Nothing to do."
  exit 0
fi

echo "Candidates:"
echo "$CANDIDATES"

if [ "$CONFIRM" != "yes" ]; then
  echo "CONFIRM is not 'yes' — listing only, nothing deleted."
  echo "Re-run with CONFIRM=yes to delete the groups above."
  exit 0
fi

FAILED=0
DELETED=0
SKIPPED=0

while IFS= read -r GROUP; do
  [ -n "$GROUP" ] || continue

  # Skip groups protected by a management lock; deleting those is
  # almost always a mistake, so they stay until the lock is removed.
  LOCKS="$(az lock list --resource-group "$GROUP" --query "length(@)" -o tsv)" \
    || { echo "WARN: could not list locks for '$GROUP', skipping." >&2; SKIPPED=$((SKIPPED + 1)); FAILED=$((FAILED + 1)); continue; }

  if [ "$LOCKS" != "0" ]; then
    echo "Skipping locked group '$GROUP' ($LOCKS lock(s) present)."
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  echo "Deleting resource group '$GROUP'..."
  if az group delete --name "$GROUP" --yes --no-wait; then
    DELETED=$((DELETED + 1))
  else
    echo "WARN: delete request for '$GROUP' failed." >&2
    FAILED=$((FAILED + 1))
  fi
done <<< "$CANDIDATES"

# --- Verify ---
echo "Deleted: $DELETED, skipped (locked or unreadable): $SKIPPED, failed: $FAILED."
echo "Remaining groups with prefix '$NAME_PREFIX':"
az group list --query "[].name" -o tsv | grep "^${NAME_PREFIX}" || echo "(none)"

if [ "$FAILED" -ne 0 ]; then
  fail "$FAILED group(s) could not be processed."
fi

echo "Cleanup complete."

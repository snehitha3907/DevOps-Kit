#!/usr/bin/env bash
# pre-receive hook — integrity and quota enforcement
# Run on the server side before any refs are updated during a push.

set -uo pipefail

# -- Configuration -----------------------------------------------------------

MAX_REFS=100         # maximum number of refs in a single push
MAX_TOTAL_SIZE=1048576  # maximum total size change in bytes (1 MB)
REQUIRE_GPG_SIGNATURE=false  # set to true to enforce GPG-signed commits
GPG_KEY_ID=""        # optional: restrict to specific key ID

# -- Binary validation -------------------------------------------------------

if ! command -v git >/dev/null 2>&1; then
    echo "ERROR: git is not installed or not in PATH" >&2
    exit 1
fi

GIT_VERSION=$(git --version 2>&1 || true)
if [ -z "$GIT_VERSION" ]; then
    echo "ERROR: could not determine git version" >&2
    exit 1
fi

# -- Quota check: count inbound refs ---------------------------------------

REF_COUNT=0
TOTAL_SIZE=0

while IFS read -r oldrev newrev refname; do
    # Skip delete operations (newrev = 0000...0000)
    if [ "$newrev" = "0000000000000000000000000000000000000000" ]; then
        continue
    fi

    REF_COUNT=$((REF_COUNT + 1))
    if [ "$REF_COUNT" -gt "$MAX_REFS" ]; then
        echo "ERROR: push exceeds maximum ref limit of $MAX_REFS (received $REF_COUNT)" >&2
        exit 1
    fi

    # Compute the size change for this ref (new - old)
    # Use git rev-list to count objects between old and new
    SIZE=$(git rev-list --count "${oldrev}..${newrev}" 2>/dev/null || echo "0")
    TOTAL_SIZE=$((TOTAL_SIZE + SIZE))

    if [ "$TOTAL_SIZE" -gt "$MAX_TOTAL_SIZE" ]; then
        echo "ERROR: push total size change exceeds $MAX_TOTAL_SIZE bytes (got $TOTAL_SIZE)" >&2
        exit 1
    fi

    # -- GPG signature enforcement (optional) -------------------------------

    if [ "$REQUIRE_GPG_SIGNATURE" = true ] && [ -n "$GPG_KEY_ID" ]; then
        # Check if the push includes GPG-signed commits
        SIGNED_COUNT=$(git log --oneline --notes --remotes -E "$oldrev..$newrev" 2>/dev/null \
            | grep -c "\s$GPG_KEY_ID" || echo "0")
        if [ "$SIGNED_COUNT" -eq 0 ]; then
            echo "ERROR: push must include GPG-signed commits (key ID: $GPG_KEY_ID)" >&2
            exit 1
        fi
    fi

done

# If we got here, the push passes all checks
exit 0
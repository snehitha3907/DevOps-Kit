# last_verified: 2026-10-27 · Jenkins n/a

#!/bin/bash
# L1: Trigger my first Jenkins job via CLI (minimal example)
# Notes: Fill in JENKINS_URL, USER, API_TOKEN, JOB_NAME

JENKINS_URL="${JENKINS_URL:-http://localhost:8080}"
USER="${JENKINS_USER:-admin}"
API_TOKEN="${JENKINS_API_TOKEN:-REPLACE_ME}"
JOB_NAME="${JOB_NAME:-my-first-job}"

# Trigger a simple job (no parameters)
curl -s -X POST "${JENKINS_URL}/job/${JOB_NAME}/build" \
  --user "${USER}:${API_TOKEN}"

echo

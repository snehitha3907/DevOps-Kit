#!/usr/bin/env bash
# last_verified: 2026-09-20 - GitLab CI (n/a)
# I wanted to kick off a pipeline from my laptop and watch it without
# keeping the browser open, so I trigger it via the API and poll the jobs.
# Needs env vars: GITLAB_HOST (like gitlab.my-org.internal), GITLAB_TOKEN, PROJECT_ID.
# usage: ./2026-09-20-trigger-pipeline-and-poll-jobs.sh main

REF="${1:-main}"
# fire the pipeline for the given branch and grab its id
PIPE_ID=$(curl -s --request POST \
  --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
  "$GITLAB_HOST/api/v4/projects/$PROJECT_ID/pipeline?ref=$REF" \
  | grep -o '"id":[0-9]*' | head -1 | cut -d: -f2)
echo "pipeline id: $PIPE_ID"

# poll until every job stops running (tried sleep 10 first, too chatty, went with 15)
for i in $(seq 1 20); do
  sleep 15
  STATUSES=$(curl -s --header "PRIVATE-TOKEN: $GITLAB_TOKEN" \
    "$GITLAB_HOST/api/v4/projects/$PROJECT_ID/pipelines/$PIPE_ID/jobs" \
    | grep -o '"status":"[a-z_]*"' | sort -u)
  echo "attempt $i: $STATUSES"
  # not sure why running jobs sometimes report created first, so I check both
  case "$STATUSES" in
    *running*|*pending*|*created*) continue ;;
    *) echo "done: $STATUSES"; break ;;
  esac
done

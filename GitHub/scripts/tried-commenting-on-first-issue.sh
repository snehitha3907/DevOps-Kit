#!/bin/bash
# Comment on my first issue with GitHub CLI

gh issue comment "${1:-1}" --repo "${2:-$(gh repo view --json nameWithOwner --jq .nameWithOwner)}" --body "Learning gh — first comment!"

#!/bin/bash
# last_verified: 2026-07-13 · gh (GitHub CLI) 2.x
# Install the gh Actions extension and list my workflow runs

gh extension install gh-actions
gh workflow list
gh run list --limit 5

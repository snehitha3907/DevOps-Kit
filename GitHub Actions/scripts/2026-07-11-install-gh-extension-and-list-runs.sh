#!/bin/bash
# last_verified: 2026-07-11 · gh (GitHub CLI) 2.x
# Installs the gh Actions extension and lists my first workflow runs

gh extension install gh-actions
gh workflow list
gh run list --limit 5

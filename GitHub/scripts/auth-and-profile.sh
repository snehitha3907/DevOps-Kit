#!/bin/bash

# Log in to GitHub and poke around my profile

if ! command -v gh &> /dev/null; then
    echo "gh not found — install from https://cli.github.com"
    exit 1
fi

gh auth login --web -p ssh

echo "Logged in as: $(gh api user --jq .login)"
echo "Name: $(gh api user --jq .name)"
echo "Repos: $(gh api user/repos --jq 'length')"

#!/bin/bash
# tried-auth-and-profile.sh — first try at auth + profile with gh CLI

gh auth login --web -p ssh

echo "Logged in as: $(gh api user --jq .login)"
echo "Name: $(gh api user --jq .name)"
echo "Public repos: $(gh api user/repos --jq 'length')"
echo "Followers: $(gh api user --jq .followers)"

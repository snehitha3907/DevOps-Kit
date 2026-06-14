#!/bin/bash

# Authenticate with gh and explore my profile

gh auth login

echo "User:     $(gh api user --jq .login)"
echo "Name:     $(gh api user --jq .name)"
echo "Repos:    $(gh api user/repos --jq length)"
echo "Followers: $(gh api user --jq .followers)"
echo "Following: $(gh api user --jq .following)"

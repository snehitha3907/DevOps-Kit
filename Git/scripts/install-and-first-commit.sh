#!/bin/bash

# Try installing Git and making my first commit

if ! command -v git &> /dev/null; then
    echo "Git not found — installing..."
    sudo apt update && sudo apt install git -y
fi

echo "Git version: $(git --version)"

git config --global user.name "My Name"
git config --global user.email "me@example.com"

mkdir -p first-repo && cd first-repo || exit
git init

echo "# Hello Git" > README.md
git add README.md
git commit -m "first commit"

git log --oneline

#!/bin/bash
mkdir my-project && cd my-project || exit
git init

echo "# My Project" > README.md
git add README.md
git commit -m "initial commit: add README"

echo "console.log('hello')" > index.js
git add index.js
git commit -m "add index.js"

git log --oneline

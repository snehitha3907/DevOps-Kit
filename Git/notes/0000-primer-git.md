# Git — quick primer

> First-day notes for someone who's never used Git. Personal voice, plain language.

## What is it?

Git is a version control system — think of it like a save-game system for files, but way smarter. If you've ever renamed a file to `report_final_v3_really_final.docx`, you already know the problem Git solves. It tracks every change you make, lets you go back to any earlier state, and makes it possible for multiple people to work on the same files without stepping on each other's toes.

It was created by Linus Torvalds (same person who made Linux) because he needed something better than what existed at the time. It's now basically the standard for keeping track of code.

## What does it do?

Git takes snapshots of your files when you tell it to. You can look at what changed between snapshots, go back to an old snapshot, create parallel versions of your work (branches) to experiment without breaking anything, and share snapshots with other people. The core loop is: change files → stage the ones you want to save → commit them (make a snapshot).

## Why does it exist?

Before Git, version control existed but it was clunky. Centralized systems like SVN required a server to do anything useful — no internet, no version control. If the server died, you lost history. Git is distributed, meaning every person who clones a repo has the full history on their own machine. You can work offline, commit locally, and sync when you're back online. It's built for collaboration: multiple people can fork a project, make changes, and merge them back together.

Day-to-day users are basically anyone who writes code — solo devs, open-source contributors, enterprise teams, even docs writers.

## Key terminology

- **Repository (repo)** — A folder that Git is watching. It contains all the files and the full change history. Example: `git init` creates a new repo.
- **Commit** — A snapshot of your files at a point in time. Every commit has a hash (like `a1b2c3d`). Example: `git commit -m "added login button"`.
- **Stage (index)** — The area where you prepare what goes into the next commit. You add files here before committing. Example: `git add file.py` moves `file.py` to staged.
- **Branch** — A separate line of development. The default branch is called `main` (or `master` in older repos). Example: `git branch experiment` creates a branch called `experiment`.
- **Clone** — Copy a remote repo to your machine. Example: `git clone https://github.com/user/repo.git`.
- **Push / Pull** — Push sends your commits to a remote repo; pull fetches someone else's commits. Example: `git push origin main`.
- **Merge** — Combine changes from one branch into another. Example: `git merge feature-x` pulls `feature-x` into your current branch.
- **Diff** — Shows what changed between two commits or between your working files and the last commit. Example: `git diff` shows unstaged changes.
- **Remote** — A URL pointing to another copy of the repo, usually hosted on GitHub or GitLab. Example: `git remote add origin https://github.com/user/repo.git`.
- **`HEAD`** — A pointer to the commit you're currently on (the latest commit on your current branch). Example: `HEAD~1` means "one commit before HEAD".

## A tiny example

```bash
mkdir hello-git && cd hello-git
git init
echo "Hello, Git!" > README.md
git add README.md
git commit -m "first commit"
```

This creates a new repo, adds one file, stages it, and commits. After those five commands you have a real repo with one commit in history.

## What I'll cover next

Now that I know what Git is, I want to actually install it and use it on my own machine. After that I'll work through staging, committing, and inspecting changes — the basic cycle I'll use every day.

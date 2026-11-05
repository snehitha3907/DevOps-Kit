---
last_verified: 2026-11-04
tool_version: "n/a"
---

# Branch, merge and rebase

You now have a sample app under version control with a small, readable history. The next step is to work on parallel lines of development without breaking the main line. In this lesson you will create a feature branch, merge it back, rebase a branch onto a moving main branch, and resolve a merge conflict when two branches change the same lines.

## What you'll learn

- Work on a feature branch and merge it back into the main branch
- Rebase a branch onto main and explain how the history differs from a merge
- Resolve a merge conflict when branches change the same lines

## Before you start

- [Put the sample app under version control](03-git-sample-app-repo.md) — a Git repository with a few commits on `main` to branch from
- Git installed. Confirm with `git --version`.

## Walkthrough

1. Create a practice repository with two commits on `main`.

   ```bash
   cd /tmp
   rm -rf git-merge-lab && mkdir git-merge-lab && cd git-merge-lab
   git init -b main
   echo "# Feature Lab" > README.md
   git add README.md && git commit -m "initial commit"
   echo "print('base')" > app.py
   git add app.py && git commit -m "add app.py"
   git log --oneline
   ```

   You should see: two commits on `main`, newest first. `git init -b main` names the initial branch `main` so you do not depend on Git's default branch name.

2. Create a feature branch and do work on it.

   ```bash
   git checkout -b feature/add-greeting
   echo "def greet():" >> app.py
   echo '    return "hello"' >> app.py
   git add app.py && git commit -m "add greet function"
   git log --oneline --graph --all
   ```

   You should see: `feature/add-greeting` ahead of `main`, with the new commit only on the feature branch. A branch is just a movable pointer to a commit — creating one does not copy your files.

3. Switch back to `main` and merge the feature branch in.

   ```bash
   git checkout main
   git merge feature/add-greeting
   git log --oneline --graph
   ```

   You should see: `main` now points at the same commit as the feature branch. Because `main` had no new commits while you worked, Git performs a fast-forward merge — no merge commit, history stays a single straight line.

4. Create diverging branches so a real merge commit is needed.

   ```bash
   git checkout -b feature/alt-greeting HEAD~1
   echo "def farewell():" >> app.py
   echo '    return "goodbye"' >> app.py
   git add app.py && git commit -m "add farewell function"
   git checkout main
   echo "# Updated" >> README.md
   git add README.md && git commit -m "update readme"
   git merge feature/alt-greeting -m "merge alt-greeting into main"
   git log --oneline --graph --all
   ```

   You should see: `main` and `feature/alt-greeting` diverged, and the merge produced a merge commit with two parents. The graph now shows the branches splitting and rejoining — this is what a non-fast-forward merge looks like.

5. Rebase a feature branch onto updated `main` for a linear history.

   ```bash
   git checkout -b feature/rebase-test
   echo "def ping():" >> app.py
   echo '    return "pong"' >> app.py
   git add app.py && git commit -m "add ping function"
   git checkout main
   echo "another main change" >> README.md
   git add README.md && git commit -m "main before rebase"
   git checkout feature/rebase-test
   git rebase main
   git log --oneline --graph --all
   ```

   You should see: Git temporarily lifts your feature commits, replays `main`'s new commits, then reapplies your commits on top. The result is a straight line — no merge commit — unlike the merge in step 4, which kept the branch structure visible with a merge commit.

6. Create and resolve a merge conflict.

   ```bash
   git checkout -b feature/conflict-test
   echo "line changed on the feature branch" >> README.md
   git add README.md && git commit -m "change readme on feature"
   git checkout main
   echo "line changed on main" >> README.md
   git add README.md && git commit -m "change readme on main"
   git merge feature/conflict-test
   ```

   You should see: Git reports a conflict in `README.md` and stops the merge. Open `README.md` — you will see conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) showing the version from each side.

   Edit `README.md` to keep the text you want and remove the markers, then:

   ```bash
   git add README.md
   git commit
   git log --oneline --graph --all
   ```

   You should see: the conflict is resolved with a merge commit, and both branches are now joined.

## Exercise

Work in your own copy of the lab repo (not the course's):

1. Create a feature branch off `main`, make at least one commit on it, switch back to `main`, and merge the feature branch in.
2. Create a second feature branch, advance `main` with a separate commit, then rebase the feature branch onto `main`. Confirm the history is a single straight line with `git log --oneline --graph --all`.
3. Create two branches that each change the same line of the same file, then merge one into the other. Resolve the conflict, remove the markers, and complete the merge.

Do not copy the solution; the point is the practice.

## Check your work

Run these and confirm the results:

```bash
git log --oneline --graph --all
git status
```

You should see: all feature branches merged into `main`, a history graph that shows where branches split and rejoined, and `git status` reporting `nothing to commit, working tree clean`. If `git status` shows uncommitted changes, commit or stash them before finishing.

## Common mistakes

- Forgetting to switch to the branch you want to merge *into* before running `git merge`. Always `git checkout main` first, then `git merge feature/...`.
- Rebasing a branch that others have already pulled — rebasing rewrites history, so only rebase branches you are working on alone.
- Leaving conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) in the file and committing them. Resolve, remove every marker, then stage and commit.
- Trying to merge with uncommitted changes in the way. Commit or `git stash` them first.

## Next

[Undo mistakes and recover lost work](05-git-recover-reflog.md)
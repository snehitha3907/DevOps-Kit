---
last_verified: 2026-11-05
tool_version: "2.56.0"
sources:
  - https://git-scm.com/docs/git-branch
  - https://git-scm.com/docs/git-merge
  - https://git-scm.com/docs/git-rebase
---

# Undo mistakes and recover lost work

You have a small, readable history on a feature branch and on `main`. Mistakes happen: a commit you did not mean to make, a file you deleted, a branch you removed. In this lesson you will choose the right undo tool for each situation and recover a deleted branch from Git's reflog.

## What you'll learn

- Choose between restore, revert and reset for a given mistake
- Recover a deleted branch with reflog

## Before you start

- [Branch, merge and rebase](04-git-branch-merge-rebase.md) — a Git repository with a few commits on `main` to branch from
- Git installed. Confirm with `git --version`.

## Walkthrough

1. Set up a practice repository with two commits on `main`.

   ```bash
   cd /tmp
   rm -rf git-recover-lab && mkdir git-recover-lab && cd git-recover-lab
   git init -b main
   echo "# Recover Lab" > README.md
   git add README.md && git commit -m "initial commit"
   echo "print('base')" > app.py
   git add app.py && git commit -m "add app.py"
   git log --oneline
   ```

   You should see: two commits on `main`, newest first.

2. Make an unwanted change to a tracked file, then undo it with `restore`.

   ```bash
   echo "print('oops')" >> app.py
   git status
   git restore app.py
   git diff
   ```

   You should see: `git status` shows `app.py` modified; after `git restore`, `git diff` is empty and the file is back to its committed version. `restore` discards working-tree changes for tracked files without touching history.

3. Commit a mistake, then undo it with `revert`.

   ```bash
   echo "print('bad')" >> app.py
   git add app.py && git commit -m "bad change"
   git revert --no-edit HEAD
   git log --oneline
   ```

   You should see: a new commit whose message starts with `Revert "bad change"`, and `app.py` no longer contains `bad`. `revert` adds a new commit that undoes an earlier one — safe to use on shared history.

4. Undo the last commit locally with `reset`.

   ```bash
   git reset --hard HEAD~1
   git log --oneline
   ```

   You should see: the `Revert` commit is gone and `HEAD` points at `add app.py`. `reset --hard` moves the branch pointer and discards the working tree; use it only for commits that have not been pushed.

5. Delete a branch and recover it with the reflog.

   ```bash
   git checkout -b feature
   echo "print('feature')" >> app.py
   git add app.py && git commit -m "feature work"
   git checkout main
   git branch -D feature
   git reflog
   ```

   You should see: the reflog lists recent `HEAD` movements, including the commit hash where `feature` pointed before deletion. Note that hash.

   ```bash
   git branch feature <hash>
   git log --oneline feature
   ```

   You should see: `feature` exists again and its history includes `feature work`. The reflog keeps unreachable commits reachable for a grace period, which is what makes recovery possible.

## Exercise

In the `git-recover-lab` repository, create a branch `experiment`, make two commits on it, then delete the branch. Recover the branch using only `git reflog` and `git branch`. Verify with `git log --oneline experiment` that both commits are present.

## Check your work

Run `git log --oneline experiment` in `git-recover-lab`. You should see exactly two commits on top of the base history, newest first, proving the branch and its work were recovered.

## Common mistakes

- Using `reset --hard` on commits already pushed to a shared branch rewrites public history and breaks collaborators. Prefer `revert` for shared commits.
- `restore` only affects tracked files; a brand-new untracked file needs `rm` (or `git clean`) to remove.
- `reflog` entries expire (default 90 days for reachable commits, 30 for unreachable), so recover promptly.

## Next
[Pull requests and branch protection on GitHub](../../00_index/learning-path.md)
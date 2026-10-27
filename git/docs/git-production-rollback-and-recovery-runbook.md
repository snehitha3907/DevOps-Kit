---
last_verified: 2026-10-27
tool_version: n/a
sources: ---
# Git — production rollback and recovery runbook

## Purpose

This document provides a comprehensive guide for rolling back Git state and recovering from common production incidents. It is intended for teams operating Git in production environments who need documented, repeatable procedures for undoing changes, restoring lost commits, and recovering from operational errors.

## When to use

- Accidental commit of sensitive data or secrets that cannot be removed from history
- Malicious or erroneous code pushed to a protected branch that requires immediate reversal
- Repository corruption or lost commits due to crashed `git gc`/`prune` operations
- Accidental force push that rewrote shared history and broke downstream clones
- Need to restore a previous stable state after a faulty deployment or configuration change

## Prerequisites

- Write access to the remote repository (or `rewrite` access if using Git server with ACLs)
- `git` installed and available in PATH (`git --version` must return a supported version)
- Remote repository backup confirmed — verify the remote still contains the target commit before starting
- `git reflog` enabled and accessible (default in standard `git` builds)
- Communication plan for notifying team members of the rollback window
- `git bundle` available for creating offline snapshots if the remote is temporarily unreachable

## Steps

### 1. Identify the target commit

```bash
# View the recent reflog to find the commit hash you want to return to
git reflog

# Or view the log for the specific branch
git log --oneline <branch-name>
```

Note the commit hash of the desired state. The reflog shows local reference history even if the remote has changed.

### 2. Create a safety branch

```bash
git checkout -b rollback-safety <commit-hash>
```

This branch pinned to the target commit prevents you from losing your place while working on the rollback.

### 3. For a public branch (non-force push scenario)

```bash
# Merge the target commit into the current branch
git merge <commit-hash>

# Or cherry-pick specific commits
git cherry-pick <commit-hash>
```

Resolve any conflicts that arise, then push the resolved state:

```bash
git push origin <branch-name>
```

### 4. For a protected/branch that was force-pushed

```bash
# If the original commit is still reachable via reflog
git fetch origin
git checkout -b recovery-branch origin/<branch-name>
git reflog --all | head -20

# Reset the branch to the known-good commit
git reset --hard <commit-hash>
git push origin <branch-name> --force-with-lease
```

**⚠️ Warning:** `--force-with-lease` is safer than `--force` as it refuses to update if the remote has new commits since your last fetch.

### 5. Verify the rollback

```bash
# Confirm the branch now points to the correct commit
git log --oneline HEAD | head -5

# Run your test suite or smoke test against the restored state

# Verify no sensitive data remains if that was the rollback trigger
git log --all --grep="<search-term>" --oneline
```

### 6. Notify the team

Update the team channel, issue tracker, or project board to reflect the rollback. Document the commit hash, time, and reason in the incident record.

## Rollback

| Scenario | Command | Notes |
|---|---|---|
| Return to previous commit on current branch | `git reset --hard <commit-hash>` | Destroys working directory changes — commit or stash first |
| Undo the last commit, keep changes staged | `git reset --soft HEAD~1` | Keeps files in the staging area |
| Undo the last commit, keep changes in working tree | `git reset HEAD~1` | Changes are unstaged but present |
| Recover a commit lost from all refs | `git reflog --all` → note hash → `git reset --hard <hash>` | Only works if the object hasn't been garbage collected |
| Recover from a bad merge | `git merge --abort` | Abort before the merge commit is created |

## Common errors

| Error | Cause | Fix |
|---|---|---|
| `fatal: refusing to merge unrelated histories` | Attempting to merge branches with completely different roots | Use `git merge --allow-unrelated-histories` |
| `fatal: not possible to fast-forward` | Merge creates a merge commit instead of moving the branch pointer | Use `git merge --ff-only` for pure fast-forward, or `--no-ff` to force a merge commit |
| `error: failed to push some refs` | Remote has new commits since last fetch | Run `git fetch` first, then re-attempt the push |
| `local changes would be overwritten by reset` | `git reset --hard` with unstaged or uncommitted changes | `git stash` or `git commit` before resetting |
| `refs/reflog/0 not found` | Reflog entries have been garbage collected | Recovery may not be possible — ensure local backups are regular |

## References

- Pro Git Book — Chapter 5: [Distributed Git](https://git-scm.com/book/en/v2/Distributed-Git-Working-With-Remotes)
- Git Documentation — [git-reset](https://git-scm.com/docs/git-reset), [git-reflog](https://git-scm.com/docs/git-reflog), [git-restore](https://git-scm.com/docs/git-restore)
- Atlassian Git Tutorials — [Undoing changes](https://www.atlassian/git/tutorial/undoing-changes)
- GitHub Docs — [Recovering a deleted branch](https://docs.github.com/en/repositories/working-with-files-and-folders/d managing-large-files-recovering-a-deleted-file)
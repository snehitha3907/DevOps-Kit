# Git Worktrees for Parallel Feature Development

## Purpose

Git worktrees allow multiple working directories attached to the same repository. This enables parallel development on different branches without the overhead of cloning multiple copies or the context-switching friction of branch hopping.

## When to use

Use worktrees when you need to:
- Work on multiple features simultaneously without stashing or committing incomplete changes
- Test changes across branches while keeping work in progress
- Share dependency builds across branches (node_modules, target directory, etc.)
- Run long-lived branch comparisons or integration tests side by side

## Prerequisites

- Git 2.5 or later (worktrees were introduced in Git 2.5)
- Existing repository with at least two branches to work on
- Understanding of basic branching concepts

## Steps

### 1. Create a worktree for a new branch

```bash
git worktree add <path> [-b <new-branch>] <base-branch>
```

Example creating a feature branch from main:

```bash
git worktree add ../feature-login -b feature-login main
```

This creates a new directory `feature-login` with a worktree checked out to a new branch.

### 2. List existing worktrees

```bash
git worktree list
```

Output shows all worktrees with their paths and current branch:

```
/home/user/project               (bare)
/home/user/project-feature-login /home/user/project (feature-login)
```

### 3. Add worktree for existing branch

```bash
git worktree add ../hotfix-urgent hotfix/critical
```

Creates a worktree at `../hotfix-urgent` pointing to the existing `hotfix/critical` branch.

### 4. Remove a worktree

```bash
git worktree remove ../feature-login
```

This removes the worktree directory. Use `--force` if there are uncommitted changes.

To clean up all removed worktrees:

```bash
git worktree prune
```

### 5. Lock a worktree (optional)

Prevent accidental removal of important worktrees:

```bash
git worktree lock ../production-config
```

## Verify

Check worktree state after operations:

```bash
# Verify clean state
git worktree list

# Check branch content in each worktree
(cd ../feature-login && git branch --show-current)
(cd ../hotfix-urgent && git branch --show-current)
```

## Common errors

- **Worktree path already exists**: Remove the directory first or choose a different path
- **Branch already checked out**: Cannot add a worktree for a branch already active; remove the other worktree first
- **Uncommitted changes on remove**: Use `git worktree remove --force` or commit/stash changes first
- **Merge conflicts across worktrees**: Resolve in each worktree separately; worktrees don't interfere but conflicts surface independently

## References

- [git-worktree(1)](https://git-scm.com/docs/git-worktree)
- [Understanding Git Worktrees](https://git-scm.com/book/en/v2/Git-Tools-Worktrees)
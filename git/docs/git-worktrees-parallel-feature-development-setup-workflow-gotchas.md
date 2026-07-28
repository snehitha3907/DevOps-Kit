---
last_verified: 2026-07-28
tool_version: n/a
---

# Git worktrees for parallel feature development

## Purpose

`git worktree` allows checking out multiple branches into separate directories from a single repository. Each worktree has its own working tree, index, and unstaged changes, while sharing the same object database and configuration as the primary repository. This eliminates the need to stash, switch branches, or rebuild dependencies when working on parallel feature branches.

## When to use

- Running two features simultaneously (e.g., `feature/payment` and `feature/auth`) without cloning the repository twice.
- Maintaining a long-running `main` or `develop` checkout alongside a feature branch, so both can be built and tested independently.
- Comparing behavior between branches side by side with different dependency states or configuration files.

## Prerequisites

- Git 2.5 or later (worktrees were introduced in Git 2.5).
- A local Git repository to work with.
- Sufficient disk space; each worktree is a lightweight checkout that shares objects with the primary repo.

## Steps

### 1. List existing worktrees

```bash
git worktree list
```

This displays the path, branch, and HEAD commit for each worktree attached to the repository. On a fresh clone with no worktrees created yet, the output shows only the primary working tree.

### 2. Create a new worktree for a feature branch

```bash
git worktree add ../feature-x feature-x
```

This creates a directory `../feature-x`, checks out the `feature-x` branch, and links it to the original repository's `.git` directory. The branch is created if it does not already exist.

To create the branch explicitly at `HEAD`:

```bash
git worktree add ../feature-x -b feature-x
```

### 3. Work in parallel across worktrees

Each worktree has its own working directory, index, and staging area. Commits made in one worktree are immediately visible in the other worktree's `git log` because they share the same object store.

```bash
# In the feature-x worktree
cd ../feature-x
git commit -m "implement feature X"

# In the primary worktree
git log --oneline -3  # the commit now appears here too
```

### 4. Remove a worktree when finished

```bash
git worktree remove ../feature-x
```

This command fails if the worktree has uncommitted changes. Commit or stash changes before removal, or use `git worktree remove --force` to discard them.

### 5. Prune stale worktree references

If a worktree directory was deleted manually without using `git worktree remove`, the repository still tracks the stale reference:

```bash
git worktree prune
```

This cleans up the metadata for worktrees whose directories no longer exist.

## Verify

```bash
git worktree list
```

Expected output format:

```
/path/to/repo          abc1234 [main]
/path/to/feature-x     def5678 [feature-x]
```

Each line shows the worktree path, the latest commit hash, and the checked-out branch name enclosed in brackets.

## Common errors

**`fatal: 'feature-x' is already checked out at '...'`**

The branch already has an existing worktree. Either use the existing worktree or remove it first with `git worktree remove`.

**`fatal: '<path>' is not a valid path`**

The target directory must either not exist or be completely empty. Remove or rename any conflicting directory before creating the worktree.

**`fatal: '<path>' already exists`**

The target path contains files. Delete the directory or choose a different path for the worktree.

**Submodule operations behave unexpectedly**

Worktrees inherit the parent repository's submodule state. Running submodule update commands inside a worktree can modify the parent's submodule index. Run submodule commands from the primary working tree when possible.
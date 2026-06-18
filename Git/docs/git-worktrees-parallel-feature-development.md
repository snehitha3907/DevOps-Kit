# git worktrees for parallel feature development

## Purpose

When working on multiple feature branches at the same time, switching between them forces a full rebuild of tooling dependencies, restarting dev servers, and re-stashing uncommitted work. `git worktree` lets me check out multiple branches simultaneously in separate directories, each with its own working tree. No switching, no stashing, no context loss.

## Prerequisites

- Git 2.5+ (worktree was introduced in 2.5)
- A Git repository you're comfortable experimenting in

## Steps

### 1. Check what worktrees already exist

```bash
git worktree list
```

On a fresh clone this shows only the main working tree, typically at the repo root.

### 2. Add a worktree for a new branch

```bash
git worktree add ../my-project-feature-x feature-x
```

This creates a directory `../my-project-feature-x`, checks out `feature-x` (creating it if it doesn't exist yet), and links it back to the original `.git` directory. Both worktrees share the same objects, refs, and config.

If the branch doesn't exist yet and I want it created from HEAD:

```bash
git worktree add ../my-project-feature-x -b feature-x
```

### 3. Work in both trees simultaneously

In terminal 1:
```bash
cd ../my-project-feature-x
# edit, commit, push on feature-x
```

In terminal 2:
```bash
cd ../my-project
# work on a different branch like main or another feature
```

Both have their own index, staging area, and working tree. Commits in one are immediately visible in the other's `git log` since they share the same object store.

### 4. Remove a worktree when done

```bash
git worktree remove ../my-project-feature-x
```

This fails if there are uncommitted changes or dirty files. I've hit this a few times. Running `git worktree remove --force` is possible but there's a better approach — check the status and commit or stash before removing.

### 5. Prune stale worktree references

If a worktree directory was deleted manually (without `git worktree remove`), the `.git` directory still tracks it:

```bash
git worktree prune
```

This cleans up the stale metadata.

## Verify

```bash
# Show branch-to-directory mapping
git worktree list

# Expected output:
# /path/to/main-repo       main     abc1234 [main]
# /path/to/feature-x       feature-x def5678 [feature-x]
# /path/to/feature-y       feature-y 7890abc [feature-y]
```

Each worktree shows its path, checked-out branch, and latest commit.

## Common errors

**"fatal: 'feature-x' is already checked out at '...'"**
Trying to check out a branch that already has a worktree. Solution: use the existing worktree, or delete it first with `git worktree remove`.

**"fatal: '<path>' is not a valid path"**
The target directory must either not exist or be empty. Solution: specify a path that doesn't already contain files.

**"fatal: '<path>' already exists"**
Worktree creation fails if the target path already has content. Solution: delete the directory first or pick a different name.

**Submodule confusion**
Worktrees inherit the parent repo's submodule state, but submodule operations inside a worktree can behave differently. I had a case where `git submodule update` in a worktree modified the parent's submodule index. The fix is to run submodule commands from the primary working tree when possible.

## References

- [git worktree docs](https://git-scm.com/docs/git-worktree)
- [Git worktree blog post](https://www.atlassian.com/git/tutorials/git-worktree)

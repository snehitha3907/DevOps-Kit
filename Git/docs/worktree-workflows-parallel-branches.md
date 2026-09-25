---
last_verified: 2026-09-25
tool_version: n/a
---

# Worktree workflows: parallel branches without stash juggling

## Purpose

A linked worktree is an additional working tree attached to one repository. Each worktree checks out its own branch with its own index and working files while sharing a single object store. This guide defines a repeatable layout — one central checkout plus one worktree per active branch — so developers can switch context by changing directories instead of stashing, committing half-finished work, or re-cloning.

## When to use

- Two or more branches are active at once (feature work plus review fixes plus a hotfix) and stashing between them causes lost or misapplied changes.
- A long-running task (test suite, build, bisect session) occupies one working tree while editing continues elsewhere.
- A reviewer needs the exact state of a pull-request branch without disturbing local work in progress.
- Prefer a fresh clone instead when the branches need different remote configurations, different file-system permissions, or fully isolated garbage collection.

## Prerequisites

- Git installed with worktree support and a repository the reader can experiment in.
- Agreement on where worktrees live: either sibling directories of the main checkout or a dedicated parent directory, kept consistent across the team.
- Hooks and helper scripts must resolve paths relative to the current worktree root, not to a hard-coded checkout path (see Common errors).

## Steps

### 1. Adopt a central checkout with linked worktrees

Keep the main clone as the administrative center. Create one directory per active branch beside it:

```bash
git worktree add ../repo-hotfix hotfix/login-timeout
git worktree add ../repo-feature -b feature/sso-login main
git worktree list
```

The first command attaches the existing branch `hotfix/login-timeout` at `../repo-hotfix`. The second creates `feature/sso-login` from `main` and attaches it at `../repo-feature`. A branch may only be checked out in one worktree at a time; attempting a second checkout of the same branch is refused.

### 2. Work in each tree independently

Each worktree has its own staging area and working files. Edit, stage, and commit in `../repo-feature` while tests run in the main checkout; commits land in the shared object store and are immediately visible from every tree via `git log --all`. No stash entries are created by moving between trees because nothing needs to be shelved — the unfinished work simply stays in its own directory.

### 3. Lock worktrees that must survive maintenance

Administrative cleanup (`git worktree prune`, and garbage collection that drops stale worktree metadata) skips locked worktrees. Mark trees holding unpushed or irreplaceable work:

```bash
git worktree lock ../repo-feature
git worktree lock --reason "holds unpushed release notes" ../repo-hotfix
```

Unlock when the branch merges or the tree is removed.

### 4. Maintain the roster: move, repair, prune

Directories get renamed and disks get reorganized. Three subcommands keep the roster accurate:

```bash
git worktree move ../repo-feature ../archive/repo-feature
git worktree repair
git worktree prune
```

`move` relocates a worktree and updates its administrative link in one step — preferable to a raw filesystem move, which orphans the link. `repair` re-links worktrees whose directories were moved behind Git's back. `prune` deletes administrative entries for worktrees that no longer exist on disk. Run `git worktree list --porcelain` after any of these to confirm the roster matches reality.

### 5. Retire a worktree when its branch lands

```bash
git worktree remove ../repo-hotfix
```

Removal deletes the working tree directory and unregisters it. It is refused when the tree holds uncommitted changes or untracked files that would be lost; commit, move, or explicitly accept the loss before retrying (see Rollback).

## Verify

- `git worktree list` shows exactly the expected paths and branches, with no entries pointing at deleted directories.
- `git status` inside each surviving tree reports a clean tree on the intended branch.
- `git log --all --oneline --graph` from the central checkout shows commits made inside every worktree.
- After prune, `git worktree list --porcelain` contains no stale entries.

## Rollback

Worktree operations are reversible in the following order:

1. An unwanted `add` is undone with `git worktree remove <path>`; nothing in other trees is affected.
2. A `remove` executed with uncommitted work cannot be un-deleted by Git — recover the files from the branch only if they were committed or stashed beforehand. This is why Step 5 refuses dirty trees: treat the refusal as protection, not friction.
3. A filesystem move performed without `git worktree move` is recovered with `git worktree repair [<path>]`, which re-establishes the administrative link instead of requiring re-creation.
4. An over-eager `prune` that dropped a live entry is recovered by re-adding the worktree at the same path; the branch data itself was never deleted, only the registration.

## Common errors

- **Same branch checked out twice.** Git refuses to attach a branch that another worktree already has checked out. Attach the existing tree's directory instead, or create a new branch from it.
- **Remove refused over dirty files.** `git worktree remove` stops when uncommitted or untracked content would be destroyed. Commit or relocate the files first; reserve `--force` for trees whose contents are provably disposable.
- **Hooks assuming one checkout path.** Linked worktrees share the main repository's hooks, so a hook with a hard-coded directory breaks in every linked tree. Write hooks against the current worktree root.
- **Stale entries after deleting directories by hand.** Removing a worktree directory with a plain delete leaves its registration behind. Run `git worktree prune` and confirm with `git worktree list`.
- **Dependency directories leaking across trees.** Build outputs inside the tree (test caches, compiled artifacts) belong to one branch's state and can confuse the other tree's tooling. Either keep them untracked per tree or point each tree at its own output directory.

## References

- [Git workflows comparison: feature branch vs GitFlow vs trunk-based development](git-workflows-comparison.md) — choosing which branches deserve a worktree in the first place.
- [Git Worktrees for Parallel Feature Development](git-worktrees-parallel-development.md) — the introductory pass over creating and listing worktrees.

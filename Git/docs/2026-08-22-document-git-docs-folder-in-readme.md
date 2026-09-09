---
last_verified: 2026-08-23
tool_version: n/a
sources: []
---

# Document Git/docs/ folder in README Layout

I noticed the README Layout entry for Git/ lists "docs" as a bullet but doesn't say what's actually inside `Git/docs/`. There are five files in there: a bisect automation guide, three worktrees walkthroughs, and a workflows comparison. They were invisible in the repo's own navigation.

## What I changed

1. **README Layout** — Replaced the bare `docs` mention with `docs (bisect automation, three worktrees walkthroughs, and workflows comparison)` in the Git/ entry.

## What's in Git/docs/

- `automating-git-bisect-with-scripted-regression-tests.md` — scripted bisect workflow for narrowing regressions.
- `git-workflows-comparison.md` — compares trunk-based, GitFlow, and GitHub Flow.
- `git-worktrees-parallel-development.md` — using worktrees for parallel feature work.
- `git-worktrees-parallel-feature-development-setup-workflow-gotchas.md` — setup steps and gotchas.
- `git-worktrees-parallel-feature-development.md` — worktree workflow for feature branches.

That's it. The Layout entry now matches the five files on disk.

---
last_verified: 2026-08-04
tool_version: n/a
---

# git/ folder README coverage

I noticed the README Layout and Coverage table only list `Git/` (capital G) — the older full-content folder — but not `git/` (lowercase), the leaner companion folder. So the git/ folder was invisible in the repo's own navigation.

## What's in git/

I ran `find git/` and found three subfolders:

- `git/docs/` — one markdown doc on automating git bisect with scripted regression tests
- `git/notebooks/` — one notebook (`comparing-git-merge-strategies.ipynb`) that compares merge commit, rebase, squash, and cherry-pick across feature, release, and hotfix topologies
- `git/templates/git-repo-scaffold/` — a repo scaffold template with `.gitignore`, `release-please-config.json`, `CONTRIBUTING.md`, and hook templates

## What I added to the README

1. **Layout section** — Added a `git/` entry right after `Git/`, describing the docs, notebook, and scaffold template.
2. **Coverage table** — Added a `git` row: Docs 1, Notebooks 1, Templates 1, the rest —. Last verified 2026-08-04.

The merge-strategies notebook is the flagship content — it already gets a quick-link entry, but the Layout and Coverage table didn't mention git/ at all.

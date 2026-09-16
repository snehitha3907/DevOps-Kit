---
last_verified: 2026-09-16
tool_version: n/a
sources:
  - https://github.com/snehitha3907/DevOps-Kit
---
# Git Coverage Correction

> Documentation correction for Git notes, docs, and templates counts in README coverage table and topics.md.

## What was corrected

The README coverage table showed:
- Git Notes = 8 (actual: 5 markdown files in Git/notes/)
- Git Docs = 11 (actual: 8 markdown files in Git/docs/)
- Git Templates = 17 (actual: 10 files in Git/templates/)

The topics.md showed:
- Git total files = 53
- Git templates = 17 ("14 more")
- Git docs = 11 ("8 more")
- Git notes = 8 ("5 more")

## Changes made

- README.md coverage table: Git Notes 8 → 5, Docs 11 → 8, Templates 17 → 10, Last verified 2026-08-25 → 2026-09-16
- 00_index/topics.md: Git total files 53 → 39, templates 17 → 10 ("14 more" → "7 more"), docs 11 → 8 ("8 more" → "5 more"), notes 8 → 4 ("5 more" → "1 more")

## Verification

Actual files in Git/notes/ (markdown only):
- 0000-primer-git.md
- 2026-06-04-explore-git-cli.md
- 2026-06-04-install-git.md
- 2026-06-07-git-branching-tutorial.md
- 2026-08-11-git-branching-tutorial.md
Total: 5 markdown files (excluding README.md, file.py, readme.md)

Actual files in Git/docs/ (markdown only):
- 2026-08-04-git-folder-readme-coverage.md
- 2026-08-22-document-git-docs-folder-in-readme.md
- automating-git-bisect-with-scripted-regression-tests.md
- git-workflows-comparison.md
- git-worktrees-parallel-development.md
- git-worktrees-parallel-feature-development-setup-workflow-gotchas.md
- git-worktrees-parallel-feature-development.md
- wiring-git-hooks-into-pre-commit-workflow.md
Total: 8 markdown files

Actual files in Git/templates/:
- git-hooks/pre-commit
- git-hooks/commit-msg
- git-repo-scaffold/hooks/pre-commit
- git-repo-scaffold/hooks/commit-msg
- git-repo-scaffold/CONTRIBUTING.md
- git-repo-scaffold/README.md
- git-repository-skeleton/CONTRIBUTING.md
- git-repository-skeleton/.githooks/pre-commit
- git-repository-skeleton/.githooks/commit-msg
- git-repository-skeleton/README.md
Total: 10 files
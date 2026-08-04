---
last_verified: 2026-08-04
tool_version: n/a
sources: []
---

# Git Repository Scaffold

A reusable skeleton for initializing new Git repository projects with conventional commits, pre-commit hooks, and release-please automation.

## Purpose

This scaffold provides a ready-to-use Git repository structure that enforces conventional commit messages, runs basic validation checks via hooks, and configures release-please for automated release management. Use it as a starting point for any new Git-hosted project.

## When to use

Use this scaffold when initializing a new repository that requires:

- Conventional commit message enforcement
- Pre-commit and commit-msg hook validation
- Automated release management via release-please

## Prerequisites

- Git installed and available on `PATH`
- A GitHub repository with release-please enabled (for release automation)

## Steps

1. Copy the contents of this scaffold into a new directory:

   ```bash
   cp -r git-repo-scaffold/ my-new-project/
   ```

2. Initialize the Git repository and make the initial commit:

   ```bash
   cd my-new-project
   git init
   git add .
   git commit -m "chore: initial scaffold commit"
   ```

3. Set the remote origin and push:

   ```bash
   git remote add origin <repository-url>
   git push -u origin main
   ```

4. Install the hooks by copying them to `.git/hooks/`:

   ```bash
   cp hooks/pre-commit .git/hooks/pre-commit
   cp hooks/commit-msg .git/hooks/commit-msg
   chmod +x .git/hooks/pre-commit .git/hooks/commit-msg
   ```

## Verify

- Run `git commit` with a test message to confirm the commit-msg hook validates the format.
- Run `git add` and `git commit` to confirm the pre-commit hook executes without errors.
- Check that `release-please-config.json` is present in the repository root.

## Common errors

- **Hook not executable**: If hooks are not executable, Git will ignore them. Run `chmod +x .git/hooks/<hook-name>` to fix.
- **Commit message rejected**: The commit-msg hook enforces the `type(scope): description` format. Ensure the message matches a valid conventional commit type.
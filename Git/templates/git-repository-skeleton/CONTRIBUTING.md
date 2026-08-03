---
last_verified: 2026-08-01
tool_version: n/a
sources: []
---

# Contributing

## Purpose

This document defines the contribution workflow for this repository. It establishes conventions for commit messages, code review, and release automation so that all contributors follow a consistent process.

## When to use

Use this guide when contributing code, documentation, or configuration to this repository. It applies to all contributors, including external collaborators and internal team members.

## Prerequisites

- Git installed (version 2.28 or later)
- A GitHub account with access to this repository
- A fork of the repository (for external contributors)
- A local clone of the fork or the upstream repository

## Steps

1. Create a feature branch from the base branch:

   ```bash
   git checkout -b feature/your-descriptive-branch-name
   ```

2. Make your changes and stage them:

   ```bash
   git add <files>
   ```

3. Commit using the conventional commits format:

   ```bash
   git commit -m "feat: add user authentication endpoint"
   ```

   Valid types are `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`, and `revert`. The scope is optional and should be a short identifier for the area of the codebase.

4. Push the branch to your fork:

   ```bash
   git push origin feature/your-descriptive-branch-name
   ```

5. Open a pull request against the base branch. Include a description of the change and reference any related issues.

6. Wait for review. Address any feedback requested by reviewers.

## Verify

- All commits follow the conventional commits format (enforced by the `commit-msg` hook).
- Pre-commit hooks pass without errors.
- The pull request includes tests for new functionality.
- Documentation is updated if the change affects public APIs or user-facing behavior.

## Common errors

- **Commit message does not match conventional commit format.** The `commit-msg` hook validates the format. Ensure the message starts with a valid type followed by an optional scope and a colon.
- **Push rejected by pre-push hook.** The pre-push hook runs the test suite. Fix any failing tests before pushing.
- **Force push to a protected branch.** Force pushes to `main` or `master` are blocked by the pre-push hook. Use a feature branch and merge via pull request instead.
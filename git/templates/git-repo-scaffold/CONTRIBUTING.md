---
last_verified: 2026-08-02
tool_version: n/a
sources: []
---

# Contributing

> Guidelines for contributing to this repository. All contributions follow the conventional commits specification.

## Purpose

This document defines the contribution workflow for the project. It specifies the commit message format, branching strategy, and pull request process.

## When to use

Read this document before making any contribution to the repository. It applies to all contributors, including external collaborators.

## Prerequisites

- A fork of the repository with push access
- Git installed and configured with a valid email and name

## Steps

1. Create a feature branch from `main`:

   ```bash
   git checkout -b feat/short-description-of-change
   ```

2. Make your changes and commit using the conventional commit format:

   ```
   <type>(<scope>): <description>

   [optional body]

   [optional footer(s)]
   ```

   Valid types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`, `revert`.

3. Push the branch and open a pull request against `main`:

   ```bash
   git push origin feat/short-description-of-change
   ```

4. Ensure all checks pass before requesting review.

## Verify

- Run `git log --oneline` to confirm commits follow the conventional format.
- Confirm the pre-commit and commit-msg hooks are installed and executable.

## Common errors

- **Invalid commit type**: Using a type not in the allowed list causes the commit-msg hook to reject the message. Use one of: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `ci`, `build`, `revert`.
- **Missing scope**: The scope is optional but recommended. Omit the parentheses if no scope applies: `feat: add new feature`.
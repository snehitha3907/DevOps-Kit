---
last_verified: 2026-08-25
tool_version: n/a
sources:
  - https://pre-commit.com/
  - https://github.com/pre-commit/pre-commit-hooks
  - https://github.com/psf/black
  - https://github.com/astral-sh/ruff
---

# Wiring Git hooks into a pre-commit workflow

> How to set up a local pre-commit framework that runs formatters, linters, and custom checks before every commit. Third-person reference style with room for variation.

## Purpose

Configure a project-level pre-commit hook pipeline that enforces code quality automatically. The setup covers Python formatting (Black), fast linting (Ruff), and a selection of general-purpose hooks from the pre-commit-hooks collection. The goal is a zero-friction workflow where `git commit` runs the checks without manual steps.

## When to use

- New or existing Python projects that want consistent formatting and linting on every commit.
- Teams that want to catch style issues before they reach CI.
- Repositories where contributors have varying editor configurations.

## Prerequisites

- Git 2.30+ (for `init.defaultBranch` and modern hook support).
- Python 3.9+ with `pip` available.
- `pre-commit` installed globally or via `pipx` (recommended for isolation).

## Steps

### 1. Install pre-commit

```bash
pipx install pre-commit
# or
pip install --user pre-commit
```

Verify installation:

```bash
pre-commit --version
```

### 2. Create the configuration file

Add a `.pre-commit-config.yaml` at the repository root:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v5.0.0
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
      - id: check-merge-conflict
      - id: debug-logger

  - repo: https://github.com/psf/black
    rev: 24.10.0
    hooks:
      - id: black
        language_version: python3.11

  - repo: https://github.com/astral-sh/ruff-pre-commit
    rev: v0.7.0
    hooks:
      - id: ruff
        args: [--fix, --exit-non-zero-on-fix]
      - id: ruff-format
```

Notes on the configuration:
- The `rev` pins are reference versions known to work at time of writing. Update them when the upstream projects release new versions.
- `language_version: python3.11` under Black ensures the hook runs with a specific interpreter if multiple are present.
- Ruff's `--fix` flag applies safe auto-fixes; `--exit-non-zero-on-fix` makes the hook fail when it makes changes so the author can review.

### 3. Install the hooks into the local repository

```bash
pre-commit install
```

This writes a `prepare-commit-msg` and `pre-commit` script into `.git/hooks/`. From now on, every `git commit` runs the configured hooks.

### 4. Run against all files (optional, for existing codebases)

```bash
pre-commit run --all-files
```

This is useful on first adoption to clean up the entire tree before the hooks gate new commits.

### 5. Update hook versions periodically

```bash
pre-commit autoupdate
```

This bumps the `rev` fields to the latest tags. Review the diff before committing.

## Verify

1. Make a trivial change and commit:

   ```bash
   echo "# test" >> README.md
   git add README.md
   git commit -m "test: verify pre-commit runs"
   ```

   The commit should proceed only after all hooks pass.

2. Introduce a formatting violation and confirm the hook catches it:

   ```bash
   echo "x=1" >> test_format.py
   git add test_format.py
   git commit -m "test: black should catch this"
   ```

   Black reformats the file, the hook fails, and the commit is aborted. Stage the reformatted file and commit again.

3. Confirm Ruff linting works:

   ```bash
   echo "import os,sys" >> test_lint.py
   git add test_lint.py
   git commit -m "test: ruff should catch this"
   ```

   Ruff reports the unused imports and exits non-zero.

## Common errors

| Symptom | Cause | Resolution |
|---------|-------|------------|
| `pre-commit: command not found` | `pre-commit` not on PATH | Install via `pipx` or add `~/.local/bin` to PATH. |
| Hook fails with `language_version` error | Specified Python version not installed | Remove `language_version` or install the requested interpreter. |
| `git commit` hangs | Hook reads from stdin (rare) | Ensure hooks don't prompt; use `--no-verify` to bypass temporarily. |
| `rev` tag not found | Upstream tag was deleted or renamed | Run `pre-commit autoupdate` to fetch latest valid tags. |
| Ruff and Black conflict on formatting | Both formatters run on same files | Keep `ruff-format` only if Ruff's formatter matches team style; otherwise drop one. |

## References

- pre-commit documentation: https://pre-commit.com/
- pre-commit-hooks repository: https://github.com/pre-commit/pre-commit-hooks
- Black configuration: https://black.readthedocs.io/en/stable/integrations/pre-commit.html
- Ruff pre-commit integration: https://docs.astral.sh/ruff/integrations/#pre-commit
- Git hooks documentation: https://git-scm.com/docs/githooks
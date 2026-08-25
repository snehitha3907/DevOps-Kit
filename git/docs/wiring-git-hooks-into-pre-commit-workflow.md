---
last_verified: 2026-08-25
tool_version: n/a
sources: []
---

# Wiring Git hooks into a pre-commit workflow

## Purpose

Git hooks are scripts Git runs automatically at specific points — before a commit, after a push, when a branch is checked out. The `pre-commit` hook is the most useful for day-to-day work: it runs before Git finalises a commit, so it can lint, format, or validate staged files and block the commit if something is wrong.

This doc walks through setting up a `pre-commit` framework-based workflow, the pitfalls that tend to trip people up, and the patterns that stick in practice.

## Prerequisites

- Git 2.9+ (hooks directory support)
- Python 3.x (for the `pre-commit` framework)
- A repo with at least one commit

## Steps

### 1. Install the pre-commit framework

```bash
pip install pre-commit
```

The framework manages hook installation, updates, and execution. Without it, the alternative is writing raw shell scripts in `.git/hooks/` — doable but tedious to maintain across a team.

### 2. Create `.pre-commit-config.yaml`

Place this at the repo root. Each entry in the `repos` list points to a hook library and which hooks to enable:

```yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: vX.Y.Z  # Pin to a specific release tag (e.g., v4.6.0)
    hooks:
      - id: trailing-whitespace
      - id: end-of-file-fixer
      - id: check-yaml
      - id: check-added-large-files
  - repo: https://github.com/psf/black
    rev: XX.Y.Z  # Pin to a specific release tag (e.g., 24.4.2)
    hooks:
      - id: black
  - repo: https://github.com/charliermarsh/ruff
    rev: vX.Y.Z  # Pin to a specific release tag (e.g., v0.4.4)
    hooks:
      - id: ruff
        args: [--fix]
```

Key decision: pin `rev` to a release tag, not `main`. A floating tag means every `pre-commit autoupdate` silently changes which linter version the team runs — that is how "works on my machine" arguments start. The placeholder versions above (vX.Y.Z, XX.Y.Z) are examples; replace them with actual release tags from each project's releases page.

### 3. Install the hooks into the repo

```bash
pre-commit install
```

This writes a `pre-commit` script into `.git/hooks/`. Every `git commit` from now on triggers the hooks. The first run on a large repo is slow (hooks download their environments); subsequent runs are fast because the environments are cached.

### 4. Run against all files (initial baseline)

```bash
pre-commit run --all-files
```

This is essential after adding new hooks. Without it, existing violations stay in the repo until someone touches those files — and then the commit fails on a lint error unrelated to the change. Running `--all-files` upfront lets everything be fixed in one clean commit.

### 5. Skip a hook temporarily

```bash
git commit -m "urgent fix" --no-verify
```

Or skip a specific hook:

```bash
SKIP=black git commit -m "WIP: rough draft"
```

The `--no-verify` flag skips all hooks. Use it sparingly — the whole point is that hooks enforce standards. If the same hook is skipped repeatedly, the hook is probably wrong for the repo.

### 6. Update hook versions

```bash
pre-commit autoupdate
pre-commit run --all-files
```

Review the diff before committing. Hook updates sometimes change default behaviour (a new lint rule, a changed severity). Pin the updated rev and verify the hooks still pass.

## Verify

```bash
# Confirm hooks are installed
ls .git/hooks/pre-commit

# Trigger a test commit — hooks should run
echo "test" >> .gitignore
git add .gitignore
git commit -m "test: verify pre-commit hooks fire"
# Should see hook output before the commit message editor opens

# Confirm hooks are listed
pre-commit run --all-files
```

## Common errors

**"pre-commit: command not found"** — the `pre-commit` binary is not on `$PATH`. If installed via `pip install --user`, check `~/.local/bin`. If installed via `pipx`, the binary lives in `~/.local/bin` as well.

**Hooks run on every commit, even Documentation-only changes** — add file filters to the hook config:

```yaml
- id: ruff
  types: [python]
```

The `types` field uses pre-commit's identify library to match file types. This stops Python linters from running on Markdown-only commits.

**"Hook out of date" error** — the `.pre-commit-config.yaml` rev does not match what is installed. Run `pre-commit clean && pre-commit install` to reset.

**CI runs hooks too** — add a CI job that runs `pre-commit run --all-files` so local skips do not slip through. Most CI platforms have a pre-built action for this.

## What to explore next

After wiring hooks into pre-commit, the natural next steps are: adding a CI gate that mirrors the local hooks (so `--no-verify` local skips are caught), and exploring `pre-commit run --hook-stage push` to run hooks on `git push` as well as commit.

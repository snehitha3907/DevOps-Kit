---
last_verified: 2026-10-25
tool_version: n/a
sources: []
---

# Git Workflow Automation Scaffold

> A comprehensive project scaffold for Git workflow automation including hooks, aliases, and CI integration scripts.

## Purpose

This scaffold provides a complete Git workflow automation setup that enforces conventional commits, validates code quality via hooks, configures useful Git aliases, and integrates with CI/CD platforms (GitHub Actions and GitLab CI) for automated workflows. Use it as a starting point for any new or existing Git repository that requires standardized automation.

## When to use

Use this scaffold when a repository requires:

- Enforced conventional commit message format with validation
- Pre-commit, pre-push, and other Git hook validations
- Standardized Git aliases for common workflows
- CI/CD integration with automated quality gates
- Semantic versioning and changelog generation
- Branch protection and workflow automation

## Prerequisites

- Git 2.28 or later
- Bash 4.0 or later (for hook scripts)
- One or more CI/CD platforms:
  - GitHub Actions (for GitHub-hosted repositories)
  - GitLab CI (for GitLab-hosted repositories)
- Optional: `gh` CLI (for GitHub integration scripts)
- Optional: `glab` CLI (for GitLab integration scripts)

## Structure

```
git-workflow-automation/
├── hooks/                    # Git hook scripts
│   ├── pre-commit           # Validates staged changes
│   ├── commit-msg           # Enforces conventional commit format
│   ├── pre-push             # Runs tests and scans for secrets
│   ├── pre-rebase           # Prevents rebasing protected branches
│   ├── post-commit          # Logs commit metadata
│   ├── post-checkout        # Restores hooks on branch switch
│   ├── prepare-commit-msg   # Auto-generates commit message template
│   └── pre-merge-commit     # Validates merge commits
├── aliases/                  # Git alias configurations
│   ├── gitconfig            # Alias definitions for .gitconfig
│   └── setup-aliases.sh     # Interactive alias installer
├── ci/                       # CI/CD pipeline configurations
│   ├── github-actions/       # GitHub Actions workflows
│   │   ├── workflow-automation.yml
│   │   ├── dependabot.yml
│   │   └── auto-merge.yml
│   └── gitlab-ci/            # GitLab CI pipelines
│       ├── .gitlab-ci.yml
│       ├── lib.yml
│       ├── build.yml
│       ├── test.yml
│       └── deploy.yml
├── scripts/                  # Workflow automation scripts
│   ├── install-hooks.sh      # Installs all hooks
│   ├── setup-workflow.sh     # Interactive workflow setup
│   ├── semantic-version.sh   # Semantic version calculator
│   └── changelog-generator.sh # Conventional changelog generator
└── .gitignore                # Recommended ignore patterns
```

## Steps

### 1. Copy the scaffold into your repository

```bash
cp -r git-workflow-automation/ my-project/
cd my-project
```

### 2. Initialize or navigate to your Git repository

```bash
git init
# or if existing repo
cd existing-repo
```

### 3. Install the hooks

```bash
# Option A: Run the installer (recommended)
./git-workflow-automation/scripts/install-hooks.sh

# Option B: Manual installation
cp git-workflow-automation/hooks/* .git/hooks/
chmod +x .git/hooks/*
```

### 4. Configure Git aliases

```bash
# Interactive setup
./git-workflow-automation/aliases/setup-aliases.sh

# Or manually append to ~/.gitconfig
cat git-workflow-automation/aliases/gitconfig >> ~/.gitconfig
```

### 5. Set up CI/CD integration

**For GitHub Actions:**
```bash
mkdir -p .github/workflows
cp git-workflow-automation/ci/github-actions/*.yml .github/workflows/
```

**For GitLab CI:**
```bash
cp git-workflow-automation/ci/gitlab-ci/* .
```

### 6. Make scripts executable and available

```bash
chmod +x git-workflow-automation/scripts/*.sh
# Optionally add to PATH or create symlinks
```

### 7. Make the initial commit

```bash
git add .
git commit -m "chore: add Git workflow automation scaffold"
```

## Verify

- Run `git commit` with a test message to confirm the commit-msg hook validates the format.
- Run `git add` and `git commit` to confirm the pre-commit hook executes without errors.
- Run `git push` to verify the pre-push hook runs tests and scans for secrets.
- Check that `git <alias>` works for configured aliases (e.g., `git co`, `git st`, `git lg`).
- Verify CI/CD pipelines trigger on push and pull request events.

## Common errors

| Error | Cause | Resolution |
|-------|-------|------------|
| Hook not executable | Hooks copied without execute permissions | Run `chmod +x .git/hooks/*` |
| Commit message rejected | Message doesn't match conventional format | Use `type(scope): description` format |
| Pre-push test failure | Test suite fails | Fix failing tests before pushing |
| Alias not found | Aliases not added to Git config | Run `setup-aliases.sh` or manually update `~/.gitconfig` |
| CI pipeline not triggering | Workflow files in wrong location | Ensure files are in `.github/workflows/` or repository root |

## What this scaffold does not cover

- Language-specific linting/formatting (add to pre-commit as needed)
- Advanced release automation beyond semantic versioning
- Multi-repository orchestration
- Custom hook logic beyond the provided templates
- GitHub/GitLab API authentication setup (requires `gh`/`glab` auth)
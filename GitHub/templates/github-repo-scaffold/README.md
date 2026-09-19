---
last_verified: 2026-09-19
tool_version: n/a
sources: []
---

# GitHub Repository Scaffold

A production-ready GitHub repository template with branch protection, CODEOWNERS, issue templates, PR template, and Dependabot configuration.

## Contents

```
.github/
├── CODEOWNERS                    # Code ownership rules
├── ISSUE_TEMPLATE/
│   ├── bug_report.yml           # Bug report template
│   ├── feature_request.yml      # Feature request template
│   └── documentation.yml        # Documentation issue template
├── PULL_REQUEST_TEMPLATE.md     # PR template
├── dependabot.yml               # Automated dependency updates
└── workflows/                   # CI/CD workflows (add your own)

configure-branch-protection.sh   # Script to apply branch protection via GitHub API
```

## Quick Start

### 1. Use as a Template Repository
Click "Use this template" on GitHub to create a new repository with these files.

### 2. Apply Branch Protection
After creating the repository, run the branch protection script:

```bash
# Make executable
chmod +x configure-branch-protection.sh

# Apply protection to main branch (requires gh CLI with admin permissions)
./configure-branch-protection.sh <owner> <repo> main
```

The script configures:
- Required status checks: `ci/build`, `ci/test`, `ci/lint`
- Required PR reviews: 2 approvals, code owner review required
- Dismiss stale reviews on new commits
- Require conversation resolution before merge
- Prevent force pushes and branch deletion
- Enforce rules for admins

### 3. Customize CODEOWNERS
Edit `CODEOWNERS` to match your team structure:
- Replace `@org/core-maintainers` with your core team
- Update team references (`@org/docs-team`, `@org/platform-team`, etc.)

### 4. Add CI/CD Workflows
Create workflow files in `.github/workflows/` that match the required status checks:
- `ci/build.yml` — Build and compile
- `ci/test.yml` — Run test suite
- `ci/lint.yml` — Lint and static analysis

Example minimal CI workflow:
```yaml
# .github/workflows/ci.yml
name: CI
on: [push, pull_request]
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Build
        run: echo "Build step here"
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Test
        run: echo "Test step here"
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Lint
        run: echo "Lint step here"
```

## Branch Protection Details

| Setting | Value |
|---------|-------|
| Required reviews | 2 |
| Code owner review | Required |
| Dismiss stale reviews | Yes |
| Require conversation resolution | Yes |
| Required status checks | ci/build, ci/test, ci/lint |
| Strict status checks | Yes (branches must be up to date) |
| Enforce for admins | Yes |
| Allow force pushes | No |
| Allow deletions | No |

## Dependabot Configuration

Automated weekly updates for:
- GitHub Actions (grouped)
- Docker base images
- Terraform providers

All dependency PRs are labeled `dependencies` and prefixed with `chore(deps)`.

## Issue Templates

Three templates guide contributors:
1. **Bug Report** — Structured reproduction steps, environment, logs
2. **Feature Request** — Problem statement, proposed solution, use cases
3. **Documentation** — Location, type of improvement needed

## PR Template

Covers description, change type, related issues, testing, and reviewer checklist.

## Requirements

- GitHub repository with admin access (for branch protection)
- `gh` CLI authenticated (`gh auth login`)
- CI workflows that report `ci/build`, `ci/test`, `ci/lint` status checks

## License

Use freely. Adapt to your project's needs.
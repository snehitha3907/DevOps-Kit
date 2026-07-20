---
last_verified: 2026-07-20
tool_version: n/a
---

# Version Control Concepts — quick primer

> First-day notes on Version Control. What it is, why it matters, and the key ideas to know.

## What is it?

Version control is a system for tracking changes to files over time. Think of it like a detailed "undo" history that never forgets — every change is recorded, tagged with who made it and when, and can be revisited or rolled back at any point.

The most common system today is Git, which stores changes as snapshots called commits. Each commit points to the previous one, forming a chain that shows the full history of a project. Instead of overwriting files in place, Git builds a graph of every state the project has ever been in.

It's similar to how Google Docs tracks edits, except version control is designed for code collaboration. Multiple people can work on the same project simultaneously, merging their changes together instead of overwriting each other's work.

## Why does it matter for DevOps?

As a DevOps practitioner, version control is the backbone of everything I do. Every script, config file, pipeline definition, and infrastructure template lives in a repository. Without version control, I'd be copying files to shared drives with names like `config_final_v2_REALLY_FINAL.sh`.

Version control gives me the ability to collaborate safely. When I need to update a deployment script, I create a branch, make changes, and open a pull request. Teammates review the diff — the exact line-by-line changes — before merging to the main branch. If something breaks, I can trace exactly which commit introduced the problem and revert just that change.

It also serves as the source of truth. My infrastructure code, deployment configs, and operational runbooks are all versioned, auditable, and reproducible. When an incident happens, I can check out the exact state of the repo at 2 AM on Tuesday and see exactly what was deployed.

## Key terminology

- **Repository** — A folder tracked by version control that contains the project and its full history. Example: the `infra/` directory holding all my Terraform and Ansible files.
- **Commit** — A snapshot of changes at a point in time, with a message explaining why the change was made. Example: `git commit -m "add health check to nginx playbook"`.
- **Branch** — A parallel line of development that lets me work on changes without disturbing the main line. Example: `feature/add-redis-cache` for a new caching layer.
- **Merge** — Combining changes from one branch into another. Example: merging a feature branch into `main` after review.
- **Pull Request** — A review request to merge one branch into another, with a diff and discussion. Example: opening a PR so teammates can review my config changes before they go live.
- **Clone** — Copying a remote repository to my local machine so I can work on it. Example: `git clone git@github.com:org/infra.git`.
- **Remote** — A version of the repository hosted on a server (like GitHub) that I can push to and pull from. Example: `origin` pointing to `github.com:org/infra.git`.
- **.gitignore** — A file that tells Git which files or directories to skip. Example: ignoring `.terraform/` and `*.tfvars` so secrets and generated files aren't committed.
- **Conflict** — When two branches change the same line of code and Git can't auto-merge them. Example: Alice and Bob both edit `values.yaml` on different branches.
- **HEAD** — A pointer to the current commit I'm looking at, usually the tip of the current branch. Example: after `git checkout main`, HEAD points to the latest commit on `main`.

## A concrete example

Here's the smallest useful version-control workflow: make a change, save it, and share it.

```bash
# Start a new branch for my change
git checkout -b add-redis-healthcheck

# Edit the file, then stage and commit
git add playbooks/redis.yml
git commit -m "add TCP health check to redis playbook"

# Push the branch and open a pull request
git push -u origin add-redis-healthcheck
gh pr create --title "Add Redis health check" --body "Adds TCP probe for Redis service."
```

This creates an isolated branch, records the change as a commit, and opens a pull request for review. The full diff is visible to anyone on the team, and the change can be merged, discussed, or discarded cleanly.

## How this connects to what's next

Version control is the foundation for everything else in this kit. Once I understand commits, branches, and pull requests, I can use GitOps workflows where Kubernetes applies changes from a Git repo, or IaC pipelines where Terraform plans are triggered by PRs. The concepts stay the same — only the tools on top change.

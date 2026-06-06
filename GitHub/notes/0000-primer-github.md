# GitHub — quick primer

> First-day notes for someone who's never used GitHub. Personal voice, plain language.

## What is it?

GitHub is a web platform for hosting Git repositories. It's like Google Drive for code, but with built-in version control, collaboration features, and a social layer. While Git manages the version history on my machine, GitHub stores that history online so my team can access it and contribute.

## What does it do?

After committing changes locally with Git, I push them to GitHub to back them up and share with others. GitHub shows diffs, lets me open pull requests to propose changes, tracks issues, and runs CI/CD pipelines. The web UI makes it easy to browse code, compare commits, and manage project workflows.

## Why does it exist?

Before GitHub, we emailed patch files or struggled with self-hosted Git. Collaboration was manual and error-prone. GitHub centralized everything — code, reviews, discussions, and automation — into one place. It turned individual Git workflows into team workflows.

## Key terminology

- **Repository** — Project folder with history. `git clone https://github.com/user/repo`.
- **Remote** — The GitHub URL your local repo connects to. Usually called "origin".
- **Pull request** — Proposed changes you want merged. Opens a discussion and runs checks.
- **Issue** — A ticket for bugs, features, or tasks. Tracked in the repo's issue tracker.
- **Branch** — Independent line of development. `main` is the default, others isolate work.
- **Fork** — Your copy of someone else's repo. Used for contributing upstream.
- **Merge** — Combining changes from one branch into another. Closes the PR.
- **Clone** — Copy a remote repo to your local machine. `git clone <url>`.

## A tiny example

```bash
gh repo create my-new-project --public
git push origin main
gh pr create --title "Initial commit"
```

This uses the GitHub CLI to create a repo, push code, and open a PR.

## What I'll cover next

I'll authenticate with the GitHub CLI and explore my profile, then look at repos, issues, and PRs through both the web UI and CLI.
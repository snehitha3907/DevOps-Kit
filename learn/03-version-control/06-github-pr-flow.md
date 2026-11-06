---
last_verified: 2026-11-06
tool_version: "n/a"
sources:
  - https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests
  - https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches/about-protected-branches
---
# Pull requests and branch protection on GitHub

You now know how to branch, merge, rebase, and recover work in Git. The next step is collaborating on GitHub: propose changes through pull requests (PRs) and protect your main branch so changes go through review before merging. In this lesson you will push a sample app to GitHub, open a pull request, and enable branch protection rules.

## What you'll learn

- Push the sample app to GitHub and open a pull request
- Protect the main branch so changes need a reviewed PR

## Before you start

- [Branch, merge and rebase](04-git-branch-merge-rebase.md) — a Git repository with a few commits on `main` to branch from
- [Undo mistakes and recover lost work](05-git-recover-reflog.md) — comfortable working with branches and history
- Git installed. Confirm with `git --version`.
- A GitHub account. You can use the web UI or GitHub CLI (`gh`).

## Walkthrough

1. Create a local repository to push to GitHub.

   ```bash
   cd /tmp
   rm -rf pr-flow-lab && mkdir pr-flow-lab && cd pr-flow-lab
   git init -b main
   echo "# PR Flow Lab" > README.md
   echo "print('hello')" > app.py
   git add README.md app.py
   git commit -m "initial commit"
   git log --oneline
   ```

   You should see: one or more commits on `main`.

2. Create a new repository on GitHub and push your local repo.

   On GitHub, create a new empty repository (do not initialize with README, .gitignore, or license). Copy the remote URL (HTTPS or SSH).

   ```bash
   git remote add origin <YOUR_GITHUB_REPO_URL>
   git branch -M main
   git push -u origin main
   ```

   You should see: Git pushes `main` to `origin/main`. The repository now exists on GitHub.

3. Create a feature branch, make changes, and push it.

   ```bash
   git checkout -b feature/add-greeting
   echo "def greet():" >> app.py
   echo '    return "hello from feature"' >> app.py
   git add app.py
   git commit -m "add greet function"
   git push -u origin feature/add-greeting
   ```

   You should see: the feature branch is pushed to GitHub and Git sets up tracking.

4. Open a pull request on GitHub.

   Go to your repository on GitHub. You should see a prompt to "Compare & pull request" for your recently pushed branch. Click it.

   Fill in the PR details:
   - Title: `Add greeting function`
   - Description: explain what you changed and why
   - Base: `main`, compare: `feature/add-greeting`

   Click "Create pull request".

   You should see: the PR is created with a diff showing your changes to `app.py`. You can review files, leave comments, and request reviews.

5. Protect the main branch so changes need a reviewed PR.

   On GitHub, go to Settings → Branches → Branch protection rules → Add rule.

   For "Branch name pattern", enter `main`.

   Enable the following protections:
   - Require a pull request before merging
   - Require approvals (set to 1 or more)
   - (Optional) Require status checks to pass before merging

   Click "Create" or "Save changes".

   You should see: the branch protection rule is active. Now direct pushes to `main` are blocked, and PRs require review before merging.

6. Merge the pull request.

   Return to your open PR. If reviews are required and not yet approved, request a review or approve it (in a real workflow another person approves). Once requirements are met, click "Merge pull request" and confirm.

   ```bash
   git checkout main
   git pull origin main
   git log --oneline -n 3
   ```

   You should see: after merging on GitHub, pulling `main` brings in the merged changes. The feature branch can be deleted.

## Exercise

In your own repository:

1. Create a feature branch, make a small change (like updating `README.md`), push the branch, and open a pull request to `main`.
2. Add a branch protection rule on `main` requiring at least one approval before merging.
3. Merge the PR through the GitHub UI, pull the updated `main` locally, and delete the feature branch locally and remotely.

## Check your work

Run these commands locally:

```bash
git branch -a
git log --oneline -n 3 main
```

You should see: `main` includes the merged changes from your PR, the feature branch is no longer active locally (and optionally deleted on remote), and your `main` is up to date with `origin/main`.

## Common mistakes

- Pushing directly to `main` when branch protection is enabled — GitHub will reject the push. Always use a feature branch and PR.
- Forgetting to set the upstream when pushing a new branch (`git push -u origin <branch>`) — without it, subsequent `git push`/`pull` may not track correctly.
- Opening a PR with the wrong base/compare — double-check base is `main` and compare is your feature branch.
- Merging without pulling locally after — remember to `git pull` on `main` to sync your local copy.

## Next

[Containerization concepts](../../docs/concepts/containerization-concepts/0000-primer-containerization-concepts.md)

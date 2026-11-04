---
last_verified: 2026-11-03
tool_version: "n/a"
---

# Put the sample app under version control

This lesson takes the sample app you have been working with and puts it into a Git repository. You will write a sensible `.gitignore`, make several small commits that tell a clear story, and read back the history with `git log`. It picks up from the Git primer and the version control primer, and it is the first hands-on Git lesson in the kit.

## What you'll learn

- Create a repository for the sample app with a sensible `.gitignore`
- Commit changes in small steps and read the history

## Before you start

- [Git — quick primer](../../Git/notes/0000-primer-git.md) — what a repository, commit, and staging area are.
- [Version control concepts](../../docs/concepts/version-control-concepts/0000-primer-version-control-concepts.md) — why version control exists and the commit/branch/PR vocabulary.
- [Find your way around the lab shell](../01-orientation/02-shell-navigation.md) — moving around the filesystem and reading exit codes.
- Git installed. Confirm with `git --version`.

## Walkthrough

1. Move into the sample app directory and turn it into a repository.

   ```bash
   cd ~/sample-app
   git init
   ls -la
   ```

   You should see: a new hidden `.git/` directory. That directory is the repository itself — everything Git remembers lives there. The files outside `.git/` are your working tree, and they are now tracked by Git.

2. Create a `.gitignore` before your first commit so generated files never get committed.

   ```bash
   cat > .gitignore <<'EOF'
   # Python
   __pycache__/
   *.py[cod]
   .venv/
   .env

   # Build output
   build/
   dist/
   *.egg-info/

   # Editor and OS
   .vscode/
   .idea/
   .DS_Store
   EOF
   cat .gitignore
   ```

   You should see: the contents of `.gitignore` printed back. Each line is a pattern Git will skip when staging. The `.gitignore` file itself should be committed, so it is shared with anyone who clones the repo.

3. Check what Git sees before staging anything.

   ```bash
   git status
   ```

   You should see: the untracked files in the sample app listed under "Untracked files", plus `.gitignore`. Nothing is staged yet. Reading this output before staging is a habit worth keeping — it is where mistakes are caught early.

4. Stage the ignore file and make the first commit.

   ```bash
   git add .gitignore
   git commit -m "chore: add .gitignore for the sample app"
   ```

   You should see: a commit line like `[main (root-commit) ...] chore: add .gitignore for the sample app`, with one file changed and a number of insertions. Small, single-purpose commits like this are easy to review and easy to revert.

5. Stage the rest of the app and commit it as the next step.

   ```bash
   git add .
   git status
   git commit -m "feat: add sample app source and tests"
   ```

   You should see: after `git add .`, `git status` shows the files staged under "Changes to be committed"; after the commit, a second commit line appears. Committing in two steps (ignore file first, then the app) keeps the history readable.

6. Make a small change and commit it.

   ```bash
   printf '\n# Sample app\n' >> README.md
   git diff
   git add README.md
   git commit -m "docs: add a one-line title to README"
   ```

   You should see: `git diff` shows the added line in green with a `+` prefix; `git commit` creates a third commit. `git diff` is the check you run before every commit to confirm you are committing what you think you are.

7. Read the history.

   ```bash
   git log --oneline
   git log --stat
   ```

   You should see: `--oneline` prints one line per commit — hash and message, newest first. `--stat` adds which files changed in each commit and how many lines were added or removed. A clean history is a series of small, well-described steps.

## Exercise

Working in your own copy of the sample app (not the course's):

1. Initialise a repository and write a `.gitignore` that excludes `__pycache__/`, `.venv/`, and `.env`.
2. Make at least three commits: one for the ignore file, one for the application code, and one for a small documentation change.
3. Run `git log --oneline` and confirm you can read what each commit did without opening the files.

Do not copy the solution; the point is the practice.

## Check your work

Run these and confirm the results:

```bash
git log --oneline
git status
```

You should see three (or more) commits in `git log --oneline`, newest first, and `git status` reporting `nothing to commit, working tree clean`. If `git status` shows untracked files, add and commit them, or extend `.gitignore` and commit that change.

## Common mistakes

- Committing `__pycache__/` or `.venv/` because `.gitignore` was added after the first commit. If that happens, remove the cached files with `git rm -r --cached __pycache__ .venv` and commit the updated ignore file.
- One giant commit titled "initial commit" that mixes code, config, and docs. Split it: stage and commit one concern at a time.
- Forgetting to run `git diff` before `git add`. Stage only the files you intended; use `git add -p` to stage hunks selectively.
- Empty commits from `git commit` with no staged changes. Stage something first, or use `git commit --allow-empty` only when you mean it.

## Next

[Branch, merge and rebase](../../00_index/learning-path.md)
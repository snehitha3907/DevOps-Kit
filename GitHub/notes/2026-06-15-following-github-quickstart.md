# Following the GitHub Hello World quickstart — what tripped me up

I ran through the official GitHub quickstart (the Hello World tutorial that has you fork a repo, edit in the browser, open a PR, then do the same with `gh`). The overall flow makes sense, but several steps weren't clear from the text alone.

## CLI track — where I stumbled

I jumped straight into `gh repo create my-hello --public --source=.` without reading the flag requirements closely. It failed immediately because `--source` expects a git directory, and I was in a plain folder. The quickstart doesn't show the `git init` + initial commit step before that command — it just says "run this inside your project." I had to back up:

```bash
mkdir my-hello && cd my-hello
git init
echo "# Hello World" > README.md
git add README.md && git commit -m "first commit"
gh repo create my-hello --public --source=. --remote=origin
```

That worked. Pushing more commits and running `gh pr create` was smooth, except `gh pr create` without `--title` or `--body` drops you into an interactive prompt. The quickstart shows those flags inline but doesn't call out that leaving them off changes the UX entirely.

## Web UI track — fork workflow confusion

Forking the `octocat/Hello-World` repo was one click. I made a small edit in the browser's file editor and committed to `main`. The quickstart says "open a pull request" but doesn't mention that the "Contribute" dropdown only appears after you have at least one commit difference from the upstream branch. With zero changes there's nothing to propose, which is obvious in hindsight.

When I opened the PR, the description field auto-filled from the upstream repo's PR template — not from my fork. I expected my fork's conventions to apply, but GitHub always uses the base repo's template. That tripped me up for a minute.

The merge step shows three buttons: Merge, Squash and merge, Rebase and merge. The quickstart uses Squash without explaining what it does to the commit history. I squashed mine and it worked fine, but I'd want to understand the difference before relying on that choice on real branches.

## What I'd handle differently next time

- Read `gh repo create --help` before running it so I know `--source` needs an initialized repo
- Always pass `--title` and `--body` to `gh pr create` to avoid the interactive editor unexpectedly
- Branch off the fork's default branch before editing in the browser — committing straight to `main` on a fork feels messy once you have multiple PRs open
- Look up merge-strategy tradeoffs before hitting the green button on a real PR

---
last_verified: 2026-09-19
tool_version: n/a
sources: []
---

# Following the gh CLI quickstart — what tripped me up

I sat down to follow the official `gh` CLI quickstart end-to-end, expecting a smooth 15-minute walkthrough. It took closer to an hour, mostly because of a few things the docs didn't flag. Here's what caught me.

## Authentication wasn't a one-step thing

`gh auth login` itself was fine — I picked HTTPS, entered my token, and it stored it. But the quickstart doesn't mention that your token needs specific scopes. My first `gh repo list` returned an empty table with no error, which looked like a bug. It took me a while to realize the token was missing `repo` scope. Adding it and re-running `gh auth login` fixed it. I'd rather an error message up front than a silent empty result.

The quickstart also doesn't explain that `gh auth login` only configures one host at a time. When I switched to work on a second enterprise account, I assumed `gh auth login` again would layer on the new credentials. It didn't — it overwrote the first config. I had to use `gh auth login --hostname github.enterprise.example` to add a second host.

## The default editor fight

`gh issue create` opened my system editor by default. I wasn't expecting that. I'd passed `--title` and `--body` flags on other commands and assumed all of them would stay in the terminal. When the editor popped open, I lost my train of thought trying to figure out which file I was actually editing. The quickstart doesn't call out `--web` as an alternative for opening things in the browser or `--title`/`--body` as flags that keep you in the terminal.

Similarly, `gh issue edit` opens an editor too. I accidentally closed an issue instead of editing its body because my editor uses `:wq` semantics I wasn't expecting. `gh issue reopen` fixed it, but it was a jarring interruption.

## The "no default repository detected" detour

After cloning a repo with `gh repo clone cli/cli`, I started running `gh` commands from my home directory and got "no default repository detected." I assumed the CLI had lost track of my authentication. The fix was simple — `cd` into the cloned repo first — but the quickstart doesn't say that `gh` commands like `gh pr view` and `gh issue list` look for a repository context from your current directory, not from your global config.

## Token scopes are invisible until they fail silently

Beyond the `repo` scope issue, I hit a cryptic "Resource not accessible by personal access token" when running `gh project list`. The fix was adding the Projects scope. The error message gave me nothing to work with — no hint about which scope was missing, no link to documentation. I had to guess and check. Other commands like `gh api` were more helpful about permissions, so the inconsistency was confusing.

## What I'd try next

- set up a default repo with `gh repo set-default` so I don't have to `cd` every time
- explore `gh alias` to shorten the commands I reach for most
- try `gh pr merge --squash` and `gh pr merge --rebase` to see how the merge options compare
- dig into `gh api` for cases where the built-in subcommands don't cover what I need

# Exploring GitHub web UI and CLI

> First-day notes, still figuring things out.

I opened github.com and logged in, then clicked around to see repos, issues, and PRs. The web UI shows everything in tabs — Code, Issues, Pull requests, Actions. Clicking a repo gives me the file tree, commit history, and a big green "Code" button to clone it.

I tried `gh repo list` to see my repos from the terminal. `gh issue list` shows open issues in the current repo. `gh pr list` shows PRs. I created a test issue with `gh issue create --title "test" --body "just checking"` and then closed it with `gh issue close <number>`.

The CLI feels faster for quick checks, but the web UI is better for reading diffs or commenting. I keep forgetting to add `--repo owner/repo` when I'm not inside a cloned repo.

What tripped me up:
- `gh` commands need auth first (`gh auth login`)
- Without a local clone, most commands need `--repo`
- PR numbers and issue numbers live in separate namespaces

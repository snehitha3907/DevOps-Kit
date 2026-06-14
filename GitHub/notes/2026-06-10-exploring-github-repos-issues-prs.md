# Exploring GitHub repos, issues, and PRs

> First-day notes — clicking around and trying things.

I opened a repo on github.com and looked at the tabs: Code, Issues, Pull requests, Actions, Projects. The Code tab shows the file tree and README. I clicked around commits and branches.

I tried `gh repo view owner/repo --web` to open a repo in the browser from the terminal. Then `gh issue list --repo owner/repo` to see open issues. The output shows number, title, assignee, and labels in a table.

Next I tried `gh pr list --repo owner/repo` — same table format. The PR view shows the diff, checks status, and comment thread. I realized PR numbers and issue numbers are separate — `gh pr view 1` and `gh issue view 1` can refer to different things.

I also cloned a repo and ran `gh issue create --title "hello" --body "testing"` inside it — this time I didn't need `--repo` since gh detected the remote.

What tripped me up:
- `gh` commands need to be run from inside a repo dir or with `--repo`
- PR numbers and issue numbers are separate namespaces
- The web UI loads faster than I expected for large repos

# Repos, issues, and PRs — first look

I spent some time today clicking around repos, issues, and PRs on both the web UI and the CLI.

On the web, I opened a repo and stared at the file tree for a while. The Code tab shows the source tree, commit messages, and branch selector. I clicked into a couple of files to see syntax highlighting. Then I clicked the Issues tab — everything is listed by status, with labels and assignees visible at a glance. The Pull Requests tab looks similar but shows merge status and review count.

From the terminal, I tried `gh repo list --limit 10` — it shows the repo name, visibility, and last push date. `gh issue list --repo my-test/foo` listed the one open issue I'd created. `gh pr list` on a cloned repo showed PRs for that project.

I noticed the web UI is better for exploring unknown repos and reading diffs. The CLI is faster for checking my own stuff. I keep forgetting `--repo` when I'm outside a git directory.

# Following the GitHub CLI quickstart

I went through the official `gh` quickstart to get comfortable with authentication, viewing repos, and basic issue/PR operations. Here's what worked and where I had to retry a few things.

`gh auth login` was smooth — I chose HTTPS, pasted my personal access token, and verified with `gh auth status`. The CLI picked up the token immediately. I did have to make sure my PAT had `repo` and `read:org` scopes, otherwise `gh repo list` returned nothing. It didn't error loudly, just showed an empty table, which was confusing at first.

Next I ran `gh repo list` and got a list of my repos. I tried `gh repo view cli/cli --web` to open the official CLI repo in the browser, which worked instantly. Then I cloned it with `gh repo clone cli/cli` — once again I had to remember to `cd cli` before running other `gh` commands, otherwise I got "no default repository detected."

Working through the issue section, I created, viewed, and edited an issue in my own test repo. `gh issue create` pulled up an editor by default, so I passed `--title` and `--body` flags to stay in the terminal. `gh issue list --label bug` filtered cleanly. The part that tripped me: `gh issue edit 5` also opens an interactive editor, and I accidentally closed an issue instead of just editing the body because my terminal's default editor uses `:wq` semantics I wasn't expecting. Luckily `gh issue reopen 5` fixed it.

For pull requests, `gh pr create` from inside the cloned repo was straightforward — I provided a title and body, chose "Submit" in the interactive prompt, and the PR opened. `gh pr checkout 42` pulled the branch down, but then I forgot I was now on a detached-ish branch and ran `gh pr status` expecting rafted info. It worked, but I got confused about which branch I was on until I checked with `git status`.

One more gotcha: `gh project list` requires the Projects (beta) or Projects (classic) scope on my token. Without it I got a cryptic "Resource not accessible by personal access token" message. Adding that scope and re-running `gh auth login` fixed it.

What I'd try next:
- explore `gh alias` to shorten common commands
- try `gh pr merge --squash` to see how merge strategies work
- dig into `gh api` for raw REST calls when the built-in commands fall short

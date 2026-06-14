# Following the official GitHub quickstart — CLI + web UI

I'd used `gh` for a few things before but never sat down and followed the entire official quickstart end-to-end. This time I did both the CLI track and the web UI track to see where each approach shines and where it trips you up.

## CLI track — what worked

The quickstart has you create a repo, clone it, make a commit, push, and open a PR. All from the terminal. I followed along step by step.

Creating a repo with `gh repo create my-quickstart-test --public --clone` worked on the first try. The `--clone` flag is nice — it clones automatically after creation so you don't need a separate `gh repo clone` step. I didn't catch that detail the first time I read the command and ended up with an empty directory because I assumed it just created remotely.

Editing a file from the command line after cloning was fine. `echo "hello" > README.md`, `git add`, `git commit -m "initial"`, `git push`. Standard workflow.

Opening a PR with `gh pr create --title "Quickstart test" --body "Testing the flow"` prompted me to choose a head branch interactively. I was on `main` and it warned me, so I created a feature branch first:

```
git checkout -b quickstart-feature
echo "feature content" > feature.txt
git add feature.txt && git commit -m "add feature file"
git push origin quickstart-feature
gh pr create --title "Quickstart feature" --body "Demo PR"
```

That part was smooth. `gh pr view --web` opened the PR in the browser so I could see how it looked on the web UI.

## Web UI track — what I noticed

The web UI quickstart walks through creating a repo from the browser, creating a file using the online editor, and opening a PR from a fork.

I tried the fork approach — forked a repo I had access to, made a change in the browser editor, and committed directly to the main branch of the fork. The quickstart says to create a PR from the fork's main branch. GitHub detected the fork and offered the "Contribute" button automatically. That was cleaner than I expected.

What tripped me up: when I tried to create a PR from my fork, GitHub showed "This branch is 1 commit ahead of the parent repo." I clicked "Open pull request" and it filled in the template from the parent repo. I added a description and submitted. Then I realized I'd committed to the fork's main branch instead of a feature branch. The quickstart doesn't emphasize branch hygiene in the fork workflow — it just says "commit to main" for simplicity. That works for a tutorial but I'd want a feature branch in real work.

## Compare and merge

After creating the PR via CLI, I merged it with `gh pr merge --squash` from the terminal. The quickstart has you merge via the web UI's big green button. Both work, but `gh` is faster when you're already in the terminal and know the PR number.

One thing I liked about the web UI: the merge-conflict editor is visual and clear. When I created a second PR that conflicted (because I'd merged the first one and the files overlapped), the web UI showed "This branch has conflicts that must be resolved" with an in-page editor. That was easier than resolving with `git mergetool` for a beginner.

## What tripped me up overall

- The quickstart assumes you have `gh` authenticated with the right scopes. I'd set up my PAT for `repo` and `read:org`, but the quickstart's "hello-world" repo creation needed `delete_repo` scope too when I tried to clean up with `gh repo delete`. Minor, but it would have been nice to know up front.
- Fork workflow on web: committing to main on a fork feels wrong even for a tutorial. I'd recommend the quickstart use a branch.
- `gh pr create` from a fork requires you to push to a branch on your fork, then run `gh pr create` from the fork's clone. That part isn't obvious in the CLI track.
- When merging PRs via CLI, there's no visual diff shown — you're trusting `gh pr diff` output. The web UI's side-by-side diff is a lot easier to review before hitting merge.

## What I'd try next

- Set up branch protection rules so `gh pr merge` fails on main without approval
- Try `gh pr review` workflow — approve, request changes, and comment from the CLI
- Wire up a simple GitHub Action that runs on PRs so I can see CI status in both CLI and web views

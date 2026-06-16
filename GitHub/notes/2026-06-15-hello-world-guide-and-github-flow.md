# Following the Hello World guide — GitHub flow from scratch

I'd never actually done the classic "Hello World" guide on GitHub (docs.github.com/en/get-started/quickstart/hello-world). It walks through the entire GitHub flow — branch, commit, PR, merge — all in the web UI. I wanted to see how it holds up for someone who's never used Git before.

## The guide step by step

Step one: create a repo. I filled in the name and description in the browser, chose Public, and checked "Add a README file." The guide says to do this but doesn't explain what a README is for — not a big gap but a complete beginner might wonder.

Step two: create a branch. I clicked the branch dropdown (currently on `main`), typed `readme-edits`, and hit Enter. The UI switched immediately. This is the first moment where the web UI makes branching less intimidating than the command line. No `git checkout -b` syntax, no detached HEAD confusion.

Step three: edit the README. I clicked the pencil icon on the README file, made some changes in the browser editor, and wrote a commit message. The guide suggests "Add a description about yourself" as the message. I committed directly to `readme-edits`. The diff showed on the next page — green for additions, red for deletions.

Step four: open a pull request. I clicked the Pull Requests tab then "New pull request." The base was `main` and the compare was `readme-edits`. GitHub showed a green "Able to merge" badge. I wrote a title and description, then clicked "Create pull request." The PR page shows the diff, a comment box, and merge options.

Step five: merge. I clicked the green "Merge pull request" button, then "Confirm merge." The PR closed and the commits appeared on `main`. GitHub offered to delete the `readme-edits` branch after the merge. I clicked it.

## What tripped me up

- The guide says to create the README during repo creation, but the branch + edit flow also works on an empty repo — I tested both. The empty-repo path shows different UI (a big "Quick setup" box instead of the file tree) and the branch dropdown isn't visible until you push a commit. The guide only covers the "with README" path.
- The PR comparison page shows commits from the compare branch, but if you edit `main` directly between creating the branch and opening the PR, the diff gets more complex. The guide assumes no concurrent changes.
- "Merge pull request" appears immediately with no review requirement. For a real project I'd expect branch protection, but for a tutorial it's fine.
- After merging, the branch deletion prompt is easy to miss if you navigate away from the PR page quickly.

## What I'd try next

I want to try the same flow with `gh` CLI commands to see where the web UI and CLI diverge. I also want to set up a branch protection rule and then try to merge without approval — that'll teach me how enforcement works in practice.

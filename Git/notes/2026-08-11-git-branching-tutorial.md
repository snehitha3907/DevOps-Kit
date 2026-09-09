---
last_verified: 2026-08-11
tool_version: n/a
---

# Git branching tutorial — what tripped me up

I worked through the official Git branching tutorial on git-scm.com. I'd used branches casually before but never really understood the mechanics. Here's what I did and where I got stuck.

## The setup

I built a tiny practice repo on my machine so I could undo anything:

```bash
mkdir branch-lab && cd branch-lab
git init
echo "one" > readme.md
git add readme.md && git commit -m "first"
echo "two" >> readme.md
git add readme.md && git commit -m "second"
echo "three" >> readme.md
git add readme.md && git commit -m "third"
```

## Creating and switching branches

The tutorial made `git branch testing` + `git checkout testing` click for me — a branch is just a movable pointer to a commit, and `HEAD` is the pointer to whichever branch I'm on.

```bash
git branch testing
git checkout testing
# or the one-liner I now prefer:
git checkout -b testing
```

The first time I did `git checkout testing`, `readme.md` still showed "three" — nothing changed, which confused me until I re-read that branching doesn't copy files, it just moves where new commits get recorded.

## What actually tripped me up

- **`git branch` vs `git checkout`.** I kept expecting `git branch testing` to also switch me to the new branch. It doesn't — it only creates it. `checkout` is what moves `HEAD`. I lost count of how many times I created a branch and then committed to `main` because I forgot the second step.
- **Merging after diverging.** The tutorial's clean fast-forward merge felt too easy. The "merge conflict" section was where I fumbled: when two branches changed the same line, `git merge` paused mid-merge and left conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) in the file. I had to edit the file, `git add` it, then `git commit` to finish. The tutorial says the merge is only half done at that point — the commit is what completes it.
- **Detached HEAD.** I did `git checkout <commit-hash>` instead of a branch name once, and got the detached HEAD warning. I almost lost work because a commit made there isn't on any branch. The fix was `git branch new-branch-name` to attach a branch to the current position.

## What I'd try next

I want to replay the same scenario with `git switch` and `git restore` (the newer commands the tutorial mentions), and then redo the merge-conflict exercise a few more times until resolving conflicts stops feeling scary.

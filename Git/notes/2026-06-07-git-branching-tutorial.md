# Git branching tutorial — what I learned and what tripped me up

I followed the official Git branching tutorial at git-scm.com to finally wrap my head around branches, merging, and rebasing. Here's what happened.

## Following the tutorial

Started in a test repo with a few commits already on `main`:

```bash
mkdir branch-lab && cd branch-lab
git init
echo "initial" > readme.md
git add readme.md && git commit -m "initial"
echo "second" >> readme.md
git add readme.md && git commit -m "second"
echo "third" >> readme.md
git add readme.md && git commit -m "third"
```

Created a new branch and switched to it:

```bash
git branch testing
git checkout testing
# or in one step: git checkout -b testing
```

Made some changes on the branch, committed them, then switched back to `main`:

```bash
echo "branch work" >> readme.md
git add readme.md && git commit -m "work on testing branch"
git checkout main
```

The files on `main` still had the old content — exactly what I wanted. Merged `testing` into `main`:

```bash
git merge testing
# Fast-forward — no new merge commit
```

Tried the three-way merge scenario by making divergent changes, and that worked too. Git auto-merged cleanly since the changes were on different parts of the file.

## Got stuck on

**Rebase vs merge.** The tutorial explains rebase as "replay your commits on top of another branch," but I kept mixing it up with merge in my head. What finally clicked: merge creates a new commit that ties two histories together; rebase rewrites history by placing your commits after the target branch's commits. I tried rebasing and it worked, but the commit hashes changed — that's the whole point.

**Detached HEAD.** I accidentally `git checkout`'d a commit hash instead of a branch name, which put me in detached HEAD state. The tutorial warned about this but I didn't really get it until I tried making a commit while detached — it was there, but invisible from any branch. Had to create a new branch to keep it.

## What I'd try next

I want to tackle merge conflicts next — the tutorial simulates one but I need to create a real scenario where two people edit the same lines. I'll also practice `git rebase -i` for squashing commits.

The tutorial's visual diagrams were way more helpful than reading about branches in the primer. Seeing the commit graph shift around made everything click.

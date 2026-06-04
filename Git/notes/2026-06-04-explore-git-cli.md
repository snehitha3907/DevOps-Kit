# Exploring the Git CLI — init, add, commit, log

I made a test repo to try out the basic Git commands. Here's what I did.

Created a directory and initialized a repo:

```bash
mkdir test-playground && cd test-playground
git init
# Initialized empty Git repo in test-playground/.git/
```

Checked the status — Git tells you what's going on:

```bash
git status
# On branch master, no commits yet, nothing to commit
```

Made a file and staged it:

```bash
echo "hello" > test.txt
git add test.txt
```

Committed it:

```bash
git commit -m "add test.txt"
# 1 file changed, 1 insertion(+)
```

Made a few more commits, then looked at the history:

```bash
echo "line 2" >> test.txt
git add test.txt && git commit -m "add line 2"

echo "line 3" >> test.txt
git add test.txt && git commit -m "add line 3"

git log --oneline
# a1b2c3d add line 3
# e5f6g7h add line 2
# i9j0k1l add test.txt
```

The log shows commits newest-first. I like `--oneline` — much easier to read.

**Got stuck on:** I tried `git commit` without `-m` the first time — it opened vim. I had no idea how to exit. Had to look up `:wq`.

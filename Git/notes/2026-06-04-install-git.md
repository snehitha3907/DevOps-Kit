# Installing Git — first try

I'm on Ubuntu (WSL). I checked if Git was already installed by running `git --version`. It wasn't. So I ran:

```bash
sudo apt update
sudo apt install git -y
git --version
# git version 2.43.0
```

It installed clean. No errors.

Next I needed to tell Git who I am — it won't let you commit without a name and email:

```bash
git config --global user.name "My Name"
git config --global user.email "me@example.com"
```

Checked the config with `git config --list`. The values showed up. I also spotted that the default branch name on this version is `master` — newer Git lets you set it to `main` instead. I'll set that later when I init my first repo.

**Got stuck on:** nothing really. The install was straightforward. I forgot the `-y` flag the first time — it paused asking for confirmation. Easy fix.

**What I'd try next:** Initialize a real repo and start making commits.

---
last_verified: 2026-11-01
tool_version: "Bash 5.3, GNU Coreutils 9.12, GNU nano 9.3"
sources:
  - https://www.redhat.com/en/blog/navigating-linux-filesystem
  - https://docs.rockylinux.org/books/learning_bash/05-tests/
  - https://github.com/LucaNerlich/lucanerlich.com/blob/main/docs/linux/beginners-guide/05-permissions-and-ownership.md
  - https://nano-editor.org/state.php
  - https://www.baeldung.com/linux/cd-without-permission
---

# Find your way around the lab shell

You are about to spend most of your DevOps life in a terminal. This lesson gets you comfortable moving around the filesystem, reading files, checking whether a command succeeded, and fixing permissions when it did not.

## What you'll learn

- Navigate directories, inspect and edit files from the command line
- Read a command's exit code and explain what non-zero means
- Change file permissions and ownership and verify the result

## Before you start

- [Linux and system administration — the basics](../../docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md) — what the filesystem, users and permissions are.
- A Linux shell with Bash and GNU coreutils (preinstalled on most distros). Confirm with `bash --version` and `ls --version`.
- `nano` for editing. If it is missing, install it with `sudo apt install nano` or `sudo dnf install nano`.
- Use `sudo` for `chown` on files you do not own.

## Walkthrough

1. Find out where you are and move around.

   ```bash
   pwd
   cd /tmp
   pwd
   cd -
   pwd
   cd
   pwd
   ```

   You should see: the first `pwd` prints your starting directory; `cd /tmp` changes to the root of temporary files; `cd -` prints the previous directory and returns you to it; `cd` with no argument takes you home.

2. List files, including the ones that start with a dot.

   ```bash
   ls
   ls -l
   ls -a
   ls -la
   ```

   You should see: `ls -l` shows permissions, link count, owner, group, size and mtime; `ls -a` adds hidden dotfiles; `ls -la` combines both.

3. Inspect and edit a file.

   ```bash
   cd /tmp
   printf 'hello\n' > greeting.txt
   cat greeting.txt
   less greeting.txt
   nano greeting.txt
   ```

   You should see: `cat` prints the whole file; `less` pages through large files (press `q` to quit); in `nano`, press `^O` then Enter to save and `^X` to exit.

4. Read an exit code.

   ```bash
   true
   echo $?
   false
   echo $?
   ls /no-such-path
   echo $?
   ```

   You should see: `0` after `true` (success); `1` after `false`; `2` after the missing path. Any non-zero value means the command failed. `126` means a file was found but is not executable, `127` means command not found, and `128+N` means the process was killed by signal (130 = Ctrl+C, 137 = kill -9).

5. Change permissions and ownership, then verify.

   ```bash
   touch lab.txt
   chmod 600 lab.txt
   ls -l lab.txt
   chmod u+x lab.txt
   ls -l lab.txt
   stat lab.txt
   ```

   You should see: `600` produces `-rw-------` (only the owner can read and write); after `u+x` the owner also has execute. `stat` prints the same information in a readable form.

6. Fix a directory so you can enter it.

   ```bash
   mkdir -p /tmp/perm-lab/sub
   chmod 644 /tmp/perm-lab/sub
   cd /tmp/perm-lab/sub
   chmod 755 /tmp/perm-lab/sub
   cd /tmp/perm-lab/sub && pwd
   ```

   You should see: the first `cd` fails with `Permission denied` because the directory lost its execute bit; after `chmod 755` you can enter it. Directories need the execute bit to be traversable.

## Exercise

Working in `/tmp/scratchpad` (create it if needed):

1. Create a file `secret.txt` and make it readable and writable only by you.
2. Create a directory `shared/` and make it traversable and readable by everyone, but writable only by you.
3. Run a command that fails on purpose (for example `ls /does-not-exist`) and capture its exit code in a variable, then print a message that includes that code.
4. Open `secret.txt` in `nano`, add one line, save and exit.
5. Verify the final state with `ls -l` and `stat`.

Do not leave the solution in the file; the point is the practice.

## Check your work

Run this and confirm the permissions match:

```bash
ls -l /tmp/scratchpad/secret.txt /tmp/scratchpad/shared
stat -c '%A %U:%G %n' /tmp/scratchpad/secret.txt /tmp/scratchpad/shared
```

You should see `secret.txt` as `-rw-------` owned by you, and `shared` as `drwxr-xr-x` owned by you.

## Common mistakes

- `cd: too many arguments` — an unquoted path containing spaces. Quote it (`cd "my dir"`) or escape the space (`cd my\ dir`).
- `bash: cd: /dir/subdir: Permission denied` — the directory lacks the execute bit. Fix with `chmod +x dir` or `chmod 755 dir` (as owner, or via `sudo`).
- `No such file or directory` — a typo or case mismatch; Linux paths are case-sensitive.
- `chmod: changing permissions of 'file.txt': Permission denied` — you are not the owner; use `sudo`.
- `chmod: invalid mode: '888'` — octal digits must be 0–7; use a valid mode such as `644`.
- `chmod: ... Operation not permitted` — the file may have the immutable attribute; check with `lsattr` and remove with `sudo chattr -i`.

## Next

[Manage processes and services with systemd](03-processes-and-services.md)

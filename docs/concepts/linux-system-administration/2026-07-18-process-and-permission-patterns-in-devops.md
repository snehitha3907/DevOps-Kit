---
last_verified: 2026-07-18
tool_version: n/a
---

# Linux process and file permission patterns in DevOps workflows

> Lab notes from 2026-07-18. I'm working through how permissions and processes show up day-to-day as a DevOps person — following the quickstart material and writing down what clicked and what tripped me up.

## What I was practicing

I started in a scratch `~/perm-lab` directory and ran through the basics: creating files, flipping permission bits, and owning files as root then reclaiming them.

The three permission classes (`u` owner, `g` group, `o` others) and the read/write/execute bits (`rwx` = 4/2/1) are the whole game. I kept mixing up `chmod 644` vs `chmod 600`, so I wrote it out:

- `600` → `-rw-------` only the owner can read/write (good for secrets, ssh keys)
- `644` → `-rw-r--r--` owner writes, everyone reads (normal config files)
- `755` → `-rwxr-xr-x` owner full, others can read/enter (scripts, dirs)

## Where I got stuck

I tried `sudo chown root:root` on a file I made, then couldn't `rm` it as myself — of course, because deleting depends on the *directory's* write permission, not the file's. Re-`chown`ing it back to my user fixed it. That was the moment the "permissions live on the directory for deletion" idea actually landed.

`chmod` symbolic mode (`u+x`, `go-r`) is far less error-prone than octal when I'm only changing one bit. I'll reach for symbolic mode while learning and only use octal when I know the full target state.

## Process management patterns

A lot of DevOps work is "is my service up, and can I restart it without drama":

- `ps -o pid,ppid,stat,cmd -p <pid>` — compact view of one process, including parent PID and state.
- `kill -TERM <pid>` first (asks the process to shut down and clean up), then `kill -KILL` only if it ignores the polite request.
- `ps --forest` — shows the parent/child tree so I can see what spawned what.

The `STAT` column matters: `R` running, `S` sleeping, `D` uninterruptible (usually IO), `Z` zombie. A pile of `D` or `Z` states is my hint that something downstream (disk, a dead child) is wedged.

## What this looks like in a pipeline

When a CI runner executes a job it's just a process tree under the runner. The job's working directory permissions decide whether it can write artifacts, and a stuck `sleep`/build that ignores `TERM` is why pipelines sometimes hang until forced kill. Knowing `ps` + signal semantics is how I debug "why won't this job die" without nuking the whole runner.

## What I'd try next

- Tie this together with `systemd` units (how a service's `User=` and `Restart=` map to these same permission/signal ideas).
- Look at `nice`/`renice` for prioritizing a deploy job over a batch job on a shared box.

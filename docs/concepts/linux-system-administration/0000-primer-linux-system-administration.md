---
last_verified: 2026-07-12
tool_version: n/a
---

# Linux & System Administration — quick primer

> First-day notes on Linux and system administration. What it is, why it matters, and the key ideas to know.

## What is it?

Linux is an open-source operating system kernel that powers most of the internet. System administration is the practice of managing and maintaining computer systems — servers, user accounts, filesystems, processes, and services. Together, Linux system administration means keeping Linux machines running reliably.

I think of it like being the superintendent for digital infrastructure. I install software, monitor resource usage, restart things when they break, set up user access, and make sure scheduled tasks run.

## Why does it matter for DevOps?

Almost every tool I'll touch in DevOps runs on Linux. Docker containers share the Linux kernel. Kubernetes nodes are Linux machines. CI/CD runners execute on Linux. Cloud VMs are overwhelmingly Linux.

I need Linux admin skills to:
- Navigate the filesystem and read log files to debug failures
- Understand how processes work — starting, stopping, monitoring, signals
- Manage file permissions so containers and services can access what they need
- Install and configure software with package managers
- Control services that start on boot via systemd
- Connect to remote machines with SSH for troubleshooting

Without these basics, container debugging, server provisioning, and writing automation scripts will all be harder.

## Key terminology

- **Kernel** — The core of the OS that manages hardware, processes, and memory. Linux is technically just the kernel; the rest of the system tools make up a distribution.
- **Shell** — The command-line interpreter I use to run commands. Bash is the most common, but zsh and sh are also widespread.
- **Filesystem** — The tree of directories rooted at `/`. Key places: `/etc/` for config files, `/var/log/` for logs, `/tmp/` for temp files, `/home/` for users.
- **Process** — A running program with a unique PID. I list them with `ps`, monitor with `top` or `htop`, and send signals with `kill`.
- **File permissions** — Every file has read (r), write (w), execute (x) flags for owner, group, and others. `chmod` changes them, `chown` changes ownership.
- **Package manager** — Installs, updates, and removes software. `apt` on Debian/Ubuntu, `dnf` on Fedora/RHEL.
- **systemd** — The init system that boots the OS and manages services. I use `systemctl start/stop/enable/status` to control things like nginx or docker.
- **SSH** — Secure Shell for remote login. `ssh user@host` connects me to a remote machine's shell.
- **cron** — A scheduler that runs commands at specified times. Used for backups, log rotation, and periodic maintenance.

## A concrete example

Here's what I run when a server feels slow:

```bash
# How much disk space is left?
df -h

# Is memory exhausted?
free -m

# What's eating the CPU?
ps aux --sort=-%cpu | head -10

# Any errors in the logs?
journalctl -p err --since "1 hour ago"

# Restart the likely culprit
sudo systemctl restart nginx
```

This one sequence covers the core admin loop: check resources, find the problem, read logs, fix it.

## How this connects to what's next

Linux system administration is the layer under everything. Docker uses Linux namespaces and cgroups for containers. Kubernetes manages Linux nodes and pods. Ansible automates remote configuration over SSH. Terraform provisions Linux VMs. A solid grasp of Linux basics makes every downstream DevOps tool clearer.

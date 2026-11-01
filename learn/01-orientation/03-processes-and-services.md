---
last_verified: 2026-11-01
tool_version: "systemd 262.1"
sources:
  - https://github.com/systemd/systemd/releases/tag/v262.1
---

# Manage processes and services with systemd

You have already learned your way around the lab shell. Now you will manage processes and services with systemd, the standard init system on modern Linux distributions. This lesson builds on your shell navigation skills and introduces you to the tool that powers most Linux service management.

## What you'll learn

- List, signal and stop processes using `ps`, `kill`, `pkill`, and `killall`
- Start, stop and enable a systemd service and read its logs with `journalctl`

## Before you start

- [Linux and system administration — the basics](../../docs/concepts/linux-system-administration/0000-primer-linux-system-administration.md) — what the filesystem, users and permissions are.
- [Find your way around the lab shell](02-shell-navigation.md) — basic shell navigation skills.
- A Linux shell with Bash and GNU coreutils (preinstalled on most distros). Confirm with `bash --version` and `ls --version`.
- `systemd` is installed and running. Confirm with `systemctl --version`.
- `journalctl` is available for reading service logs.

## Walkthrough

1. List running processes.

   ```bash
   ps aux
   ```

   You should see: a table of all processes running on the system, with columns for user, PID, CPU usage, memory, and command.

2. Stop a process using `kill`.

   ```bash
   pkill -f "sleep 9999"
   ```

   You should see: the process is terminated; verify with `ps aux | grep sleep`.

3. Start a systemd service.

   ```bash
   systemctl start sshd
   ```

   You should see: `Active: active (running)` when you query the service status.

4. Enable a systemd service so it starts at boot.

   ```bash
   systemctl enable sshd
   ```

   You should see: a symlink created under `/etc/systemd/system/multi-user.wants/`.

5. Read logs for a systemd service with `journalctl`.

   ```bash
   journalctl -u sshd
   ```

   You should see: recent log lines from the `sshd` service.

## Exercise

Working with systemd:

1. List the processes owned by the current user using `ps`.
2. Find the PID of a long-running process (such as `bash` or `sleep`) and use `kill` to terminate it.
3. Use `systemctl` to check the status of the `cron` service.
4. Enable the `cron` service so it starts on boot.
5. Use `journalctl -u cron` to read the last 10 log entries from the cron service.

## Check your work

```bash
ps -u "$USER" | head -n 5
systemctl status cron
journalctl -u cron --no-pager | tail -n 10
```

You should see: a list of your user's processes; the cron service status showing `active (running)` or `inactive`; the last 10 log lines from cron.

## Common mistakes

- `ps aux` showing no processes — ensure you are not in a restricted container without a full init system.
- `systemctl start sshd` failing with "Unit not found" — the service name may be different (e.g., `httpd` or `apache2`) or the unit file is not installed.
- `journalctl -u sshd` showing no entries — verify the service has actually run and produced logs, or check with `journalctl --since "5 minutes ago"`.

## Next

[Scripting and automation — the basics](../../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md)
---
last_verified: 2026-11-01
tool_version: n/a
---

# Manage processes and services with systemd

The previous lesson got you moving around the filesystem, reading files, and checking exit codes. Now you will look at what the machine is actually doing: which programs are running, how to signal and stop them, and how to manage the long-running services that systemd starts and keeps running on boot.

## What you'll learn

- List running processes, find a process by name, and signal or stop it.
- Start, stop, and enable a systemd service, and read its logs with journalctl.

## Before you start

- [Find your way around the lab shell](02-shell-navigation.md) — navigating the filesystem, reading exit codes, and fixing permissions.
- A Linux host where systemd is the init system (PID 1). Confirm with `ps -p 1 -o comm=`, which prints `systemd`.
- `sudo` access for starting, stopping, and enabling services.

## Walkthrough

1. List the running processes.

   ```bash
   ps aux
   ```

   You should see: a table with one line per process showing the owner, PID, CPU and memory use, and the command. The PID column is what you use to signal or stop a process.

2. Find the PID of a process by name.

   ```bash
   ps aux | grep sleep
   ```

   You should see: lines whose command contains `sleep`, each with a PID. The `grep sleep` line itself also matches — ignore it.

3. Stop a process with its PID. Start a short-lived process first so you have a safe target:

   ```bash
   sleep 300 &
   SLEEP_PID=$!
   echo $SLEEP_PID
   kill $SLEEP_PID
   ps -p $SLEEP_PID
   ```

   You should see: `echo $SLEEP_PID` prints the background job's PID; after `kill`, `ps -p $SLEEP_PID` prints an error such as "No such process" because the process has stopped.

   `kill` without a flag sends the default TERM signal, asking the process to shut down cleanly. Use `kill -9 <pid>` only as a last resort when a process ignores TERM.

4. Confirm systemd is running and list its services.

   ```bash
   ps -p 1 -o comm=
   systemctl list-units --type=service --no-pager | head -20
   ```

   You should see: `systemd` from the first command, and a list of loaded services from the second.

5. Start, stop, and enable a service. Pick a service installed on your host (for example `ssh` or `cron`), then check it first:

   ```bash
   systemctl status ssh --no-pager
   ```

   If the service exists, manage it:

   ```bash
   sudo systemctl start ssh
   sudo systemctl stop ssh
   sudo systemctl enable ssh
   ```

   You should see: `start` and `stop` run without error; `enable` prints a symlink message such as "Created symlink .../ssh.service → .../systemd/multi-user.target.wants/ssh.service", meaning the service will start on boot.

   `enable` only arranges boot-time startup; it does not start the service right now. Use `sudo systemctl enable --now ssh` to enable and start in one step.

6. Read a service's logs with journalctl.

   ```bash
   sudo journalctl -u ssh -n 20 --no-pager
   ```

   You should see: the most recent 20 log lines for the `ssh` service, each with a timestamp, hostname, service name, and message. To follow logs live, add `-f`; to limit by time, add `--since "1 hour ago"`.

## Exercise

Working on your lab host:

1. Start a background process you fully control, for example `sleep 600 &`, and note its PID.
2. Confirm it is running with `ps`, then stop it with `kill <pid>`.
3. Confirm it is gone with `ps -p <pid>`.
4. Pick a service installed on your host (suggest `ssh` or `cron`; confirm with `systemctl status <service>` first).
5. Start it with `sudo systemctl start <service>`, stop it with `sudo systemctl stop <service>`, and enable it for boot with `sudo systemctl enable <service>`.
6. Read its latest logs with `sudo journalctl -u <service> -n 10 --no-pager`.

Do not paste the solution here; the point is the practice.

## Check your work

```bash
ps -p 1 -o comm=
pgrep sleep; echo "exit=$?"
systemctl is-active ssh; systemctl is-enabled ssh
sudo journalctl -u ssh -n 5 --no-pager
```

You should see:

- `systemd` (PID 1 is systemd).
- `exit=1` from `pgrep sleep` after you killed it (the process no longer exists).
- `active` or `inactive` from `systemctl is-active ssh` reflecting the last `start`/`stop` you ran, and `enabled` from `systemctl is-enabled ssh`.
- Recent log lines for the `ssh` service from `journalctl`.

Substitute your chosen service name for `ssh` throughout.

## Common mistakes

- `kill` without a flag sends TERM. Some processes ignore it; if the process is still alive afterward, use `kill -9 <pid>` as a last resort.
- `ps aux | grep <name>` also matches the `grep` process itself. Prefer `pgrep <name>` or `grep [s]leep`.
- `systemctl start/stop/enable` requires `sudo`; without it you get "Authentication required" or "Access denied".
- `systemctl enable <service>` starts the service on boot only; it does not start it now. Pair it with `start`, or use `enable --now`.
- `journalctl -u <service>` prints nothing if the service has never written to the journal or the name is wrong — double-check with `systemctl status <service>`.

## Next

[Scripting and automation — the basics](../../docs/concepts/scripting-automation-bash-python/0000-primer-scripting-automation-bash-python.md)

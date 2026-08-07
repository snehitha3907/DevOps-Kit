---
last_verified: 2026-08-07
tool_version: n/a
---

# systemd timers + journald forwarding for audit-ready workflows

## Purpose

For operators who need scheduled, auditable system maintenance, combining
systemd timers with journald log forwarding provides a cron alternative that
offers better observability and retention. Timers schedule recurring probe
jobs; journald captures structured output from those jobs and forwards it
off-host so audit records survive machine rebuilds or log rotation. This is one
approach — systemd also ships `journal-remote` and `journal-upload` as
alternatives if a full syslog stack is not available.

## Prerequisites

- A systemd-based Linux host
- Root or sudo access for installing unit files under `/etc/systemd/system/`
- A remote syslog collector reachable from the host (rsyslog receiver, cloud
  log endpoint, or a second systemd host running `journal-remote`)

## Steps

### 1. Create the scheduled probe script

Write the audit probe to a standalone script so it can be tested independently
of systemd:

```bash
#!/bin/bash
# /usr/local/sbin/audit-probe.sh
logger -t audit-probe "probe started at $(date -Iseconds) on $(hostname)"
uptime | logger -t audit-probe --
logger -t audit-probe "probe finished at $(date -Iseconds)"
```

### 2. Define the systemd service unit

Create `/etc/systemd/system/audit-probe.service`:

```ini
[Unit]
Description=Audit probe for system state
Wants=network-online.target
After=network-online.target

[Service]
Type=oneshot
ExecStart=/usr/local/sbin/audit-probe.sh
StandardOutput=journal
StandardError=journal
```

### 3. Schedule it with a timer

Create `/etc/systemd/system/audit-probe.timer`:

```ini
[Unit]
Description=Run audit probe hourly

[Timer]
OnCalendar=hourly
Persistent=true
Unit=audit-probe.service

[Install]
WantedBy=timers.target
```

`Persistent=true` ensures missed runs (while the machine was off) fire on the
next boot — important for audit gap coverage.

### 4. Configure journald to forward to syslog

Add a drop-in at `/etc/systemd/journald.conf.d/forward-to-syslog.conf`:

```ini
[Journal]
ForwardToSyslog=yes
MaxRetentionSec=1month
SystemMaxUse=500M
```

Then configure rsyslog to match journald entries tagged `audit-probe` and
forward them. Create `/etc/rsyslog.d/90-audit-forward.conf`:

```
:syslogtag, isequal, "audit-probe: " @@logs.example.com:514
& stop
```

The `@@logs.example.com:514` line uses TCP (`@@`) for reliable delivery. The
`& stop` directive discards matched entries locally so they are not written to
disk twice.

### 5. Reload and enable

```bash
systemctl daemon-reload
systemctl enable --now audit-probe.timer
```

## Verify

Confirm the timer is registered and produces journald entries:

```bash
systemctl list-timers audit-probe.timer
journalctl -t audit-probe --since "5 min ago"
```

On the remote syslog collector, verify forwarded entries arrive:

```bash
grep audit-probe /var/log/syslog
```

## Common errors

- **Timer fires at wrong times**: `OnCalendar=hourly` uses the host's timezone.
  If the timezone is misconfigured, the timer fires at unexpected wall-clock
  times. `timedatectl status` reveals the active zone.
- **Logs never reach the remote collector**: journald only forwards to syslog
  when `ForwardToSyslog=yes` AND rsyslog is running with `imjournal` or
  `imuxsock` loaded. Without the matching rsyslog module, entries stay local.
- **Duplicate entries on disk**: the `& stop` rule in the rsyslog config is
  required. Without it, forwarded entries that match the tag also get written
  to `/var/log/syslog` locally, creating duplicates.

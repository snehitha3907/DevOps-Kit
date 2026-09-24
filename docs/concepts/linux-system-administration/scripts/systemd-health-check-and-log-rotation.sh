#!/usr/bin/env bash
# last_verified: 2026-09-24 · bash n/a · systemd n/a · logrotate n/a

# Automated server health checks and log rotation with systemd
# Concept L3 exercise for Linux & System Administration
#
# This is one way to wire the two recurring sysadmin tasks — "is the server
# actually healthy?" and "are the logs growing unbounded?" — into systemd
# instead of cron. A systemd timer drives a health-check service on a fixed
# interval, and a second timer drives logrotate so rotation is visible in
# `systemctl status` rather than hidden in a cron log. The health check
# writes a one-line status file that a monitoring system can tail.
#
# This is one way to do it; alternatives include a cron job for both, or
# logrotate's own daily cron trigger with a separate health check in a
# monitoring agent. The systemd approach makes the schedule and the failure
# behaviour visible to `systemctl`.

set -euo pipefail

SERVICE_NAME="server-health-check"
TIMER_NAME="${SERVICE_NAME}.timer"
UNIT_DIR="/etc/systemd/system"
HEALTH_SCRIPT="/usr/local/bin/${SERVICE_NAME}.sh"
HEALTH_INTERVAL="1m"
LOGROTATE_INTERVAL="daily"
LOGROTATE_CONF="/etc/logrotate.d/server-health"
HEALTH_LOG="/var/log/server-health.log"
HEALTH_STATUS="/run/${SERVICE_NAME}.status"

# ---------------------------------------------------------------------------
# 1. Write the health-check script the service will run.
# ---------------------------------------------------------------------------
write_health_script() {
    cat > "${HEALTH_SCRIPT}" <<'EOF'
#!/usr/bin/env bash
# last_verified: 2026-09-24
# One-line-per-run health check: load, memory, disk, and a trivial service
# probe. Writes "OK" or "FAIL <reason>" to the status file.
set -u
STATUS_FILE="/run/server-health-check.status"

load=$(awk '{print $1*100/NR}' /proc/loadavg 2>/dev/null || echo 0)
mem=$(awk '/MemAvailable/ {printf "%.0f", $2*100/$1} /proc/meminfo 2>/dev/null || echo 100)
root_pct=$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}')

reason="ok"
if (( $(echo "$load > 4.0" | bc -l) )); then reason="high-load"; fi
if (( mem < 20 )); then reason="low-memory"; fi
if (( root_pct > 90 )); then reason="disk-full"; fi

if [ "$reason" = "ok" ]; then
    echo "OK load=${load}% mem=${mem}% root=${root_pct}%" > "${STATUS_FILE}"
else
    echo "FAIL ${reason} load=${load}% mem=${mem}% root=${root_pct}%" > "${STATUS_FILE}"
fi
EOF
    chmod 0755 "${HEALTH_SCRIPT}"
}

# ---------------------------------------------------------------------------
# 2. Write the logrotate config the timer will invoke.
# ---------------------------------------------------------------------------
write_logrotate_conf() {
    cat > "${LOGROTATE_CONF}" <<EOF
${HEALTH_LOG} {
    rotate 7
    ${LOGROTATE_INTERVAL}
    compress
    delaycompress
    missingok
    notifempty
    copytruncate
}
EOF
}

# ---------------------------------------------------------------------------
# 3. Install the service, timer, and logrotate config.
# ---------------------------------------------------------------------------
install_units() {
    write_health_script
    write_logrotate_conf

    cat > "${UNIT_DIR}/${SERVICE_NAME}.service" <<EOF
[Unit]
Description=Server health check
After=network.target

[Service]
Type=oneshot
ExecStart=${HEALTH_SCRIPT}
EOF

    cat > "${UNIT_DIR}/${TIMER_NAME}" <<EOF
[Unit]
Description=Run server health check every ${HEALTH_INTERVAL}

[Timer]
OnCalendar=*:0/${HEALTH_INTERVAL}
Persistent=true

[Install]
WantedBy=timers.target
EOF

    systemctl daemon-reload
    systemctl enable --now "${TIMER_NAME}"
}

# ---------------------------------------------------------------------------
# 4. Verify the units are active and the status file is being written.
# ---------------------------------------------------------------------------
verify() {
    echo "--- systemd units ---"
    systemctl list-units --type=timer --no-pager | grep -F "${TIMER_NAME}" || true
    echo "--- latest health status ---"
    if [ -f "${HEALTH_STATUS}" ]; then
        cat "${HEALTH_STATUS}"
    else
        echo "no status file yet (first run pending)"
    fi
    echo "--- logrotate config ---"
    if [ -f "${LOGROTATE_CONF}" ]; then
        echo "installed: ${LOGROTATE_CONF}"
    else
        echo "MISSING: ${LOGROTATE_CONF}"
        return 1
    fi
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------
if [ "${1:-}" = "install" ]; then
    install_units
    verify
elif [ "${1:-}" = "verify" ]; then
    verify
else
    echo "Usage: $0 {install|verify}" >&2
    exit 1
fi
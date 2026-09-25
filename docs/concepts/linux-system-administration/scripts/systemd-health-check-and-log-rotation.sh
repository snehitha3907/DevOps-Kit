#!/usr/bin/env bash
# last_verified: 2026-09-24 · bash n/a · systemd n/a · logrotate n/a

# Automated server health checks and log rotation with systemd
# Concept L3 exercise for Linux & System Administration
#
# This is one way to wire the two recurring sysadmin tasks — "are the box
# resources healthy?" and "are the logs growing unbounded?" — into systemd
# instead of cron. A systemd timer drives a resource health-check service
# every minute, and a second daily timer drives logrotate so rotation shows
# up in `systemctl status` rather than hidden in a cron log. The health check
# writes a one-line status file that a monitoring system can tail.
#
# This is one way to do it; alternatives include a cron job for both, or
# logrotate's own daily cron trigger with a separate health check in a
# monitoring agent. The systemd approach makes the schedule and the failure
# behaviour visible to `systemctl`.
#
# How this differs from systemd-health-check-log-alerting.sh in the same
# directory: that script watches service liveness (is the unit active, does
# the HTTP /health endpoint answer, journal alerting on failure). This one
# watches box resources instead (load average, available memory, root-disk
# use) and pairs the check with log rotation driven by its own timer.

set -euo pipefail

SERVICE_NAME="server-health-check"
TIMER_NAME="${SERVICE_NAME}.timer"
ROTATE_SERVICE_NAME="server-health-logrotate"
ROTATE_TIMER_NAME="${ROTATE_SERVICE_NAME}.timer"
UNIT_DIR="/etc/systemd/system"
HEALTH_SCRIPT="/usr/local/bin/${SERVICE_NAME}.sh"
HEALTH_INTERVAL="1min"
LOGROTATE_INTERVAL="daily"
LOGROTATE_CONF="/etc/logrotate.d/server-health"
HEALTH_LOG="/var/log/server-health.log"
HEALTH_STATUS="/run/${SERVICE_NAME}.status"

# ---------------------------------------------------------------------------
# 1. Write the health-check script the service will run.
#
# Resource check, not a liveness check: 1-minute load average, available
# memory as a share of total memory, and root-filesystem use. Writes
# "OK" or "FAIL <reason>" to the status file. Uses only awk/df integer
# math — no bc dependency.
# ---------------------------------------------------------------------------
write_health_script() {
    cat > "${HEALTH_SCRIPT}" <<'EOF'
#!/usr/bin/env bash
# last_verified: 2026-09-24
# Resource health check: load, memory, disk. Writes "OK" or "FAIL <reason>"
# to the status file for a monitoring system to tail.
set -u
STATUS_FILE="/run/server-health-check.status"

load1=$(awk '{print $1}' /proc/loadavg 2>/dev/null || echo "0.00")
load_scaled=$(awk -v l="${load1}" 'BEGIN { printf "%d", (l * 100) }' 2>/dev/null || echo "0")
mem_avail=$(awk '/^MemAvailable:/ { print $2 }' /proc/meminfo 2>/dev/null || echo "0")
mem_total=$(awk '/^MemTotal:/ { print $2 }' /proc/meminfo 2>/dev/null || echo "1")
mem_avail_pct=0
if [ "${mem_total}" -gt 0 ] 2>/dev/null; then
    mem_avail_pct=$(( mem_avail * 100 / mem_total ))
fi
root_pct=$(df -P / | awk 'NR==2 {gsub(/%/,"",$5); print $5}')

reason="ok"
if [ "${load_scaled}" -gt 400 ]; then reason="high-load"; fi
if [ "${mem_avail_pct}" -lt 20 ]; then reason="low-memory"; fi
if [ "${root_pct}" -gt 90 ] 2>/dev/null; then reason="disk-full"; fi

if [ "${reason}" = "ok" ]; then
    echo "OK load=${load1} mem_avail=${mem_avail_pct}% root=${root_pct}%" > "${STATUS_FILE}"
else
    echo "FAIL ${reason} load=${load1} mem_avail=${mem_avail_pct}% root=${root_pct}%" > "${STATUS_FILE}"
fi
EOF
    chmod 0755 "${HEALTH_SCRIPT}"
}

# ---------------------------------------------------------------------------
# 2. Write the logrotate config the rotate timer will invoke.
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
# 3. Install the services, timers, and logrotate config.
#
# The health-check timer uses monotonic triggers (OnBootSec plus
# OnUnitActiveSec) rather than a calendar expression, so it fires every
# minute from boot without calendar-syntax pitfalls. The rotate timer runs
# logrotate once a day via its own oneshot service.
# ---------------------------------------------------------------------------
install_units() {
    write_health_script
    write_logrotate_conf

    cat > "${UNIT_DIR}/${SERVICE_NAME}.service" <<EOF
[Unit]
Description=Server resource health check
After=network.target

[Service]
Type=oneshot
ExecStart=${HEALTH_SCRIPT}
EOF

    cat > "${UNIT_DIR}/${TIMER_NAME}" <<EOF
[Unit]
Description=Run server resource health check every ${HEALTH_INTERVAL}

[Timer]
OnBootSec=${HEALTH_INTERVAL}
OnUnitActiveSec=${HEALTH_INTERVAL}
AccuracySec=10s
Persistent=true

[Install]
WantedBy=timers.target
EOF

    cat > "${UNIT_DIR}/${ROTATE_SERVICE_NAME}.service" <<EOF
[Unit]
Description=Rotate server health logs
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/sbin/logrotate ${LOGROTATE_CONF}
EOF

    cat > "${UNIT_DIR}/${ROTATE_TIMER_NAME}" <<EOF
[Unit]
Description=Rotate server health logs daily

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF

    systemctl daemon-reload
    systemctl enable --now "${TIMER_NAME}"
    systemctl enable --now "${ROTATE_TIMER_NAME}"
}

# ---------------------------------------------------------------------------
# 4. Verify the units are active and the status file is being written.
# ---------------------------------------------------------------------------
verify() {
    echo "--- systemd units ---"
    systemctl list-units --type=timer --no-pager | grep -F -e "${TIMER_NAME}" -e "${ROTATE_TIMER_NAME}" || true
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

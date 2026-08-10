#!/usr/bin/env bash
# last_verified: 2026-08-10

set -euo pipefail

SERVICE_NAME="devops-demo"
UNIT_DIR="/etc/systemd/system"
HEALTH_CHECK_INTERVAL="30s"
HEALTH_CHECK_RETRIES="3"
HEALTH_CHECK_TIMEOUT="10s"
LOG_ALERT_LEVEL="WARNING"

create_service_unit() {
    local unit_file="${UNIT_DIR}/${SERVICE_NAME}.service"
    if [[ -f "${unit_file}" ]]; then
        echo "Service unit already exists at ${unit_file}"
        return 1
    fi

    cat > "${unit_file}" <<EOF
[Unit]
Description=DevOps Demo Service
After=network.target
StartLimitIntervalSec=0
StartLimitBurst=${HEALTH_CHECK_RETRIES}

[Service]
Type=simple
ExecStart=/usr/local/bin/devops-demo
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

    echo "Created service unit at ${unit_file}"
}

create_health_check_unit() {
    local unit_file="${UNIT_DIR}/${SERVICE_NAME}-health.timer"
    local service_file="${UNIT_DIR}/${SERVICE_NAME}-health.service"

    if [[ -f "${unit_file}" ]]; then
        echo "Health timer already exists at ${unit_file}"
        return 1
    fi

    cat > "${unit_file}" <<EOF
[Unit]
Description=Run periodic health check for ${SERVICE_NAME}

[Timer]
OnBootSec=30
OnUnitActiveSec=${HEALTH_CHECK_INTERVAL}
AccuracySec=1s

[Install]
WantedBy=timers.target
EOF

    cat > "${service_file}" <<EOF
[Unit]
Description=Health check for ${SERVICE_NAME}
After=${SERVICE_NAME}.service

[Service]
Type=oneshot
ExecStart=/usr/local/bin/health-check.sh
EOF

    echo "Created health check timer and service"
}

create_health_check_script() {
    local script_path="/usr/local/bin/health-check.sh"
    if [[ -f "${script_path}" ]]; then
        echo "Health check script already exists at ${script_path}"
        return 1
    fi

    cat > "${script_path}" <<EOF
#!/usr/bin/env bash
set -euo pipefail

SERVICE_NAME="${SERVICE_NAME}"
ALERT_LEVEL="${LOG_ALERT_LEVEL}"
TIMEOUT="${HEALTH_CHECK_TIMEOUT}"

if ! systemctl is-active --quiet "\${SERVICE_NAME}"; then
    echo "\${ALERT_LEVEL}: \${SERVICE_NAME} is not active" | systemd-cat -t health-check -p "\${ALERT_LEVEL}"
    exit 1
fi

response=\$(curl -sf -o /dev/null -w "%{http_code}" --max-time "\${TIMEOUT}" http://localhost:8080/health || echo "000")
if [[ "\${response}" != "200" ]]; then
    echo "\${ALERT_LEVEL}: \${SERVICE_NAME} health endpoint returned \${response}" | systemd-cat -t health-check -p "\${ALERT_LEVEL}"
    exit 1
fi

echo "OK: \${SERVICE_NAME} health check passed" | systemd-cat -t health-check -p INFO
EOF

    chmod +x "${script_path}"
    echo "Created health check script at ${script_path}"
}

setup_log_alerting() {
    local dropin_dir="/etc/systemd/system/${SERVICE_NAME}.service.d"
    mkdir -p "${dropin_dir}"

    cat > "${dropin_dir}/alerting.conf" <<EOF
[Service]
LogLevelMax=${LOG_ALERT_LEVEL}
EOF

    echo "Configured log alerting drop-in at ${dropin_dir}/alerting.conf"
}

reload_systemd() {
    if ! systemctl daemon-reload; then
        echo "Failed to reload systemd daemon"
        return 1
    fi
    echo "Reloaded systemd daemon"
}

enable_and_start() {
    if ! systemctl enable "${SERVICE_NAME}.service"; then
        echo "Failed to enable ${SERVICE_NAME}.service"
        return 1
    fi

    if ! systemctl start "${SERVICE_NAME}.service"; then
        echo "Failed to start ${SERVICE_NAME}.service"
        journalctl -u "${SERVICE_NAME}.service" --no-pager -n 20 || true
        return 1
    fi

    if ! systemctl enable --now "${SERVICE_NAME}-health.timer"; then
        echo "Failed to enable health check timer"
        return 1
    fi

    echo "Service and health timer started"
}

verify_setup() {
    if ! systemctl is-active --quiet "${SERVICE_NAME}.service"; then
        echo "VERIFY FAILED: ${SERVICE_NAME}.service is not active"
        return 1
    fi

    if ! systemctl is-active --quiet "${SERVICE_NAME}-health.timer"; then
        echo "VERIFY FAILED: ${SERVICE_NAME}-health.timer is not active"
        return 1
    fi

    echo "VERIFY OK: service and health timer are active"
    journalctl -u "${SERVICE_NAME}-health.service" --no-pager -n 5 || true
}

main() {
    if [[ $# -lt 1 ]]; then
        cat <<EOF
Usage: $(basename "$0") <command>

Commands:
  install      Create unit files, health checks, and alerting
  verify       Check that service and timer are active
  uninstall    Remove unit files and disable timer
EOF
        exit 1
    fi

    local command="$1"
    shift || true

    case "${command}" in
        install)
            create_service_unit
            create_health_check_unit
            create_health_check_script
            setup_log_alerting
            reload_systemd
            enable_and_start
            ;;
        verify)
            verify_setup
            ;;
        uninstall)
            systemctl disable --now "${SERVICE_NAME}-health.timer" 2>/dev/null || true
            systemctl disable --now "${SERVICE_NAME}.service" 2>/dev/null || true
            rm -f "${UNIT_DIR}/${SERVICE_NAME}.service" \
                  "${UNIT_DIR}/${SERVICE_NAME}-health.timer" \
                  "${UNIT_DIR}/${SERVICE_NAME}-health.service" \
                  "/usr/local/bin/health-check.sh" \
                  "${UNIT_DIR}/${SERVICE_NAME}.service.d/alerting.conf"
            rmdir "${UNIT_DIR}/${SERVICE_NAME}.service.d" 2>/dev/null || true
            reload_systemd
            echo "Uninstalled ${SERVICE_NAME}"
            ;;
        *)
            echo "Unknown command: ${command}"
            exit 1
            ;;
    esac
}

main "$@"

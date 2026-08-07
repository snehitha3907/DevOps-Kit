#!/bin/bash
# last_verified: 2026-08-07 · systemd n/a
# systemd-managed watchdog: monitors a service, restarts on failure, and
# escalates to a journald CRITICAL alert when restarts exceed a threshold
# within a sliding window. Designed to run as its own systemd service.
set -euo pipefail

SERVICE="${1:?usage: $0 <service-name> [max_restarts] [window_secs]}"
MAX_RESTARTS="${2:-3}"
WINDOW_SECS="${3:-300}"
CHECK_INTERVAL=10

restarts=0
last_failure_epoch=0

log() {
    logger -t systemd-watchdog -p info -- "$SERVICE: $*"
}

page() {
    logger -t systemd-watchdog -p crit \
        -- "$SERVICE: ALERT escalation -- service failed to recover after $MAX_RESTARTS restarts within ${WINDOW_SECS}s; manual intervention required"
}

# --- guard: the target unit must exist ---
if ! systemctl list-unit-files "$SERVICE" >/dev/null 2>&1; then
    echo "error: unit '$SERVICE' not found" >&2
    exit 1
fi

log "watchdog started for $SERVICE (max_restarts=$MAX_RESTARTS, window=${WINDOW_SECS}s)"

# --- main monitoring loop ---
while true; do
    if ! systemctl is-active --quiet "$SERVICE"; then
        now=$(date +%s)

        # reset the restart counter if we are outside the sliding window
        if (( now - last_failure_epoch > WINDOW_SECS )); then
            restarts=0
        fi
        last_failure_epoch=$now

        if (( restarts < MAX_RESTARTS )); then
            restarts=$((restarts + 1))
            log "service not active -- attempting restart #$restarts/$MAX_RESTARTS"
            if systemctl restart "$SERVICE"; then
                log "restart succeeded"
                sleep "$CHECK_INTERVAL"
                continue
            else
                log "restart command returned non-zero -- will retry"
            fi
        else
            page
            log "escalated to journald CRITICAL; pausing before next cycle"
            restarts=0
            sleep "$WINDOW_SECS"
            continue
        fi
    fi

    sleep "$CHECK_INTERVAL"
done

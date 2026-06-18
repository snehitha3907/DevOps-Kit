#!/usr/bin/env bash
# docker-health-check-and-cleanup.sh
# Inspects health of running containers and removes dangling Docker resources
# (dangling images, stopped containers, unused networks) to reclaim disk space.

set -euo pipefail

health_check() {
    local running
    running=$(docker ps --format "{{.Names}}" 2>/dev/null) || {
        printf "ERROR: Cannot reach Docker daemon. Is it running?\n" >&2
        exit 1
    }

    if [[ -z "$running" ]]; then
        printf "No running containers to check.\n"
        return
    fi

    printf "%-30s %s\n" "CONTAINER" "HEALTH"
    printf "%-30s %s\n" "--------" "------"
    while IFS= read -r name; do
        local status
        status=$(docker inspect --format "{{.State.Health.Status}}" "$name" 2>/dev/null || echo "(no health check)")
        printf "%-30s %s\n" "$name" "$status"
    done <<< "$running"
}

cleanup() {
    printf "\nReclaiming disk space...\n"
    printf "  - dangling images:      "
    docker image prune -f
    printf "  - stopped containers:   "
    docker container prune -f
    printf "  - unused networks:      "
    docker network prune -f
    printf "\nDisk usage summary:\n"
    docker system df
}

health_check
cleanup

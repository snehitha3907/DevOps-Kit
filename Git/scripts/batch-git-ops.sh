#!/usr/bin/env bash
# batch-git-ops.sh — Run git operations across multiple repositories
#
# Purpose: Execute common git operations across all Git repositories
# found under a given parent directory. Useful for teams or developers
# managing multiple local checkouts of related projects.
#
# When to use:
#   - You maintain several repos in a monorepo-alternative layout
#   - You need to verify the state of all repos before a release
#   - You want to pull the latest changes across all projects at once
#
# Prerequisites:
#   - bash 4+ (for associative arrays where needed)
#   - git installed and accessible via PATH
#
# Usage:
#   ./batch-git-ops.sh [options] <parent-directory>
#
# Options:
#   -o, --operation <op>  Operation: status, pull, fetch, log, diff (default: status)
#   -d, --depth <n>       Max subdirectory depth to search (default: 2)
#   -b, --branch <name>   Only operate on repos with this branch checked out
#   -q, --quiet           Suppress per-repo headers
#   -h, --help            Show this message
#
# Examples:
#   ./batch-git-ops.sh ~/projects
#   ./batch-git-ops.sh -o fetch --depth 3 ~/projects
#   ./batch-git-ops.sh -o pull -b main ~/projects

set -euo pipefail

usage() {
    sed -n '2,30p' "$0" | sed 's/^# \?//'
    exit 0
}

detect_repos() {
    local parent="$1"
    local max_depth="$2"
    find "$parent" -maxdepth "$max_depth" -type d -name '.git' -prune | sed 's|/\.git$||' | sort
}

run_operation() {
    local repo="$1"
    local op="$2"
    local branch_filter="${3:-}"

    if [[ -n "$branch_filter" ]]; then
        local current_branch
        current_branch=$(git -C "$repo" rev-parse --abbrev-ref HEAD 2>/dev/null || true)
        if [[ "$current_branch" != "$branch_filter" ]]; then
            return 0
        fi
    fi

    case "$op" in
        status)
            git -C "$repo" status --short
            ;;
        pull)
            git -C "$repo" pull --ff-only --prune 2>&1
            ;;
        fetch)
            git -C "$repo" fetch --all --prune 2>&1
            ;;
        log)
            git -C "$repo" log --oneline -10
            ;;
        diff)
            git -C "$repo" diff --stat
            ;;
        *)
            echo "Unknown operation: $op"
            return 1
            ;;
    esac
}

main() {
    local operation="status"
    local max_depth=2
    local branch_filter=""
    local quiet=false

    while [[ $# -gt 0 ]]; do
        case "$1" in
            -o|--operation) operation="$2"; shift 2 ;;
            -d|--depth) max_depth="$2"; shift 2 ;;
            -b|--branch) branch_filter="$2"; shift 2 ;;
            -q|--quiet) quiet=true; shift ;;
            -h|--help) usage ;;
            *) break ;;
        esac
    done

    if [[ $# -lt 1 ]]; then
        echo "Error: parent directory required"
        usage
    fi

    local parent_dir="$1"

    if [[ ! -d "$parent_dir" ]]; then
        echo "Error: directory not found: $parent_dir"
        exit 1
    fi

    if ! command -v git &>/dev/null; then
        echo "Error: git is not installed or not in PATH"
        exit 1
    fi

    local repos=()
    while IFS= read -r repo; do
        repos+=("$repo")
    done < <(detect_repos "$parent_dir" "$max_depth")

    if [[ ${#repos[@]} -eq 0 ]]; then
        echo "No git repositories found under $parent_dir (depth=$max_depth)"
        exit 0
    fi

    for repo in "${repos[@]}"; do
        if [[ "$quiet" == false ]]; then
            echo "=== $repo ==="
        fi
        run_operation "$repo" "$operation" "$branch_filter"
        if [[ "$quiet" == false ]]; then
            echo ""
        fi
    done
}

main "$@"

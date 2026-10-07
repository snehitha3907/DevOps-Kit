#!/usr/bin/env bash
# last_verified: 2026-10-07 · Azure CLI 2.66.0

# Purpose: Find and delete Azure resource groups matching configurable criteria.
# When to use: Automate cleanup of temporary/stale resource groups in dev/test
# environments. Run on a schedule (cron, Azure Automation, GitHub Actions) to
# control costs and enforce naming/tagging policies.
# Prerequisites: Azure CLI authenticated (az login), appropriate RBAC permissions
# (Owner or Contributor on target subscriptions), jq for JSON parsing.

set -euo pipefail

# --- Configuration (override via env or flags) ---
SUBSCRIPTION_ID="${AZURE_SUBSCRIPTION_ID:-}"
DRY_RUN="${DRY_RUN:-true}"
NAME_PREFIX="${NAME_PREFIX:-rg-temp-}"
TAG_FILTER="${TAG_FILTER:-}"           # e.g. "environment=dev,owner=ci"
MAX_AGE_DAYS="${MAX_AGE_DAYS:-7}"       # delete groups older than this
EXCLUDE_TAG="${EXCLUDE_TAG:-protect=true}"  # groups with this tag are skipped
FORCE="${FORCE:-false}"                 # skip interactive confirmation
LOG_FILE="${LOG_FILE:-/var/log/azure-rg-cleanup.log}"

usage() {
  cat <<'EOF'
Usage: cleanup-resource-groups.sh [options]

Options:
  -s, --subscription ID     Azure subscription ID (default: AZURE_SUBSCRIPTION_ID)
  -p, --prefix PREFIX       Resource group name prefix to match (default: rg-temp-)
  -t, --tags "k=v,..."      Comma-separated tag filters (default: none)
  -a, --max-age DAYS        Max age in days before deletion (default: 7)
  -e, --exclude-tag "k=v"   Tag that protects a group from deletion (default: protect=true)
  -d, --dry-run             Simulate only, do not delete (default: true)
  -f, --force               Skip confirmation prompt (default: false)
  -l, --log-file PATH       Log file path (default: /var/log/azure-rg-cleanup.log)
  -h, --help                Show this help

Environment variables with same names as flags (uppercase, hyphens→underscores)
take precedence over defaults but are overridden by explicit flags.

Examples:
  # Dry-run, find groups starting with rg-temp- older than 7 days
  ./cleanup-resource-groups.sh

  # Actually delete, force mode, custom prefix and age
  DRY_RUN=false FORCE=true ./cleanup-resource-groups.sh -p rg-dev- -a 1

  # Filter by tags, protect groups tagged 'protect=true'
  TAG_FILTER="environment=dev,team=platform" ./cleanup-resource-groups.sh --dry-run=false
EOF
}

log() {
  local level="$1"; shift
  local msg="$*"
  local ts; ts="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
  echo "[$ts] [$level] $msg" | tee -a "$LOG_FILE"
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -s|--subscription) SUBSCRIPTION_ID="$2"; shift 2 ;;
      -p|--prefix) NAME_PREFIX="$2"; shift 2 ;;
      -t|--tags) TAG_FILTER="$2"; shift 2 ;;
      -a|--max-age) MAX_AGE_DAYS="$2"; shift 2 ;;
      -e|--exclude-tag) EXCLUDE_TAG="$2"; shift 2 ;;
      -d|--dry-run) DRY_RUN="$2"; shift 2 ;;
      -f|--force) FORCE="$2"; shift 2 ;;
      -l|--log-file) LOG_FILE="$2"; shift 2 ;;
      -h|--help) usage; exit 0 ;;
      *) log ERROR "Unknown option: $1"; usage; exit 1 ;;
    esac
  done
}

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || { log ERROR "Required command '$1' not found in PATH"; exit 1; }
}

check_prereqs() {
  require_cmd az
  require_cmd jq
  require_cmd date

  if [[ -z "$SUBSCRIPTION_ID" ]]; then
    SUBSCRIPTION_ID="$(az account show --query id -o tsv 2>/dev/null || true)"
    if [[ -z "$SUBSCRIPTION_ID" ]]; then
      log ERROR "No subscription ID provided and unable to determine from 'az account show'. Run 'az login' and 'az account set --subscription <id>' or pass -s."
      exit 1
    fi
  fi

  az account set --subscription "$SUBSCRIPTION_ID" >/dev/null
  log INFO "Using subscription: $SUBSCRIPTION_ID"
}

build_rg_query() {
  local prefix="$1"
  local tag_filter="$2"
  local exclude_tag="$3"

  # JMESPath query: filter by name prefix, then by tags
  local query="[?starts_with(name, '$prefix')]"

  if [[ -n "$tag_filter" ]]; then
    IFS=',' read -ra tags <<< "$tag_filter"
    for tag in "${tags[@]}"; do
      local key="${tag%%=*}"
      local val="${tag#*=}"
      query+=" | [?tags.\"$key\"=='$val']"
    done
  fi

  if [[ -n "$exclude_tag" ]]; then
    local ex_key="${exclude_tag%%=*}"
    local ex_val="${exclude_tag#*=}"
    query+=" | [?tags.\"$ex_key\"!='$ex_val' || tags.\"$ex_key\"==null]"
  fi

  echo "$query"
}

get_candidate_rgs() {
  local query; query="$(build_rg_query "$NAME_PREFIX" "$TAG_FILTER" "$EXCLUDE_TAG")"
  log DEBUG "JMESPath query: $query"

  az group list --query "$query" --output json | jq -c '.[]'
}

rg_age_days() {
  local created_time="$1"
  local now; now="$(date -u +%s)"
  local created; created="$(date -u -d "$created_time" +%s 2>/dev/null || date -u -j -f "%Y-%m-%dT%H:%M:%SZ" "$created_time" +%s 2>/dev/null || echo 0)"
  if [[ "$created" -eq 0 ]]; then
    echo 999999
    return
  fi
  echo $(( (now - created) / 86400 ))
}

confirm_deletion() {
  local rg_names=("$@")
  if [[ "$FORCE" == "true" ]]; then
    return 0
  fi
  echo "The following resource groups will be DELETED:"
  printf '  %s\n' "${rg_names[@]}"
  read -rp "Proceed? [y/N] " ans
  [[ "$ans" =~ ^[Yy]$ ]]
}

delete_rg() {
  local rg_name="$1"
  if [[ "$DRY_RUN" == "true" ]]; then
    log INFO "[DRY-RUN] Would delete resource group: $rg_name"
    return 0
  fi

  log INFO "Deleting resource group: $rg_name"
  if az group delete --name "$rg_name" --yes --no-wait; then
    log INFO "Deletion initiated for: $rg_name (async)"
    return 0
  else
    log ERROR "Failed to initiate deletion for: $rg_name"
    return 1
  fi
}

main() {
  parse_args "$@"
  check_prereqs

  log INFO "Starting resource group cleanup (dry_run=$DRY_RUN, prefix=$NAME_PREFIX, max_age=${MAX_AGE_DAYS}d)"

  local candidates=()
  local to_delete=()
  local protected=()

  while IFS= read -r rg_json; do
    [[ -z "$rg_json" ]] && continue
    local name; name="$(echo "$rg_json" | jq -r '.name')"
    local created; created="$(echo "$rg_json" | jq -r '.properties.provisioningState // "unknown"')"
    local created_time; created_time="$(echo "$rg_json" | jq -r '.managedBy // .tags.created // .tags.createdAt // empty')"

    # Fallback: try to get creation time from deployment history if no tag
    if [[ -z "$created_time" ]]; then
      created_time="$(az deployment group list --resource-group "$name" --query '[0].properties.timestamp' -o tsv 2>/dev/null || echo "")"
    fi
    if [[ -z "$created_time" ]]; then
      created_time="$(az group show --name "$name" --query 'tags.created' -o tsv 2>/dev/null || echo "")"
    fi

    local age_days=999999
    if [[ -n "$created_time" ]]; then
      age_days="$(rg_age_days "$created_time")"
    fi

    log DEBUG "Candidate: $name, age_days=$age_days, provisioning_state=$created"

    if [[ "$age_days" -ge "$MAX_AGE_DAYS" ]]; then
      candidates+=("$name")
    else
      log INFO "Skipping $name (age ${age_days}d < ${MAX_AGE_DAYS}d)"
      protected+=("$name")
    fi
  done < <(get_candidate_rgs)

  if [[ ${#candidates[@]} -eq 0 ]]; then
    log INFO "No resource groups matched cleanup criteria."
    exit 0
  fi

  log INFO "Matched ${#candidates[@]} resource group(s) for cleanup:"
  printf '  %s\n' "${candidates[@]}"

  if ! confirm_deletion "${candidates[@]}"; then
    log INFO "Deletion cancelled by user."
    exit 0
  fi

  local failed=0
  for rg in "${candidates[@]}"; do
    if ! delete_rg "$rg"; then
      ((failed++))
    fi
  done

  if [[ "$DRY_RUN" == "true" ]]; then
    log INFO "Dry-run complete. No resources were deleted. Run with DRY_RUN=false to execute."
  elif [[ $failed -eq 0 ]]; then
    log INFO "All ${#candidates[@]} resource group(s) deletion initiated successfully."
  else
    log ERROR "$failed of ${#candidates[@]} deletions failed."
    exit 1
  fi
}

main "$@"
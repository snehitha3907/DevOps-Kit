# last_verified: 2026-08-11 · CI/CD Concepts

set -euo pipefail

ARTIFACT_DIR="cicd-artifacts"
ENVIRONMENTS=("dev" "staging" "prod")
PROMOTE_STATE="$ARTIFACT_DIR/promote-state.json"
ROLLBACK_LOG="$ARTIFACT_DIR/rollback.log"

mkdir -p "$ARTIFACT_DIR"

log() {
  printf '[%s] %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$1"
}

fail() {
  log "FAIL: $1"
  exit 1
}

write_artifact() {
  local env="$1"
  local version="$2"
  local file="$ARTIFACT_DIR/${env}-${version}.tar.gz"
  printf 'version=%s\nbuilt_at=%s\n' "$version" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" > "$file"
  log "Wrote artifact $file"
}

read_artifact_version() {
  local file="$1"
  if [[ ! -f "$file" ]]; then
    fail "Artifact $file missing"
  fi
  grep '^version=' "$file" | cut -d= -f2
}

current_prod_version() {
  local prod_files=("$ARTIFACT_DIR"/prod-*.tar.gz)
  if [[ ! -e "${prod_files[0]}" ]]; then
    echo ""
    return
  fi
  read_artifact_version "${prod_files[0]}"
}

build() {
  local version="$1"
  log "Building artifact $version"
  write_artifact dev "$version"
  log "Build complete"
}

test() {
  local version="$1"
  local dev_file="$ARTIFACT_DIR/dev-${version}.tar.gz"
  log "Testing artifact $version"
  if [[ "$(read_artifact_version "$dev_file")" != "$version" ]]; then
    fail "Version mismatch in dev artifact"
  fi
  log "Tests passed"
}

promote() {
  local from="$1"
  local to="$2"
  local version="$3"
  local src="$ARTIFACT_DIR/${from}-${version}.tar.gz"
  local dst="$ARTIFACT_DIR/${to}-${version}.tar.gz"

  if [[ ! -f "$src" ]]; then
    fail "Cannot promote missing artifact $src"
  fi

  cp "$src" "$dst"
  log "Promoted $version from $from to $to"
}

rollback() {
  local target_version="$1"
  local src=""
  for env in "${ENVIRONMENTS[@]}"; do
    if [[ -f "$ARTIFACT_DIR/${env}-${target_version}.tar.gz" ]]; then
      src="$ARTIFACT_DIR/${env}-${target_version}.tar.gz"
      break
    fi
  done

  if [[ -z "$src" ]]; then
    fail "Rollback target $target_version not found in any environment"
  fi

  local current
  current="$(current_prod_version)"
  if [[ "$current" == "$target_version" ]]; then
    log "Prod already at $target_version, nothing to roll back"
    return
  fi

  cp "$src" "$ARTIFACT_DIR/prod-${target_version}.tar.gz"
  printf '%s rolled back from %s to %s\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$current" "$target_version" >> "$ROLLBACK_LOG"
  log "Rolled back production to $target_version"
}

pipeline() {
  local version="$1"
  log "=== Pipeline start for $version ==="

  build "$version"
  test "$version"

  promote dev staging "$version"
  promote staging prod "$version"

  log "=== Pipeline complete for $version ==="
}

verify() {
  local version="$1"
  local prod_file="$ARTIFACT_DIR/prod-${version}.tar.gz"

  if [[ ! -f "$prod_file" ]]; then
    fail "Verification failed: $prod_file absent"
  fi

  local actual
  actual="$(read_artifact_version "$prod_file")"
  if [[ "$actual" != "$version" ]]; then
    fail "Verification failed: expected $version, got $actual"
  fi

  log "Verification passed for $version"
}

main() {
  local version="${1:-v1.0.0}"
  pipeline "$version"
  verify "$version"

  if [[ "${2:-}" == "rollback-demo" ]]; then
    log "--- Rollback demo ---"
    build v1.0.1
    promote dev prod v1.0.1
    verify v1.0.1
    rollback v1.0.0
    verify v1.0.0
  fi
}

main "$@"

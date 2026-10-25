#!/usr/bin/env bash
# setup-aliases.sh — interactive Git alias installer
#
# Installs the Git workflow aliases from gitconfig into the user's
# global or local Git configuration.
#
# Usage: ./setup-aliases.sh [--global|--local] [--dry-run]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GITCONFIG_SOURCE="${SCRIPT_DIR}/gitconfig"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() {
  echo -e "${BLUE}info:${NC} $*"
}

success() {
  echo -e "${GREEN}success:${NC} $*"
}

warn() {
  echo -e "${YELLOW}warning:${NC} $*"
}

error() {
  echo -e "${RED}error:${NC} $*" >&2
}

usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

Options:
  --global      Install to global config (~/.gitconfig) [default]
  --local       Install to local repo config (.git/config)
  --dry-run     Show what would be installed without making changes
  --help        Show this help message

Examples:
  $0                  # Interactive global install
  $0 --global         # Explicit global install
  $0 --local          # Install to current repository only
  $0 --dry-run        # Preview changes
EOF
}

SCOPE="global"
DRY_RUN=false

while [ $# -gt 0 ]; do
  case "$1" in
    --global)
      SCOPE="global"
      shift
      ;;
    --local)
      SCOPE="local"
      shift
      ;;
    --dry-run)
      DRY_RUN=true
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      error "unknown option: $1"
      usage
      exit 1
      ;;
  esac
done

if [ ! -f "$GITCONFIG_SOURCE" ]; then
  error "source gitconfig not found: $GITCONFIG_SOURCE"
  exit 1
fi

if [ "$SCOPE" = "local" ]; then
  if ! git rev-parse --git-dir >/dev/null 2>&1; then
    error "not in a Git repository (--local requires a repo)"
    exit 1
  fi
  TARGET_CONFIG="$(git rev-parse --git-dir)/config"
else
  TARGET_CONFIG="$HOME/.gitconfig"
fi

info "Git alias installer"
info "Source: $GITCONFIG_SOURCE"
info "Target: $TARGET_CONFIG ($SCOPE)"
info "Dry run: $DRY_RUN"
echo ""

# Read aliases from source
ALIASES=$(grep -A 1000 '^\[alias\]' "$GITCONFIG_SOURCE" | tail -n +2 | sed -n '/^\[/q;p' | sed '/^$/d')

if [ -z "$ALIASES" ]; then
  error "no aliases found in source file"
  exit 1
fi

# Count aliases
ALIAS_COUNT=$(echo "$ALIASES" | grep -c '^\s*[a-z]')
info "Found $ALIAS_COUNT aliases to install"

if [ "$DRY_RUN" = true ]; then
  echo ""
  echo "Aliases that would be installed:"
  echo "${ALIASES//$'\n'/$'\n  '}"
  echo ""
  success "Dry run complete — no changes made"
  exit 0
fi

# Check if target config exists
if [ ! -f "$TARGET_CONFIG" ]; then
  warn "Target config does not exist, will create: $TARGET_CONFIG"
  touch "$TARGET_CONFIG"
fi

# Backup existing config
BACKUP="${TARGET_CONFIG}.bak.$(date +%Y%m%d%H%M%S)"
cp "$TARGET_CONFIG" "$BACKUP"
info "Backed up existing config to: $BACKUP"

# Check if [alias] section exists
if grep -q '^\[alias\]' "$TARGET_CONFIG"; then
  info "Existing [alias] section found — will append"
  # Remove existing aliases that we're about to add (to avoid duplicates)
  # Create a temp file with new aliases
  TEMP_FILE=$(mktemp)
  awk -v new_aliases="$ALIASES" '
    BEGIN { in_alias=0; printed=0 }
    /^\[alias\]/ { in_alias=1; print; next }
    in_alias && /^\[/ { in_alias=0 }
    in_alias && /^[a-z]/ { next }  # Skip existing alias lines
    { print }
    END {
      if (!printed) {
        print "[alias]"
        print new_aliases
      }
    }
  ' "$TARGET_CONFIG" > "$TEMP_FILE"
  mv "$TEMP_FILE" "$TARGET_CONFIG"
else
  info "No existing [alias] section — adding new section"
  {
    echo ""
    echo "[alias]"
    echo "$ALIASES"
  } >> "$TARGET_CONFIG"
fi

success "Aliases installed to $TARGET_CONFIG"
echo ""
info "You can now use aliases like:"
echo "  git co main"
echo "  git lg"
echo "  git feature my-feature"
echo "  git sync"
echo "  git pr"
echo ""
info "Run 'git config --list | grep alias' to verify"
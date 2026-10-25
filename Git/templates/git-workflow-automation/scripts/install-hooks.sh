#!/usr/bin/env bash
# install-hooks.sh — install Git workflow hooks
#
# Installs all hook scripts from the git-workflow-automation/hooks
# directory into the repository's .git/hooks/ directory.
#
# Usage: ./install-hooks.sh [--force] [--symlink]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HOOKS_SOURCE="${SCRIPT_DIR}/../hooks"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "")"
HOOKS_TARGET="${REPO_ROOT}/.git/hooks"

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
  --force     Overwrite existing hooks without prompting
  --symlink   Create symlinks instead of copying (default: copy)
  --help      Show this help message

Examples:
  $0                  # Interactive install (copy)
  $0 --force          # Force overwrite existing hooks
  $0 --symlink        # Create symlinks to source hooks
  $0 --force --symlink # Force symlink install
EOF
}

FORCE=false
SYMLINK=false

while [ $# -gt 0 ]; do
  case "$1" in
    --force)
      FORCE=true
      shift
      ;;
    --symlink)
      SYMLINK=true
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

if [ -z "$REPO_ROOT" ]; then
  error "not in a Git repository"
  exit 1
fi

if [ ! -d "$HOOKS_SOURCE" ]; then
  error "hooks source directory not found: $HOOKS_SOURCE"
  exit 1
fi

if [ ! -d "$HOOKS_TARGET" ]; then
  error "Git hooks directory not found: $HOOKS_TARGET"
  exit 1
fi

info "Installing Git hooks"
info "Source: $HOOKS_SOURCE"
info "Target: $HOOKS_TARGET"
info "Method: $( [ "$SYMLINK" = true ] && echo "symlink" || echo "copy" )"
echo ""

HOOKS=(
  "pre-commit"
  "commit-msg"
  "pre-push"
  "pre-rebase"
  "post-commit"
  "post-checkout"
  "prepare-commit-msg"
  "pre-merge-commit"
)

INSTALLED=0
SKIPPED=0
FAILED=0

for hook in "${HOOKS[@]}"; do
  SOURCE_FILE="${HOOKS_SOURCE}/${hook}"
  TARGET_FILE="${HOOKS_TARGET}/${hook}"

  if [ ! -f "$SOURCE_FILE" ]; then
    warn "hook not found in source: $hook"
    continue
  fi

  if [ -e "$TARGET_FILE" ] || [ -L "$TARGET_FILE" ]; then
    if [ "$FORCE" = true ]; then
      rm -f "$TARGET_FILE"
    else
      warn "hook already exists: $hook (use --force to overwrite)"
      SKIPPED=$((SKIPPED + 1))
      continue
    fi
  fi

  if [ "$SYMLINK" = true ]; then
    ln -sf "$SOURCE_FILE" "$TARGET_FILE"
    info "symlinked: $hook"
  else
    cp "$SOURCE_FILE" "$TARGET_FILE"
    chmod +x "$TARGET_FILE"
    info "copied: $hook"
  fi

  INSTALLED=$((INSTALLED + 1))
done

echo ""
success "Installed: $INSTALLED hooks"
if [ "$SKIPPED" -gt 0 ]; then
  warn "Skipped: $SKIPPED hooks (already existed)"
fi
if [ "$FAILED" -gt 0 ]; then
  error "Failed: $FAILED hooks"
  exit 1
fi

# Also install commitlint config if not present
if [ ! -f "${REPO_ROOT}/.commitlintrc.json" ]; then
  info "Creating default .commitlintrc.json"
  cat > "${REPO_ROOT}/.commitlintrc.json" <<'EOF'
{
  "extends": ["@commitlint/config-conventional"],
  "rules": {
    "type-enum": [2, "always", ["feat", "fix", "docs", "style", "refactor", "perf", "test", "chore", "ci", "build", "revert"]],
    "subject-case": [2, "always", "sentence-case"],
    "subject-empty": [2, "never"],
    "subject-max-length": [2, "always", 72],
    "body-leading-blank": [1, "always"],
    "footer-leading-blank": [1, "always"]
  }
}
EOF
  success "Created .commitlintrc.json"
fi

# Install labeler config for GitHub Actions if not present
LABELER_FILE="${REPO_ROOT}/.github/labeler.yml"
if [ ! -f "$LABELER_FILE" ]; then
  mkdir -p "$(dirname "$LABELER_FILE")"
  info "Creating default .github/labeler.yml"
  cat > "$LABELER_FILE" <<'EOF'
# GitHub Actions Labeler Configuration
# Automatically labels PRs based on changed files

# Documentation
documentation:
  - "*.md"
  - "docs/**"
  - "README*"

# Dependencies
dependencies:
  - "package.json"
  - "package-lock.json"
  - "yarn.lock"
  - "pnpm-lock.yaml"
  - "requirements*.txt"
  - "pyproject.toml"
  - "poetry.lock"
  - "go.mod"
  - "go.sum"
  - "Cargo.toml"
  - "Cargo.lock"
  - "pom.xml"
  - "build.gradle*"
  - "composer.json"
  - "composer.lock"
  - "Gemfile"
  - "Gemfile.lock"

# CI/CD
ci:
  - ".github/**"
  - ".gitlab/**"
  - ".circleci/**"
  - "Jenkinsfile*"
  - "*.yml"
  - "*.yaml"
  - "Dockerfile*"
  - "docker-compose*"

# Tests
tests:
  - "*_test.*"
  - "*.test.*"
  - "*_spec.*"
  - "*.spec.*"
  - "test/**"
  - "tests/**"
  - "spec/**"

# Frontend
frontend:
  - "*.js"
  - "*.jsx"
  - "*.ts"
  - "*.tsx"
  - "*.vue"
  - "*.svelte"
  - "*.css"
  - "*.scss"
  - "*.less"
  - "*.html"

# Backend
backend:
  - "*.py"
  - "*.go"
  - "*.rs"
  - "*.java"
  - "*.kt"
  - "*.cs"
  - "*.php"
  - "*.rb"

# Database
database:
  - "*.sql"
  - "migrations/**"
  - "prisma/**"
  - "alembic/**"

# Configuration
configuration:
  - "*.json"
  - "*.yaml"
  - "*.yml"
  - "*.toml"
  - "*.ini"
  - "*.conf"
  - "*.config"
  - ".env*"

# Security
security:
  - ".github/dependabot.yml"
  - "trivy*"
  - "*.sarif"
EOF
  success "Created .github/labeler.yml"
fi

echo ""
info "Hook installation complete"
echo ""
info "Next steps:"
echo "  1. Make a test commit to verify hooks work"
echo "  2. Run './scripts/setup-aliases.sh' to install Git aliases"
echo "  3. Copy CI/CD workflows from ci/github-actions/ or ci/gitlab-ci/"
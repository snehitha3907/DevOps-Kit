#!/usr/bin/env bash
# setup-workflow.sh — interactive Git workflow setup
#
# Guides the user through setting up the complete Git workflow
# automation including hooks, aliases, and CI/CD integration.
#
# Usage: ./setup-workflow.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo "")"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
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

prompt() {
  echo -e "${CYAN}$*${NC}"
}

confirm() {
  local prompt="$1"
  local default="${2:-n}"
  local response

  if [ "$default" = "y" ]; then
    prompt="$prompt [Y/n]: "
  else
    prompt="$prompt [y/N]: "
  fi

  read -r -p "$prompt" response
  response="${response:-$default}"
  case "$response" in
    [yY][eE][sS]|[yY]) return 0 ;;
    *) return 1 ;;
  esac
}

select_ci() {
  echo ""
  prompt "Select CI/CD platform(s) to configure:"
  echo "  1) GitHub Actions"
  echo "  2) GitLab CI"
  echo "  3) Both"
  echo "  4) None (skip CI setup)"
  read -r -p "Choice [1-4]: " choice
  case "$choice" in
    1) echo "github" ;;
    2) echo "gitlab" ;;
    3) echo "both" ;;
    4) echo "none" ;;
    *) echo "github" ;;
  esac
}

main() {
  echo ""
  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║         Git Workflow Automation Setup Wizard            ║"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""

  if [ -z "$REPO_ROOT" ]; then
    error "Not in a Git repository. Please run from within a Git repo."
    exit 1
  fi

  info "Repository: $REPO_ROOT"
  echo ""

  # Step 1: Install hooks
  if confirm "Install Git hooks?" "y"; then
    info "Installing hooks..."
    if "$SCRIPT_DIR/install-hooks.sh" --force; then
      success "Hooks installed"
    else
      error "Hook installation failed"
    fi
  else
    warn "Skipping hook installation"
  fi

  # Step 2: Install aliases
  if confirm "Install Git aliases (global)?" "y"; then
    info "Installing aliases..."
    if "$SCRIPT_DIR/../aliases/setup-aliases.sh" --global; then
      success "Aliases installed globally"
    else
      error "Alias installation failed"
    fi
  elif confirm "Install Git aliases (local to this repo)?" "n"; then
    info "Installing aliases locally..."
    if "$SCRIPT_DIR/../aliases/setup-aliases.sh" --local; then
      success "Aliases installed locally"
    else
      error "Alias installation failed"
    fi
  else
    warn "Skipping alias installation"
  fi

  # Step 3: CI/CD setup
  CI_CHOICE=$(select_ci)
  case "$CI_CHOICE" in
    github)
      setup_github_actions
      ;;
    gitlab)
      setup_gitlab_ci
      ;;
    both)
      setup_github_actions
      setup_gitlab_ci
      ;;
    none)
      warn "Skipping CI/CD setup"
      ;;
  esac

  # Step 4: Create initial commit
  echo ""
  if confirm "Create initial commit with workflow automation?" "y"; then
    info "Staging files..."
    git add -A
    if git commit -m "chore: add Git workflow automation scaffold"; then
      success "Initial commit created"
    else
      warn "No changes to commit or commit failed"
    fi
  fi

  echo ""
  echo "╔══════════════════════════════════════════════════════════╗"
  echo "║                    Setup Complete!                       ║"
  echo "╚══════════════════════════════════════════════════════════╝"
  echo ""
  info "Your repository is now configured with:"
  echo "  ✓ Git hooks (pre-commit, commit-msg, pre-push, etc.)"
  echo "  ✓ Git aliases (co, lg, feature, sync, pr, etc.)"
  case "$CI_CHOICE" in
    github|both)
      echo "  ✓ GitHub Actions workflows"
      ;;
  esac
  case "$CI_CHOICE" in
    gitlab|both)
      echo "  ✓ GitLab CI pipelines"
      ;;
  esac
  echo ""
  info "Try these commands:"
  echo "  git lg           # Pretty log graph"
  echo "  git feature xyz  # Create feature branch"
  echo "  git sync         # Sync with main"
  echo "  git pr           # Push and create PR (GitHub)"
  echo ""
}

setup_github_actions() {
  info "Setting up GitHub Actions..."
  mkdir -p "$REPO_ROOT/.github/workflows"

  for workflow in "$SCRIPT_DIR/../ci/github-actions"/*.yml; do
    if [ -f "$workflow" ]; then
      filename=$(basename "$workflow")
      target="$REPO_ROOT/.github/workflows/$filename"
      if [ -f "$target" ] && ! confirm "Overwrite existing $filename?" "n"; then
        warn "Skipping $filename"
        continue
      fi
      cp "$workflow" "$target"
      success "Installed .github/workflows/$filename"
    fi
  done

  # Copy dependabot config
  if [ -f "$SCRIPT_DIR/../ci/github-actions/dependabot.yml" ]; then
    cp "$SCRIPT_DIR/../ci/github-actions/dependabot.yml" "$REPO_ROOT/.github/dependabot.yml"
    success "Installed .github/dependabot.yml"
  fi
}

setup_gitlab_ci() {
  info "Setting up GitLab CI..."
  for ci_file in "$SCRIPT_DIR/../ci/gitlab-ci"/*; do
    if [ -f "$ci_file" ]; then
      filename=$(basename "$ci_file")
      target="$REPO_ROOT/$filename"
      if [ -f "$target" ] && ! confirm "Overwrite existing $filename?" "n"; then
        warn "Skipping $filename"
        continue
      fi
      cp "$ci_file" "$target"
      success "Installed $filename"
    fi
  done

  # Create .gitlab directory for lib files
  mkdir -p "$REPO_ROOT/.gitlab/ci"
  for lib_file in "$SCRIPT_DIR/../ci/gitlab-ci"/*.yml; do
    if [ -f "$lib_file" ]; then
      filename=$(basename "$lib_file")
      target="$REPO_ROOT/.gitlab/ci/$filename"
      if [ -f "$target" ] && ! confirm "Overwrite existing .gitlab/ci/$filename?" "n"; then
        warn "Skipping .gitlab/ci/$filename"
        continue
      fi
      cp "$lib_file" "$target"
      success "Installed .gitlab/ci/$filename"
    fi
  done
}

main "$@"
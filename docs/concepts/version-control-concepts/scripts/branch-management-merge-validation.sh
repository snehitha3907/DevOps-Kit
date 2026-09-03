#!/usr/bin/env bash
# last_verified: 2026-09-03 · bash n/a

# Automated branch management and merge validation
# Concept L3 exercise for Version Control Concepts
#
# This pattern combines version control with CI/CD: create feature branches,
# run validation checks (lint, tests, diff guards), merge passing branches,
# and reject failing ones. It mirrors what a CI pipeline does on push —
# branch protection, status checks, merge gates — but in a local sandbox
# so you can see the mechanics without a remote.

set -euo pipefail

WORK_DIR="$(mktemp -d)"
readonly WORK_DIR
readonly PASS=0
readonly FAIL=1

cleanup() {
  cd / || true
  rm -rf "${WORK_DIR}"
}
trap cleanup EXIT

# --- helpers ---

log() { printf '[%s] %s\n' "$(date +%H:%M:%S)" "$*"; }
fail() { log "FAIL: $*"; return 1; }
pass() { log "PASS: $*"; return 0; }

# create_scaffold — set up a repo with a main branch and a fake project.
create_scaffold() {
  local repo="${WORK_DIR}/repo"
  mkdir -p "${repo}"
  cd "${repo}"
  git init -q -b main
  git config user.email "ci@local"
  git config user.name "CI Bot"

  cat > app.py <<'PY'
def add(a, b):
    return a + b

def divide(a, b):
    return a / b
PY
  cat > requirements.txt <<'TXT'
pytest>=7.0
ruff>=0.1
TXT
  mkdir -p tests
  cat > tests/test_app.py <<'TEST'
from app import add, divide

def test_add():
    assert add(1, 2) == 3

def test_divide():
    assert divide(10, 2) == 5.0

def test_divide_by_zero():
    try:
        divide(1, 0)
        assert False, "should have raised"
    except ZeroDivisionError:
        pass
TEST
  git add -A
  git commit -q -m "chore: initial project scaffold"
  log "scaffold created at ${repo}"
}

# create_feature_branch — branch off main with a change.
# $1 = branch name, $2 = file to create/edit, $3 = content
create_feature_branch() {
  local branch="$1" file="$2" content="$3"
  git checkout -q -b "${branch}"
  mkdir -p "$(dirname "${file}")"
  printf '%s\n' "${content}" > "${file}"
  git add "${file}"
  git commit -q -m "feat: ${branch}"
  log "created branch ${branch} with change to ${file}"
}

# run_lint — simulate a lint check. Returns 0 if the file passes, 1 otherwise.
# In a real pipeline this would be ruff, eslint, shellcheck, etc.
run_lint() {
  local file="$1"
  log "running lint on ${file}..."
  if [[ ! -f "${file}" ]]; then
    fail "lint: file ${file} not found"
    return ${FAIL}
  fi
  # Fail if file contains obvious syntax issues (tab mixed with spaces, trailing garbage)
  if grep -Pq '\t' "${file}" 2>/dev/null; then
    fail "lint: tabs found in ${file}"
    return ${FAIL}
  fi
  pass "lint: ${file} clean"
  return ${PASS}
}

# run_tests — execute pytest if available, otherwise parse test files for basics.
run_tests() {
  log "running tests..."
  if command -v pytest >/dev/null 2>&1; then
    if pytest -q --tb=short 2>&1; then
      pass "tests: all passed"
      return ${PASS}
    else
      fail "tests: some failed"
      return ${FAIL}
    fi
  else
    log "pytest not installed — running basic import check"
    if python3 -c "import ast; ast.parse(open('app.py').read())" 2>/dev/null; then
      pass "tests: basic syntax check passed"
      return ${PASS}
    else
      fail "tests: syntax error in app.py"
      return ${FAIL}
    fi
  fi
}

# check_diff_guard — ensure the branch didn't touch protected files.
# In CI this would be a CODEOWNERS or path-based rule.
check_diff_guard() {
  local target_branch="${1:-main}"
  log "checking diff guard against ${target_branch}..."
  local protected_files=("Makefile" "Dockerfile" ".github/workflows/ci.yml")
  local diff_files
  diff_files=$(git diff --name-only "${target_branch}"...HEAD 2>/dev/null || git diff --name-only "${target_branch}" 2>/dev/null || echo "")

  for pf in "${protected_files[@]}"; do
    if echo "${diff_files}" | grep -qx "${pf}"; then
      fail "guard: branch modifies protected file ${pf}"
      return ${FAIL}
    fi
  done
  pass "guard: no protected files modified"
  return ${PASS}
}

# validate_branch — run all checks on the current branch. Returns 0 only if
# every check passes — this is the "merge gate" that CI enforces.
validate_branch() {
  local branch_name
  branch_name=$(git branch --show-current)
  log "=== validating branch: ${branch_name} ==="
  local all_pass=true

  run_lint "app.py"    || all_pass=false
  run_tests            || all_pass=false
  check_diff_guard main || all_pass=false

  if ${all_pass}; then
    log "=== ${branch_name}: ALL CHECKS PASSED ==="
    return ${PASS}
  else
    log "=== ${branch_name}: CHECKS FAILED — merge blocked ==="
    return ${FAIL}
  fi
}

# merge_branch — fast-forward merge into the target branch.
merge_branch() {
  local branch="$1" target="${2:-main}"
  git checkout -q "${target}"
  if git merge --ff-only -q "${branch}" -m "merge: ${branch}"; then
    log "merged ${branch} into ${target} (fast-forward)"
    return ${PASS}
  else
    fail "merge of ${branch} into ${target} failed"
    return ${FAIL}
  fi
}

# reject_branch — delete the branch and report rejection.
reject_branch() {
  local branch="$1"
  git checkout -q main
  git branch -q -D "${branch}" 2>/dev/null || true
  log "rejected and deleted branch ${branch}"
}

# --- main workflow ---
create_scaffold

log ""
log "=== Scenario 1: feature that passes all checks ==="
create_feature_branch "feature/add-subtract" "app.py" "$(cat <<'PY'
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def divide(a, b):
    return a / b
PY
)"
if validate_branch; then
  merge_branch "feature/add-subtract"
else
  reject_branch "feature/add-subtract"
fi

log ""
log "=== Scenario 2: feature that touches a protected file ==="
create_feature_branch "feature/update-deps" "Makefile" "test:\n\tpytest\nlint:\n\truff check ."
if validate_branch; then
  merge_branch "feature/update-deps"
else
  reject_branch "feature/update-deps"
fi

log ""
log "=== Scenario 3: feature with a lint failure (tab characters in source) ==="
git checkout -q -b feature/broken-format
# Deliberately introduce a tab — run_lint will catch it
printf 'def add(a, b):\n    return a + b\n\ndef subtract(a, b):\n\treturn a - b\n\ndef divide(a, b):\n    return a / b\n' > app.py
git add app.py
git commit -q -m "feat: feature/broken-format"
log "created branch feature/broken-format with tabs in app.py"
if validate_branch; then
  merge_branch "feature/broken-format"
else
  reject_branch "feature/broken-format"
fi

log ""
log "=== Final state ==="
log "Branches:"
git branch
log ""
log "Commit graph:"
git --no-pager log --oneline --graph --all
log ""
log "=== Done — sandbox at ${WORK_DIR} ==="

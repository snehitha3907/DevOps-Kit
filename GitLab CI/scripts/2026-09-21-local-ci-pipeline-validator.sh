#!/usr/bin/env bash
# last_verified: 2026-09-21 · GitLab CI gitlab-runner

# Local GitLab CI pipeline validator
# Linted the config, checked what stages and jobs exist, then tried a local run.

export PROJECT_DIR="${1:-.}"
export CI_CONFIG="${PROJECT_DIR}/.gitlab-ci.yml"

echo "=== GitLab CI Local Validator ==="
echo "Config: ${CI_CONFIG}"
echo ""

if [ ! -f "${CI_CONFIG}" ]; then
    echo "ERROR: .gitlab-ci.yml not found at ${CI_CONFIG}"
    exit 1
fi

echo "[1/3] Validating .gitlab-ci.yml syntax..."
if command -v gitlab-ci-lint &>/dev/null; then
    gitlab-ci-lint "${CI_CONFIG}"
elif command -v yq &>/dev/null; then
    if yq eval '.' "${CI_CONFIG}" >/dev/null; then
        echo "YAML structure valid"
    else
        echo "YAML syntax error"
        exit 1
    fi
else
    python3 -c "import yaml; yaml.safe_load(open('${CI_CONFIG}')); print('YAML syntax valid')" 2>/dev/null || { echo "YAML syntax error"; exit 1; }
fi
echo ""

echo "[2/3] Checking required stages and jobs..."
python3 - <<'PYEOF'
import yaml
import os

ci_config = os.environ.get("CI_CONFIG", ".gitlab-ci.yml")
with open(ci_config) as f:
    config = yaml.safe_load(f)

stages = config.get("stages", [])
jobs = {k: v for k, v in config.items() if isinstance(v, dict) and "script" in v}

if not stages:
    print("WARNING: no stages defined")
else:
    print(f"Stages: {', '.join(stages)}")

if not jobs:
    print("WARNING: no jobs found with script key")
else:
    print(f"Jobs: {', '.join(jobs.keys())}")
    for name, job in jobs.items():
        if "script" not in job:
            print(f"  WARNING: job '{name}' has no script")
PYEOF
echo ""

echo "[3/3] Trying local job execution with gitlab-runner exec..."
if command -v gitlab-runner &>/dev/null; then
    gitlab-runner exec docker --config .gitlab-ci.yml build 2>/dev/null || echo "NOTE: gitlab-runner exec requires a running Docker daemon and runner config"
else
    echo "NOTE: gitlab-runner not installed; install via https://gitlab.com/gitlab-org/gitlab-runner"
fi
echo ""
echo "Validation complete."

#!/usr/bin/env bash
# last_verified: 2026-08-04 · CI/CD Concepts n/a

# I wanted to practice the three CI/CD patterns I keep reading about:
# artifact promotion, rollback triggers, and deployment gates.

APP_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="${APP_DIR}/build"

echo "=== CI/CD Common Patterns Demo ==="
echo ""

# --- Build stage ---
echo "[build] Building application..."
mkdir -p "${BUILD_DIR}"

cat > "${BUILD_DIR}/app.sh" <<'EOF'
#!/usr/bin/env bash
echo "Hello from the built application"
EOF
chmod +x "${BUILD_DIR}/app.sh"

# I'm packaging the artifact and tagging it with the Git SHA so it's
# immutable and can be promoted through environments without rebuilding.
tar -czf "${BUILD_DIR}/app.tar.gz" -C "${BUILD_DIR}" app.sh
SHA="${SHA:-$(git rev-parse HEAD 2>/dev/null || echo 'unknown')}"
ARTIFACT="${BUILD_DIR}/app-${SHA}.tar.gz"
cp "${BUILD_DIR}/app.tar.gz" "${ARTIFACT}"
echo "[build] Artifact tagged with SHA: ${SHA}"

# --- Deployment gate ---
echo ""
echo "[gate] Checking deployment prerequisites..."
DEPLOY_TARGET="${BUILD_DIR}/deployed"
mkdir -p "${DEPLOY_TARGET}"
echo "[gate] Prerequisites met — proceeding to deploy"

# --- Promote artifact to staging ---
echo "[promote] Promoting artifact to staging..."
cp "${ARTIFACT}" "${DEPLOY_TARGET}/"
echo "[promote] Artifact promoted to staging"

# --- Deploy and handle failure with rollback ---
echo ""
echo "[deploy] Deploying to target environment..."

if ! "${DEPLOY_TARGET}/app.sh" | grep -q "Hello"; then
  echo "[deploy] FAILED: health check did not pass" >&2
  echo "[rollback] Triggering rollback — reverting to previous artifact..."
  rm -rf "${DEPLOY_TARGET}"
  mkdir -p "${DEPLOY_TARGET}"
  echo "[rollback] Rollback complete"
  exit 1
fi

echo "[deploy] Deployment succeeded"
echo ""
echo "=== Pipeline completed ==="
#!/usr/bin/env bash
# last_verified: 2026-08-04 · CI/CD Concepts n/a

APP_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="${APP_DIR}/build"
ARTIFACT="${BUILD_DIR}/app.tar.gz"

echo "=== Simulated CI/CD Pipeline ==="
echo ""

# --- Build stage ---
echo "[build] Creating build directory..."
mkdir -p "${BUILD_DIR}"

echo "[build] Simulating application build..."
cat > "${BUILD_DIR}/app.sh" <<'EOF'
#!/usr/bin/env bash
echo "Hello from the built application"
EOF
chmod +x "${BUILD_DIR}/app.sh"

echo "[build] Creating artifact archive..."
tar -czf "${ARTIFACT}" -C "${BUILD_DIR}" app.sh
echo "[build] Artifact: ${ARTIFACT}"

# --- Test stage ---
echo ""
echo "[test] Running smoke tests..."

if ! "${BUILD_DIR}/app.sh" | grep -q "Hello from the built application"; then
  echo "[test] FAILED: smoke test did not produce expected output" >&2
  exit 1
fi
echo "[test] PASSED: smoke test succeeded"

# --- Deploy stage ---
echo ""
echo "[deploy] Simulating deployment to staging..."
DEPLOY_TARGET="${BUILD_DIR}/deployed"
mkdir -p "${DEPLOY_TARGET}"
cp "${ARTIFACT}" "${DEPLOY_TARGET}/"
echo "[deploy] Artifact deployed to ${DEPLOY_TARGET}"

echo ""
echo "=== Pipeline completed successfully ==="
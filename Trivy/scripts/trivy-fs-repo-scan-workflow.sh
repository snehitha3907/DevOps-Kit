#!/usr/bin/env bash
# last_verified: 2026-09-21 · Trivy latest

# Trivy filesystem and repository scan workflow
# Scans a Git checkout, filters by severity and fix availability, emits a summary report.

set -euo pipefail

REPO_DIR="${1:-.}"
OUTPUT_DIR="${2:-./trivy-reports}"
MIN_SEVERITY="${3:-MEDIUM}"
REPORT_FILE="${OUTPUT_DIR}/scan-summary.txt"

mkdir -p "${OUTPUT_DIR}"

echo "=== Trivy FS/Repo Scan Workflow ==="
echo "Target: ${REPO_DIR}"
echo "Min severity: ${MIN_SEVERITY}"
echo "Output: ${REPORT_FILE}"
echo ""

echo "[1/4] Running Trivy filesystem scan..."
trivy fs \
  --scanners vuln,secret,config \
  --severity "${MIN_SEVERITY}" \
  --format json \
  --output "${OUTPUT_DIR}/fs-scan.json" \
  "${REPO_DIR}" 2>/dev/null || true

echo "[2/4] Running Trivy repository scan (lockfile-aware)..."
trivy repo \
  --scanners vuln \
  --severity "${MIN_SEVERITY}" \
  --format json \
  --output "${OUTPUT_DIR}/repo-scan.json" \
  "${REPO_DIR}" 2>/dev/null || true

echo "[3/4] Filtering results by fix availability..."
export OUTPUT_DIR MIN_SEVERITY
python3 - <<'PYEOF'
import json
import os

output_dir = os.environ.get("OUTPUT_DIR", "./trivy-reports")
min_severity = os.environ.get("MIN_SEVERITY", "MEDIUM")
severity_order = ["UNKNOWN", "LOW", "MEDIUM", "HIGH", "CRITICAL"]
min_idx = severity_order.index(min_severity) if min_severity in severity_order else 1

results = {"vulnerabilities": [], "fix_available": 0, "fix_unavailable": 0}

for scan_file in ["fs-scan.json", "repo-scan.json"]:
    path = os.path.join(output_dir, scan_file)
    if not os.path.isfile(path):
        continue
    with open(path) as f:
        try:
            data = json.load(f)
        except json.JSONDecodeError:
            continue

    for result in data.get("Results", []):
        for vuln in result.get("Vulnerabilities", []):
            severity = vuln.get("Severity", "UNKNOWN")
            sev_idx = severity_order.index(severity) if severity in severity_order else 0
            if sev_idx < min_idx:
                continue
            entry = {
                "target": result.get("Target", ""),
                "package": vuln.get("PkgName", ""),
                "installed": vuln.get("InstalledVersion", ""),
                "fixed": vuln.get("FixedVersion", ""),
                "severity": severity,
                "title": vuln.get("Title", ""),
                "fix_available": bool(vuln.get("FixedVersion")),
            }
            results["vulnerabilities"].append(entry)
            if entry["fix_available"]:
                results["fix_available"] += 1
            else:
                results["fix_unavailable"] += 1

with open(os.path.join(output_dir, "filtered-vulnerabilities.json"), "w") as f:
    json.dump(results, f, indent=2)
PYEOF

echo "[4/4] Emitting consumable summary report..."
FIX_AVAILABLE=$(python3 -c "import json; d=json.load(open('${OUTPUT_DIR}/filtered-vulnerabilities.json')); print(d['fix_available'])")
FIX_UNAVAILABLE=$(python3 -c "import json; d=json.load(open('${OUTPUT_DIR}/filtered-vulnerabilities.json')); print(d['fix_unavailable'])")
TOTAL=$(python3 -c "import json; d=json.load(open('${OUTPUT_DIR}/filtered-vulnerabilities.json')); print(len(d['vulnerabilities']))")

cat > "${REPORT_FILE}" <<EOF
Trivy Scan Summary Report
==========================
Target Directory: ${REPO_DIR}
Minimum Severity: ${MIN_SEVERITY}
Generated: $(date -u +"%Y-%m-%dT%H:%M:%SZ")

Vulnerability Breakdown:
  Total found:          ${TOTAL}
  Fix available:        ${FIX_AVAILABLE}
  Fix unavailable:      ${FIX_UNAVAILABLE}

Files produced:
  - fs-scan.json         Full filesystem scan results (JSON)
  - repo-scan.json       Full repository scan results (JSON)
  - filtered-vulnerabilities.json  Vulns filtered by severity with fix status
  - scan-summary.txt     This report

Next steps:
  Review filtered-vulnerabilities.json for CRITICAL and HIGH entries with fix_available=true first.
  For fix unavailable entries, assess risk acceptance or schedule remediation.
EOF

echo ""
echo "Scan complete. Summary report at ${REPORT_FILE}"

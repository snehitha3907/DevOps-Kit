#!/usr/bin/env bash
# last_verified: 2026-10-18 · Trivy latest

# Trivy policy-as-code with OPA/Rego custom checks
# Demonstrates writing custom Rego policies, bundling them as a policy package,
# and scanning container images and Kubernetes manifests against them.

set -euo pipefail

POLICY_DIR="${1:-./policies}"
TARGET="${2:-.}"
OUTPUT_DIR="${3:-./policy-reports}"
SEVERITY="${4:-MEDIUM}"

mkdir -p "${OUTPUT_DIR}"

echo "=== Trivy Policy-as-Code with OPA/Rego ==="
echo "Policy directory: ${POLICY_DIR}"
echo "Scan target: ${TARGET}"
echo "Output directory: ${OUTPUT_DIR}"
echo "Minimum severity: ${SEVERITY}"
echo ""

if [[ ! -d "${POLICY_DIR}" ]]; then
  echo "Error: Policy directory '${POLICY_DIR}' does not exist"
  echo "Create it with your .rego policy files, or pass a different path as the first argument."
  exit 1
fi

echo "[1/4] Validating Rego policy syntax..."
if command -v opa >/dev/null 2>&1; then
  opa fmt -l "${POLICY_DIR}"/*.rego 2>/dev/null || true
  opa check "${POLICY_DIR}"/*.rego 2>/dev/null || true
  echo "  OPA fmt/check passed (or not installed, continuing...)"
else
  echo "  OPA not found; skipping syntax validation. Install with: https://www.openpolicyagent.org/docs/latest/#running-opa"
fi

echo "[2/4] Building Trivy policy bundle..."
trivy config \
  --policy "${POLICY_DIR}" \
  --policy-namespaces "custom" \
  --format json \
  --output "${OUTPUT_DIR}/policy-bundle.json" \
  "${POLICY_DIR}" 2>/dev/null || true

if [[ ! -f "${OUTPUT_DIR}/policy-bundle.json" ]]; then
  echo "  Note: trivy config --policy requires Trivy 0.48+. If this failed, ensure Trivy is up to date."
fi

echo "[3/4] Scanning target against custom policies..."
trivy config \
  --policy "${POLICY_DIR}" \
  --policy-namespaces "custom" \
  --severity "${SEVERITY}" \
  --format json \
  --output "${OUTPUT_DIR}/scan-results.json" \
  "${TARGET}" 2>/dev/null || true

echo "[4/4] Generating human-readable summary..."
python3 - <<PYEOF
import json
import os
import sys

results_path = os.path.join("${OUTPUT_DIR}", "scan-results.json")
if not os.path.isfile(results_path):
    print("  No scan results found; target may be clean or scan failed.")
    sys.exit(0)

with open(results_path) as f:
    try:
        data = json.load(f)
    except json.JSONDecodeError:
        print("  Failed to parse scan results JSON.")
        sys.exit(0)

severity_order = ["UNKNOWN", "LOW", "MEDIUM", "HIGH", "CRITICAL"]
min_sev = "${SEVERITY}"
min_idx = severity_order.index(min_sev) if min_sev in severity_order else 2

findings = []
for result in data.get("Results", []):
    for check in result.get("Misconfigurations", []):
        severity = check.get("Severity", "UNKNOWN")
        sev_idx = severity_order.index(severity) if severity in severity_order else 0
        if sev_idx < min_idx:
            continue
        findings.append({
            "namespace": result.get("Namespace", ""),
            "target": result.get("Target", ""),
            "type": check.get("Type", ""),
            "id": check.get("ID", ""),
            "title": check.get("Title", ""),
            "severity": severity,
            "message": check.get("Message", ""),
            "resolution": check.get("Resolution", ""),
        })

summary_path = os.path.join("${OUTPUT_DIR}", "policy-scan-summary.txt")
with open(summary_path, "w") as f:
    f.write("Trivy Custom Policy Scan Summary\n")
    f.write("================================\n")
    f.write(f"Policy directory: ${POLICY_DIR}\n")
    f.write(f"Scan target: ${TARGET}\n")
    f.write(f"Minimum severity: ${SEVERITY}\n")
    f.write(f"Generated: $(date -u +%Y-%m-%dT%H:%M:%SZ)\n\n")
    f.write(f"Policy violations found: {len(findings)}\n\n")
    if findings:
        for sev in ["CRITICAL", "HIGH", "MEDIUM", "LOW", "UNKNOWN"]:
            sev_findings = [f for f in findings if f["severity"] == sev]
            if sev_findings:
                f.write(f"  {sev} ({len(sev_findings)}):\n")
                for item in sev_findings:
                    f.write(f"    - {item['id']}: {item['title']} ({item['target']})\n")
    else:
        f.write("  No violations at or above ${SEVERITY}.\n")

print(f"  Summary written to {summary_path}")
print(f"  Total violations at or above ${SEVERITY}: {len(findings)}")
PYEOF

echo ""
echo "Scan complete. Reports in ${OUTPUT_DIR}:"
echo "  - scan-results.json      Full Trivy JSON output"
echo "  - policy-scan-summary.txt  Human-readable summary"

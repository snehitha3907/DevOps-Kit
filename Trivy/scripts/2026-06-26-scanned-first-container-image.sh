#!/bin/bash
# Scanning a container image with Trivy and parsing the JSON output
# I wanted to see how trivy image works and whether I could extract
# meaningful data from the JSON format for later automation

IMAGE="alpine:3.18"

echo "=== Step 1: scan $IMAGE for HIGH and CRITICAL vulns ==="
# The first run downloads the vulnerability DB — takes ~10-15 seconds
trivy image "$IMAGE" --severity HIGH,CRITICAL

echo ""
echo "=== Step 2: same scan but save JSON output for parsing ==="
trivy image "$IMAGE" \
  --format json \
  --severity HIGH,CRITICAL \
  --output /tmp/trivy-results.json

echo ""
echo "=== Step 3: parse the JSON to get a per-target summary ==="
# jq walks through Results[], finds targets that have Vulnerabilities,
# and counts them. I had to add the null check because targets with
# no vulns still appear in Results[]
jq -r '
  .Results[]?
  | select(.Vulnerabilities != null)
  | "\(.Target): \(.Vulnerabilities | length) vulns found"
' /tmp/trivy-results.json

echo ""
echo "=== Step 4: list individual findings (top 8) ==="
jq -r '
  .Results[]?.Vulnerabilities[]?
  | "\(.VulnerabilityID) [\(.Severity)] \(.PkgName) \(.InstalledVersion) --> \(.FixedVersion // "no fix")"
' /tmp/trivy-results.json | head -8

echo ""
echo "=== Step 5: try the --exit-code flag for CI-style use ==="
# Exit code 1 if any CRITICAL vulns found — useful for blocking a build
trivy image "$IMAGE" --severity CRITICAL --exit-code 1
echo "Exit code was $? (0 = no CRITICAL vulns, 1 = found)"

rm -f /tmp/trivy-results.json

#!/bin/bash
# last_verified: 2026-07-12 · Trivy latest
# Install Trivy and scan a local filesystem for vulnerabilities

# Install Trivy on Linux (official script)
curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh

# Scan the current directory for CRITICAL and HIGH vulnerabilities
./bin/trivy fs . --severity CRITICAL,HIGH

# Same scan but output JSON for scripting — save to a report file
./bin/trivy fs . --severity CRITICAL,HIGH --format json --output /tmp/trivy-report.json
echo "JSON report saved to /tmp/trivy-report.json"

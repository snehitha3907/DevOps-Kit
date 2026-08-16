# last_verified: 2026-08-16 · Trivy latest
# I wanted a quick way to scan a container image and hard-fail the build
# if Trivy finds any CRITICAL vulnerabilities. The research mentions using
# --exit-code 1 to turn severity findings into a process exit code, so I
# wired that into a small Python wrapper instead of memorizing CLI flags.

import subprocess
import json
import sys

def scan_image(image_name):
    # I used --severity CRITICAL because the task specifically asks to
    # fail on critical CVEs, not every severity level.
    cmd = [
        "trivy", "image",
        "--format", "json",
        "--severity", "CRITICAL",
        "--exit-code", "1",
        image_name,
    ]
    result = subprocess.run(cmd, capture_output=True, text=True)

    # Trivy writes the JSON report to stdout even when it exits non-zero,
    # so I can still parse findings from a failed run.
    if result.stdout:
        try:
            findings = json.loads(result.stdout)
        except json.JSONDecodeError:
            print("Trivy output was not valid JSON — raw stdout:")
            print(result.stdout)
            sys.exit(2)
    else:
        findings = []

    criticals = []
    for target in findings:
        for vuln in target.get("Vulnerabilities", []):
            if vuln.get("Severity") == "CRITICAL":
                criticals.append(vuln)

    if criticals:
        print(f"CRITICAL: {len(criticals)} critical vulnerability(ies) found in {image_name}")
        for v in criticals:
            fix = v.get("FixedVersion", "no fix")
            print(f"  {v['VulnerabilityID']} | {v['PkgName']} {v['InstalledVersion']} -> {fix}")
        sys.exit(1)
    else:
        print(f"No CRITICAL vulnerabilities found in {image_name}")
        sys.exit(0)

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <container-image>")
        sys.exit(2)
    scan_image(sys.argv[1])

# last_verified: 2026-07-12 · Trivy latest
# Python wrapper that runs Trivy and parses JSON output for a summary report
import subprocess, json

result = subprocess.run(["trivy", "fs", ".", "--format", "json"], capture_output=True, text=True)
report = json.loads(result.stdout)

for target in report.get("Results", []):
    vulns = target.get("Vulnerabilities", [])
    if vulns:
        print(f"\n{target['Target']}: {len(vulns)} vulns")
        for v in vulns[:3]:
            print(f"  {v['VulnerabilityID']} [{v['Severity']}] {v['PkgName']} {v['InstalledVersion']} -> {v.get('FixedVersion', 'no fix')}")

#!/usr/bin/env python3
# last_verified: 2026-10-15 · Trivy 0.58.1 · Python 3.11
# Merge Trivy CycloneDX SBOM with SARIF scan results into a single artifact.
# Usage: python3 trivy-sbom-merge.py --sbom <sbom.json> --scan <scan.sarif> --output <combined.json>

import argparse
import json
import sys
from pathlib import Path
from typing import Any, Dict, List, Optional


def load_json(path: Path) -> Dict[str, Any]:
    with path.open() as f:
        return json.load(f)


def merge_sbom_with_scan(sbom: Dict[str, Any], sarif: Dict[str, Any]) -> Dict[str, Any]:
    """
    Merge CycloneDX SBOM with SARIF scan results.
    Adds vulnerability information from SARIF to the corresponding components in SBOM.
    """
    # Build a lookup of vulnerabilities by component (name + version)
    vuln_by_component: Dict[str, List[Dict[str, Any]]] = {}

    for run in sarif.get("runs", []):
        for result in run.get("results", []):
            # Extract component info from SARIF result locations or properties
            locations = result.get("locations", [])
            component_key = None

            # Try to get component from rule properties or locations
            rule = run.get("tool", {}).get("driver", {}).get("rules", [])
            rule_id = result.get("ruleId", "")

            # Trivy SARIF includes package info in partialFingerprints or properties
            props = result.get("properties", {})
            pkg_name = props.get("packageName") or props.get("pkgName")
            pkg_version = props.get("installedVersion") or props.get("installed_version")

            if pkg_name and pkg_version:
                component_key = f"{pkg_name}@{pkg_version}"
            elif pkg_name:
                component_key = pkg_name
            else:
                # Fallback: use rule ID as key
                component_key = rule_id

            vuln_entry = {
                "ruleId": rule_id,
                "level": result.get("level", "warning"),
                "message": result.get("message", {}).get("text", ""),
                "locations": locations,
                "properties": props,
            }

            vuln_by_component.setdefault(component_key, []).append(vuln_entry)

    # Enrich SBOM components with vulnerability data
    for component in sbom.get("components", []):
        name = component.get("name", "")
        version = component.get("version", "")
        keys_to_try = [f"{name}@{version}", name]

        vulns = []
        for key in keys_to_try:
            if key in vuln_by_component:
                vulns.extend(vuln_by_component[key])

        if vulns:
            component.setdefault("properties", []).append({
                "name": "trivy:vulnerabilities",
                "value": json.dumps(vulns)
            })

    # Add scan metadata to SBOM metadata
    sbom.setdefault("metadata", {}).setdefault("properties", []).append({
        "name": "trivy:scanTimestamp",
        "value": sarif.get("runs", [{}])[0].get("invocation", {}).get("startTimeUtc", "")
    })

    return sbom


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Merge Trivy CycloneDX SBOM with SARIF scan results"
    )
    parser.add_argument("--sbom", required=True, help="Path to CycloneDX SBOM JSON")
    parser.add_argument("--scan", required=True, help="Path to SARIF scan results")
    parser.add_argument("--output", required=True, help="Path to write merged output")
    args = parser.parse_args()

    sbom_path = Path(args.sbom)
    scan_path = Path(args.scan)
    output_path = Path(args.output)

    if not sbom_path.exists():
        print(f"SBOM file not found: {sbom_path}", file=sys.stderr)
        return 1
    if not scan_path.exists():
        print(f"SARIF file not found: {scan_path}", file=sys.stderr)
        return 1

    try:
        sbom = load_json(sbom_path)
        sarif = load_json(scan_path)

        # Validate minimal structure
        if "components" not in sbom:
            print("SBOM missing 'components' field", file=sys.stderr)
            return 1
        if "runs" not in sarif:
            print("SARIF missing 'runs' field", file=sys.stderr)
            return 1

        merged = merge_sbom_with_scan(sbom, sarif)

        with output_path.open("w") as f:
            json.dump(merged, f, indent=2)

        print(f"Merged output written to {output_path}")
        print(f"  SBOM components: {len(sbom.get('components', []))}")
        vuln_count = sum(
            1 for c in merged.get("components", [])
            if any(p.get("name") == "trivy:vulnerabilities" for p in c.get("properties", []))
        )
        print(f"  Components with vulnerabilities: {vuln_count}")

    except json.JSONDecodeError as e:
        print(f"JSON parse error: {e}", file=sys.stderr)
        return 1
    except Exception as e:
        print(f"Unexpected error: {e}", file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
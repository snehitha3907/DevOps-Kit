#!/usr/bin/env python3
# last_verified: 2026-10-15 · Trivy 0.58.1 · Python 3.9+
# Python helper for merging Trivy SBOMs in CI/CD pipelines
# Based on: https://trivy.dev/docs/latest/guide/advanced/private-registries/ecr [source: https://trivy.dev/docs/latest/guide/advanced/private-registries/ecr]

import json
import sys
import os
from typing import List, Dict, Any


def merge_sboms(sbom_files: List[str], output_file: str) -> None:
    """
    Merge multiple Trivy-generated SBOMs (in CycloneDX or SPDX format) into a single SBOM.
    
    Args:
        sbom_files: List of paths to SBOM files to merge
        output_file: Path to write the merged SBOM
    """
    if not sbom_files:
        print("Error: No SBOM files provided for merging", file=sys.stderr)
        sys.exit(1)
    
    merged_sbom = {
        "bomFormat": "CycloneDX",
        "specVersion": "1.4",
        "version": 1,
        "metadata": {
            "timestamp": "",
            "tools": [
                {
                    "vendor": "Aqua Security",
                    "name": "trivy",
                    "version": "0.58.1"
                }
            ]
        },
        "components": [],
        "dependencies": []
    }
    
    # Track seen components to avoid duplicates
    seen_components = set()
    
    for sbom_file in sbom_files:
        if not os.path.exists(sbom_file):
            print(f"Warning: SBOM file not found: {sbom_file}", file=sys.stderr)
            continue
            
        try:
            with open(sbom_file, 'r') as f:
                sbom_data = json.load(f)
            
            # Handle CycloneDX format
            if sbom_data.get("bomFormat") == "CycloneDX":
                for component in sbom_data.get("components", []):
                    # Create a unique identifier for the component
                    comp_id = (
                        component.get("name", ""),
                        component.get("version", ""),
                        component.get("purl", "")
                    )
                    
                    if comp_id not in seen_components:
                        seen_components.add(comp_id)
                        merged_sbom["components"].append(component)
                        
            # Handle SPDX format (simplified)
            elif sbom_data.get("spdxVersion"):
                for package in sbom_data.get("packages", []):
                    pkg_id = (
                        package.get("name", ""),
                        package.get("versionInfo", ""),
                        package.get("downloadLocation", "")
                    )
                    
                    if pkg_id not in seen_components:
                        seen_components.add(pkg_id)
                        # Convert SPDX package to CycloneDX component (simplified)
                        component = {
                            "name": package.get("name", ""),
                            "version": package.get("versionInfo", ""),
                            "purl": package.get("externalRefs", [{}])[0].get("referenceLocator", "")
                            if package.get("externalRefs") else ""
                        }
                        merged_sbom["components"].append(component)
                        
        except json.JSONDecodeError as e:
            print(f"Error: Failed to parse SBOM file {sbom_file}: {e}", file=sys.stderr)
            sys.exit(1)
        except Exception as e:
            print(f"Error: Failed to process SBOM file {sbom_file}: {e}", file=sys.stderr)
            sys.exit(1)
    
    # Update timestamp
    from datetime import datetime
    merged_sbom["metadata"]["timestamp"] = datetime.utcnow().strftime("%Y-%m-%dT%H:%M:%SZ")
    
    # Write merged SBOM
    try:
        with open(output_file, 'w') as f:
            json.dump(merged_sbom, f, indent=2)
        print(f"Successfully merged {len(sbom_files)} SBOM(s) into {output_file}")
    except Exception as e:
        print(f"Error: Failed to write merged SBOM to {output_file}: {e}", file=sys.stderr)
        sys.exit(1)


def main() -> None:
    """Main entry point for the SBOM merger script."""
    if len(sys.argv) < 3:
        print("Usage: python3 merge-sboms.py <output.sbom> <input1.sbom> [input2.sbom ...]", file=sys.stderr)
        sys.exit(1)
    
    output_file = sys.argv[1]
    input_files = sys.argv[2:]
    
    merge_sboms(input_files, output_file)


if __name__ == "__main__":
    main()
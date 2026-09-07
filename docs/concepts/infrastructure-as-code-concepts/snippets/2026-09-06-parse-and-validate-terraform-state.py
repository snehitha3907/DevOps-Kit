# last_verified: 2026-09-06 · Terraform state format · n/a

"""
Practice: parsing and validating Terraform state files.

Reads a .tfstate JSON file, checks structural integrity,
and reports on resources, outputs, and potential issues.
"""

import json
import sys
from pathlib import Path


REQUIRED_VERSION_FIELDS = ["version", "terraform_version", "serial", "lineage"]
REQUIRED_RESOURCE_FIELDS = ["mode", "type", "name", "provider"]
VALID_MODES = {"managed", "data"}


def load_state(path: str) -> dict:
    """Load and parse a Terraform state JSON file."""
    state_file = Path(path)
    if not state_file.exists():
        print(f"ERROR: state file not found: {path}")
        sys.exit(1)
    with open(state_file) as f:
        return json.load(f)


def validate_version(state: dict) -> list[str]:
    """Check that the state file has the required top-level fields."""
    issues = []
    for field in REQUIRED_VERSION_FIELDS:
        if field not in state:
            issues.append(f"missing required field: {field}")
    if "version" in state and state["version"] != 4:
        issues.append(f"unexpected state version: {state['version']} (expected 4)")
    return issues


def validate_resources(state: dict) -> tuple[list[str], int]:
    """Validate each resource entry in the state."""
    issues = []
    resources = state.get("resources", [])
    count = len(resources)
    seen_addresses = set()

    for i, res in enumerate(resources):
        prefix = f"resources[{i}]"

        for field in REQUIRED_RESOURCE_FIELDS:
            if field not in res:
                issues.append(f"{prefix}: missing field '{field}'")

        mode = res.get("mode", "")
        if mode not in VALID_MODES:
            issues.append(f"{prefix}: invalid mode '{mode}'")

        # Build the resource address and check for duplicates
        addr = f"{res.get('mode', '?')}.{res.get('type', '?')}.{res.get('name', '?')}"
        if addr in seen_addresses:
            issues.append(f"{prefix}: duplicate address '{addr}'")
        seen_addresses.add(addr)

        # Check that each resource has at least one instance
        instances = res.get("instances", [])
        if not instances:
            issues.append(f"{prefix} ({addr}): no instances — resource may not be managed")

        for j, inst in enumerate(instances):
            if "attributes" not in inst:
                issues.append(f"{prefix}.instances[{j}]: missing 'attributes'")

    return issues, count


def validate_outputs(state: dict) -> tuple[list[str], int]:
    """Check outputs block for structural consistency."""
    issues = []
    outputs = state.get("outputs", {})
    count = len(outputs)

    for name, obj in outputs.items():
        if "value" not in obj:
            issues.append(f"outputs.{name}: missing 'value'")
        if "type" not in obj:
            issues.append(f"outputs.{name}: missing 'type'")

    return issues, count


def summarize_providers(state: dict) -> dict[str, int]:
    """Count resources per provider."""
    providers: dict[str, int] = {}
    for res in state.get("resources", []):
        provider = res.get("provider", "unknown")
        # Strip the registry prefix if present (e.g., "provider[\"registry.terraform.io/hashicorp/aws\"]")
        if "[" in provider:
            provider = provider.split("[")[-1].rstrip('"').split("/")[-1]
        providers[provider] = providers.get(provider, 0) + 1
    return providers


def main():
    if len(sys.argv) < 2:
        print("Usage: python parse-and-validate-terraform-state.py <state-file.tfstate>")
        sys.exit(1)

    state_path = sys.argv[1]
    state = load_state(state_path)

    print(f"=== Terraform State Validation: {state_path} ===\n")

    # Version check
    version_issues = validate_version(state)
    print(f"Terraform version: {state.get('terraform_version', 'unknown')}")
    print(f"Serial: {state.get('serial', 'unknown')}")
    print(f"Lineage: {state.get('lineage', 'unknown')[:12]}...")
    if version_issues:
        for issue in version_issues:
            print(f"  [WARN] {issue}")
    else:
        print("  [OK] version fields valid")

    # Resources
    res_issues, res_count = validate_resources(state)
    print(f"\nResources: {res_count}")
    if res_issues:
        for issue in res_issues:
            print(f"  [WARN] {issue}")
    else:
        print("  [OK] all resources valid")

    # Outputs
    out_issues, out_count = validate_outputs(state)
    print(f"\nOutputs: {out_count}")
    if out_issues:
        for issue in out_issues:
            print(f"  [WARN] {issue}")
    else:
        print("  [OK] all outputs valid")

    # Provider breakdown
    providers = summarize_providers(state)
    print(f"\nProvider breakdown:")
    for provider, cnt in sorted(providers.items()):
        print(f"  {provider}: {cnt} resource(s)")

    total_issues = len(version_issues) + len(res_issues) + len(out_issues)
    print(f"\n=== Summary: {total_issues} issue(s) found ===")
    if total_issues == 0:
        print("State file looks healthy.")
    else:
        print("Review warnings above — some resources may need attention.")


if __name__ == "__main__":
    main()

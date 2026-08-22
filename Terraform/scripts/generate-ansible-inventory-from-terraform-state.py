#!/usr/bin/env python3
# last_verified: 2026-08-22 · Terraform · n/a

"""Generate an Ansible inventory from a Terraform state file.

Reads a Terraform state JSON, extracts EC2 instances, and writes an
INI-format inventory grouped by the instance's `role` tag (or by
availability zone when no role tag is present).
"""

import json
import sys
from pathlib import Path


def load_state(path: Path) -> dict:
    try:
        return json.loads(path.read_text())
    except FileNotFoundError:
        sys.exit(f"error: state file not found: {path}")
    except json.JSONDecodeError as exc:
        sys.exit(f"error: invalid JSON in {path}: {exc}")


def extract_instances(state: dict) -> list[dict]:
    resources = state.get("resources", [])
    instances = []
    for resource in resources:
        if resource.get("type") != "aws_instance":
            continue
        for instance in resource.get("instances", []):
            raw = instance.get("attributes", {})
            # Flatten nested attributes that Terraform state sometimes wraps
            # under "private_ip" / "public_ip" at the instance level.
            public_ip = raw.get("public_ip") or raw.get("public_ipv4", "")
            private_ip = raw.get("private_ip") or raw.get("private_ipv4", "")
            if not public_ip and not private_ip:
                continue
            tags = raw.get("tags", {}) or {}
            role = tags.get("Role", tags.get("role", "ungrouped"))
            az = raw.get("availability_zone", "unknown")
            name = tags.get("Name", raw.get("id", "unknown"))
            instances.append(
                {
                    "name": name,
                    "public_ip": public_ip,
                    "private_ip": private_ip,
                    "role": role,
                    "az": az,
                }
            )
    return instances


def build_inventory(instances: list[dict]) -> str:
    groups: dict[str, list[dict]] = {}
    for inst in instances:
        groups.setdefault(inst["role"], []).append(inst)

    lines = ["[all:vars]", "ansible_python_interpreter=/usr/bin/python3", ""]
    for group_name, members in sorted(groups.items()):
        lines.append(f"[{group_name}]")
        for member in members:
            ip = member["public_ip"] or member["private_ip"]
            lines.append(f"{member['name']} ansible_host={ip} az={member['az']}")
        lines.append("")
    return "\n".join(lines)


def main() -> None:
    if len(sys.argv) < 2:
        sys.exit("usage: generate-inventory.py <terraform.tfstate>")

    state_path = Path(sys.argv[1])
    state = load_state(state_path)
    instances = extract_instances(state)

    if not instances:
        sys.exit("error: no EC2 instances found in state file")

    inventory = build_inventory(instances)
    print(inventory)


if __name__ == "__main__":
    main()

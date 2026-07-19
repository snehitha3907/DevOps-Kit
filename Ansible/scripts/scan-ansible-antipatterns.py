#!/usr/bin/env python3
# last_verified: 2026-07-19 · Ansible 11.2.0

import sys
import argparse
import os
import re

try:
    import yaml
except ImportError:
    print("Missing dependency: pyyaml. Install with: pip install pyyaml", file=sys.stderr)
    sys.exit(1)

MODULES_WITH_DEDICATED_ALTERNATIVES = {
    "apt": {"apt", "apt_key", "apt_repository"},
    "yum": {"yum", "dnf"},
    "pip": {"pip", "pip_package"},
    "copy": {"copy", "template", "fetch"},
    "service": {"service", "systemd", "sysvinit", "service_facts"},
    "user": {"user", "group"},
    "file": {"file", "lineinfile", "blockinfile", "replace", "acl"},
    "git": {"git"},
    "get_url": {"get_url", "uri"},
    "debug": {"debug"},
}

BECOME_KEYWORDS = re.compile(
    r"(install|configure|setup|update|upgrade|start|stop|restart|"
    r"enable|disable|add|remove|create|delete|write|mount|service)", re.I
)

UNQUOTED_LINE = re.compile(
    r"^\s+[a-zA-Z_][a-zA-Z0-9_]*:\s*(?!['\"\[])\S*\{\{"
)


def collect_files(paths):
    files = []
    for p in paths:
        if os.path.isfile(p):
            files.append(p)
        elif os.path.isdir(p):
            for root, _dirs, fnames in os.walk(p):
                for f in fnames:
                    if f.endswith((".yml", ".yaml")):
                        files.append(os.path.join(root, f))
    return files


def check_command_use(task, path, i):
    issues = []
    module = task.get("module", "") or next(
        (k for k in ("command", "shell", "raw", "script") if k in task), ""
    )
    if not module or module not in ("command", "shell", "raw", "script"):
        return issues

    arg_val = task.get(module, "") or ""
    if not isinstance(arg_val, str):
        return issues

    first = arg_val.strip().split()[0].lower() if arg_val.strip() else ""
    for category, modules in MODULES_WITH_DEDICATED_ALTERNATIVES.items():
        if first in modules:
            issues.append(
                f"  L?  {module} module used for '{first}' — "
                f"prefer {category} modules ({', '.join(sorted(modules))})"
            )
    return issues


def check_become(task, path, i, parent_become):
    if parent_become or task.get("become"):
        return []
    name = task.get("name", "") or ""
    if BECOME_KEYWORDS.search(name):
        return [f"  L?  '{name}' may need become: yes"]
    return []


def scan_file(path):
    issues = []
    raw_lines = []
    try:
        with open(path) as f:
            raw = f.read()
            raw_lines = raw.splitlines()
        data = yaml.safe_load(raw)
    except yaml.YAMLError as e:
        return [(f"  L1  YAML parse error: {e}")]
    except OSError as e:
        return [(f"  L1  read error: {e}")]

    if not isinstance(data, list):
        data = [data]

    for lineno, line in enumerate(raw_lines, 1):
        if UNQUOTED_LINE.search(line):
            issues.append(
                f"  L{lineno}  unquoted Jinja2 variable — wrap in double quotes"
            )

    for doc in data:
        if not isinstance(doc, dict):
            continue
        parent_become = doc.get("become", False)

        for i, task in enumerate(
            doc.get("tasks", []) + doc.get("handlers", [])
        ):
            if not isinstance(task, dict):
                continue
            issues.extend(check_command_use(task, path, i))
            issues.extend(check_become(task, path, i, parent_become))

    return issues


def main():
    parser = argparse.ArgumentParser(
        description="Scan Ansible playbooks for common antipatterns."
    )
    parser.add_argument("paths", nargs="+", help="Playbook file or directory")
    parser.add_argument(
        "--fail", action="store_true",
        help="Exit non-zero when issues found"
    )
    args = parser.parse_args()

    files = collect_files(args.paths)
    if not files:
        print("No playbook files found.")
        return 1 if args.fail else 0

    total = 0
    for path in sorted(files):
        issues = scan_file(path)
        if issues:
            print(path)
            for i in issues:
                print(i)
            total += len(issues)

    if total == 0:
        print("No antipatterns detected.")
    elif args.fail:
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())

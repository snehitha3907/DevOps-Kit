# last_verified: 2026-08-12 · Ansible

import subprocess
import sys
from pathlib import Path

# I wanted a small Python wrapper around ansible-lint that I can drop
# into a CI step. The docs mention ansible-lint has an --offline mode,
# so I default to that to avoid network fetches slowing down the check.
# I went with subprocess instead of parsing YAML myself because ansible-lint
# already knows the rules and I'd rather not duplicate that logic.


def lint_playbook(path: str, offline: bool = True) -> dict:
    cmd = ["ansible-lint"]
    if offline:
        cmd.append("--offline")
    cmd.append(path)

    result = subprocess.run(
        cmd,
        capture_output=True,
        text=True,
    )

    return {
        "path": path,
        "returncode": result.returncode,
        "stdout": result.stdout,
        "stderr": result.stderr,
    }


def main():
    if len(sys.argv) < 2:
        print("Usage: python lint-ansible-playbook.py <playbook.yml>")
        sys.exit(1)

    playbook = Path(sys.argv[1])
    if not playbook.exists():
        print(f"File not found: {playbook}")
        sys.exit(1)

    report = lint_playbook(str(playbook))

    if report["returncode"] == 0:
        print(f"{playbook.name}: clean")
    else:
        print(f"{playbook.name}: issues found")
        print(report["stdout"])
        sys.exit(1)


if __name__ == "__main__":
    main()

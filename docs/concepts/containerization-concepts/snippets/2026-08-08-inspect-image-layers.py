# last_verified: 2026-08-08 · python n/a

"""
Inspect a Docker image's layers and report size by instruction — L2 concept
exercise for Containerization Concepts.

I wrote this because I kept building fat images and couldn't tell which
Dockerfile instruction was responsible for the bloat. `docker history`
gives the raw layer sizes, but I wanted them grouped by instruction type
(RUN, COPY, FROM, etc.) so I can see at a glance where to optimize.

Usage:
    python3 inspect_image_layers.py <image_name>
"""

import re
import subprocess
import sys
from collections import defaultdict

# Docker outputs sizes as human-readable strings like "56.7MB" or "1.2GB".
# I convert to bytes for arithmetic, then back to human-readable for display.
_SIZE_UNITS = {"B": 1, "KB": 1024, "MB": 1024**2, "GB": 1024**3, "TB": 1024**4}


def parse_size(size_str: str) -> int:
    """Convert a Docker size string (e.g. '56.7MB') into bytes."""
    match = re.match(r"^([\d.]+)\s*([KMGTP]?B)$", size_str.strip())
    if not match:
        return 0
    value = float(match.group(1))
    unit = match.group(2)
    return int(value * _SIZE_UNITS[unit])


def human_readable(num_bytes: int) -> str:
    """Format a byte count back into a Docker-style size string."""
    for unit in ("B", "KB", "MB", "GB", "TB"):
        if abs(num_bytes) < 1024 or unit == "TB":
            return f"{num_bytes:.1f} {unit}"
        num_bytes /= 1024
    return f"{num_bytes:.1f} PB"


def get_history(image_name: str) -> list[tuple[str, str]]:
    """
    Run `docker history` and return a list of (created_by, size) tuples.

    I use the --format flag with a pipe separator so I get exactly two fields
    per line without parsing whitespace-indented columns.
    """
    result = subprocess.run(
        [
            "docker", "history",
            "--no-trunc",
            "--format", "{{.CreatedBy}}|{{.Size}}",
            image_name,
        ],
        capture_output=True,
        text=True,
        check=True,
    )
    rows: list[tuple[str, str]] = []
    for line in result.stdout.strip().splitlines():
        parts = line.split("|", 1)
        if len(parts) == 2:
            rows.append((parts[0].strip(), parts[1].strip()))
    return rows


def instruction_of(created_by: str) -> str:
    """
    Extract the Dockerfile instruction keyword from a CREATED BY string.

    Docker stores the original instruction in history output. Each layer line
    starts with an optional layer number like '#(25)'. I strip that, then grab
    the first token. If it starts with '/' (e.g. '/bin/sh -c') I know it's a
    shell-form RUN that the Dockerfile wrote as 'RUN pip install ...'.
    """
    cleaned = re.sub(r"^#\(\d+\)\s*", "", created_by.strip())
    if not cleaned:
        return "UNKNOWN"
    first = cleaned.split()[0]
    if first.startswith("/"):
        return "RUN"
    return first.upper()


def main() -> int:
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <image_name>", file=sys.stderr)
        return 1

    image_name = sys.argv[1]

    try:
        rows = get_history(image_name)
    except subprocess.CalledProcessError as exc:
        print(f"docker history failed: {exc.stderr.strip()}", file=sys.stderr)
        return 1
    except FileNotFoundError:
        print("docker is not installed or not on PATH", file=sys.stderr)
        return 1

    if not rows:
        print(f"No layers found for image '{image_name}'", file=sys.stderr)
        return 1

    by_instruction: dict[str, int] = defaultdict(int)
    total_bytes = 0

    for created_by, size_str in rows:
        size_bytes = parse_size(size_str)
        instr = instruction_of(created_by)
        by_instruction[instr] += size_bytes
        total_bytes += size_bytes

    print(f"\nImage: {image_name}")
    print(f"Total size: {human_readable(total_bytes)}")
    print()
    print(f"{'Instruction':<20} {'Size':>12} {'%':>6}")
    print("-" * 42)

    for instr, size_bytes in sorted(by_instruction.items(), key=lambda x: -x[1]):
        pct = (size_bytes / total_bytes * 100) if total_bytes > 0 else 0
        print(f"{instr:<20} {human_readable(size_bytes):>12} {pct:>5.1f}%")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())

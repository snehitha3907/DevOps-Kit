# last_verified: 2026-09-24 · python n/a · docker-sdk n/a

"""
Inspect a container image's layers and metadata with the Docker SDK for
Python — L2 concept exercise for Containerization Concepts.

I wanted the same "which layer is fat" view I get from `docker history`, but
driven through the Docker SDK instead of shelling out to the CLI. The SDK
exposes `image.attrs["RootFS"]["Layers"]` (the layer digests in order) plus
`image.history()` (the original Dockerfile instruction per layer). I combine
the two: each history row carries a `Size` field, so I can group bytes by
instruction the same way I would from the CLI, without parsing terminal
column output.

Usage:
    python3 inspect_image_layers_with_docker_sdk.py <image_name>
"""

import sys
from collections import defaultdict

try:
    import docker
except ImportError:
    print("docker SDK not installed: pip install docker", file=sys.stderr)
    raise SystemExit(2)


def human_readable(num_bytes: int) -> str:
    """Format a byte count back into a Docker-style size string."""
    for unit in ("B", "KB", "MB", "GB", "TB"):
        if abs(num_bytes) < 1024 or unit == "TB":
            return f"{num_bytes:.1f} {unit}"
        num_bytes /= 1024
    return f"{num_bytes:.1f} PB"


def main() -> int:
    if len(sys.argv) != 2:
        print(f"Usage: {sys.argv[0]} <image_name>", file=sys.stderr)
        return 1

    image_name = sys.argv[1]
    client = docker.from_env()

    try:
        image = client.images.get(image_name)
    except docker.errors.ImageNotFound:
        print(f"Image not found: {image_name}", file=sys.stderr)
        return 1
    except docker.errors.APIError as exc:
        print(f"Docker API error: {exc}", file=sys.stderr)
        return 1

    # history() returns layers newest-first; each row's "Id" is the layer it
    # produced, and "Size" is what that layer added. I walk them in order.
    history = image.history()
    if not history:
        print(f"No layer history for image '{image_name}'", file=sys.stderr)
        return 1

    by_instruction: dict[str, int] = defaultdict(int)
    total_bytes = 0
    for layer in history:
        size_bytes = int(layer.get("Size") or 0)
        # The CreatedBy field holds the original Dockerfile instruction; the
        # leading "#(n)" is the layer number the CLI prints. Strip it, then
        # take the first token as the instruction keyword.
        created_by = (layer.get("CreatedBy") or "").strip()
        cleaned = created_by.lstrip("#").lstrip("(0123456789)").strip()
        instruction = cleaned.split()[0].upper() if cleaned else "UNKNOWN"
        if instruction.startswith("/"):
            instruction = "RUN"  # shell-form RUN stored as /bin/sh -c ...
        by_instruction[instruction] += size_bytes
        total_bytes += size_bytes

    tags = ", ".join(image.tags) or "(untagged)"
    print(f"\nImage: {image_name}  tags: {tags}")
    print(f"Layers: {len(history)}")
    print(f"Total size: {human_readable(total_bytes)}")
    print()
    print(f"{'Instruction':<20} {'Size':>12} {'%':>6}")
    print("-" * 42)
    for instruction, size_bytes in sorted(by_instruction.items(), key=lambda x: -x[1]):
        pct = (size_bytes / total_bytes * 100) if total_bytes > 0 else 0
        print(f"{instruction:<20} {human_readable(size_bytes):>12} {pct:>5.1f}%")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
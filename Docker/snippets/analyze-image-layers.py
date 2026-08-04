# last_verified: 2026-08-04 · Docker n/a
"""Analyze Docker image size and layer composition for optimization."""

import json
import subprocess
import sys


def get_image_history(image_name, tag="latest"):
    """Retrieve layer history for a Docker image."""
    try:
        result = subprocess.run(
            ["docker", "history", "--format", "{{json .}}", f"{image_name}:{tag}"],
            capture_output=True,
            text=True,
            check=True,
        )
        layers = []
        for line in result.stdout.strip().split("\n"):
            if line.strip():
                layers.append(json.loads(line))
        return layers
    except subprocess.CalledProcessError as e:
        print(f"Error retrieving image history: {e.stderr}", file=sys.stderr)
        sys.exit(1)


def analyze_layers(layers):
    """Analyze layer sizes and identify optimization opportunities."""
    total_size = 0
    layer_details = []

    for i, layer in enumerate(layers):
        size_str = layer.get("Size", "0 B")
        try:
            size_bytes = parse_size(size_str)
        except ValueError:
            size_bytes = 0
        total_size += size_bytes
        layer_details.append({
            "index": i,
            "command": layer.get("CREATED_BY", ""),
            "size": size_str,
            "size_bytes": size_bytes,
        })

    return layer_details, total_size


def parse_size(size_str):
    """Parse Docker size string to bytes."""
    size_str = size_str.strip()
    if size_str.endswith("GB"):
        return float(size_str[:-2]) * 1024 ** 3
    elif size_str.endswith("MB"):
        return float(size_str[:-2]) * 1024 ** 2
    elif size_str.endswith("KB"):
        return float(size_str[:-3]) * 1024
    elif size_str.endswith("B"):
        return float(size_str[:-2])
    return 0


def print_report(layer_details, total_size):
    """Print a formatted layer analysis report."""
    print(f"{'Layer':<6} {'Size':>10} {'Command'}")
    print(f"{'-----':<6} {'-------':>10} {'-------'}")
    for layer in layer_details:
        cmd = layer["command"][:60] + "..." if len(layer["command"]) > 60 else layer["command"]
        print(f"{layer['index']:<6} {layer['size']:>10} {cmd}")
    print(f"\nTotal image size: {total_size / (1024**2):.1f} MB")

    largest = max(layer_details, key=lambda x: x["size_bytes"])
    print(f"Largest layer: #{largest['index']} ({largest['size']})")
    print(f"  Command: {largest['command'][:80]}")


def main():
    if len(sys.argv) < 2:
        print("Usage: analyze-image-layers.py <image_name> [tag]", file=sys.stderr)
        sys.exit(1)

    image_name = sys.argv[1]
    tag = sys.argv[2] if len(sys.argv) > 2 else "latest"

    layers = get_image_history(image_name, tag)
    layer_details, total_size = analyze_layers(layers)
    print_report(layer_details, total_size)


if __name__ == "__main__":
    main()
#!/bin/bash
# last_verified: 2026-09-21 · Trivy latest
# Batch image scanning pipeline: scan a list of images from a file and
# consolidate per-image findings into one SARIF report for CI consumption.
#
# Usage:
#   ./scan-images-from-file-consolidated-sarif.sh <image-list-file> [output.sarif]
#
# The image-list file has one image per line (blank lines and lines starting
# with # are skipped). Each image is scanned with `trivy image`, and the
# per-image SARIF fragments are merged into a single SARIF file.

set -u

IMAGE_LIST="${1:-}"
OUTPUT="${2:-trivy-batch.sarif}"

if [ -z "$IMAGE_LIST" ]; then
  echo "usage: $0 <image-list-file> [output.sarif]" >&2
  exit 2
fi

if [ ! -f "$IMAGE_LIST" ]; then
  echo "image list file not found: $IMAGE_LIST" >&2
  exit 2
fi

WORKDIR="$(mktemp -d)"
trap 'rm -rf "$WORKDIR"' EXIT

FRAGMENTS=()
while IFS= read -r line; do
  line="${line%%#*}"
  [ -z "$line" ] && continue
  image="$(echo "$line" | tr -d '[:space:]')"
  [ -z "$image" ] && continue

  echo "==> scanning $image"
  fragment="$WORKDIR/$(echo "$image" | tr '/:' '__').sarif"
  trivy image --format sarif --output "$fragment" "$image"
  FRAGMENTS+=("$fragment")
done < "$IMAGE_LIST"

if [ "${#FRAGMENTS[@]}" -eq 0 ]; then
  echo "no images to scan" >&2
  exit 1
fi

echo "==> merging ${#FRAGMENTS[@]} SARIF fragment(s) into $OUTPUT"
python3 - "$OUTPUT" "${FRAGMENTS[@]}" <<'PY'
import json, sys

out_path = sys.argv[1]
frag_paths = sys.argv[2:]

runs = []
for p in frag_paths:
    with open(p) as f:
        data = json.load(f)
    for run in data.get("runs", []):
        runs.append(run)

merged = {
    "version": "2.1.0",
    "runs": runs,
}

with open(out_path, "w") as f:
    json.dump(merged, f, indent=2)

print(f"wrote {out_path} with {len(runs)} run(s)")
PY

echo "done"
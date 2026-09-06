#!/usr/bin/env bash
# last_verified: 2026-09-06 · Docker · n/a

# Practice: building, tagging, and running a container with the Docker lifecycle.
# I wanted to walk through the full cycle — build an image from a Dockerfile,
# tag it with a version, run it, verify it works, then clean up.

IMAGE_NAME="lifecycle-practice"
FIRST_TAG="v1.0.0"
SECOND_TAG="v1.1.0"
CONTAINER_NAME="lifecycle-test-container"
PORT=8080

# --- Step 1: Create a minimal app to containerize ---
# I always start with something tiny so I can verify the whole chain works.
WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

cat > "$WORK_DIR/Dockerfile" <<'EOF'
FROM python:3.12-slim
WORKDIR /app
COPY app.py .
EXPOSE 8080
CMD ["python", "app.py"]
EOF

cat > "$WORK_DIR/app.py" <<'EOF'
from http.server import HTTPServer, SimpleHTTPRequestHandler
import json, os

class Handler(SimpleHTTPRequestHandler):
    def do_GET(self):
        version = os.environ.get("APP_VERSION", "unknown")
        self.send_response(200)
        self.send_header("Content-Type", "application/json")
        self.end_headers()
        self.wfile.write(json.dumps({"version": version, "status": "ok"}).encode())

HTTPServer(("0.0.0.0", 8080), Handler).serve_forever()
EOF

echo "=== Step 1: Building image with tag $FIRST_TAG ==="
docker build -t "$IMAGE_NAME:$FIRST_TAG" "$WORK_DIR"
echo "Built $IMAGE_NAME:$FIRST_TAG"

echo ""
echo "=== Step 2: Running the container ==="
docker run -d --name "$CONTAINER_NAME" -p "$PORT:8080" "$IMAGE_NAME:$FIRST_TAG"
sleep 2

echo "=== Step 3: Verifying the container responds ==="
RESPONSE=$(curl -s "http://localhost:$PORT")
echo "Response: $RESPONSE"

# Check that the version field matches what we built
if echo "$RESPONSE" | grep -q "$FIRST_TAG"; then
    echo "[OK] Container is serving the correct version."
else
    echo "[WARN] Version mismatch — expected $FIRST_TAG in response."
fi

echo ""
echo "=== Step 4: Tagging the same image with a new version ==="
docker tag "$IMAGE_NAME:$FIRST_TAG" "$IMAGE_NAME:$SECOND_TAG"
echo "Tagged $IMAGE_NAME:$SECOND_TAG (same image, different tag)"
docker images "$IMAGE_NAME" --format "table {{.Tag}}\t{{.Size}}\t{{.CreatedSince}}"

echo ""
echo "=== Step 5: Inspecting the image layers ==="
docker history "$IMAGE_NAME:$FIRST_TAG" --format "table {{.CreatedBy}}\t{{.Size}}"

echo ""
echo "=== Step 6: Cleaning up ==="
docker stop "$CONTAINER_NAME" >/dev/null 2>&1
docker rm "$CONTAINER_NAME" >/dev/null 2>&1
echo "Stopped and removed container $CONTAINER_NAME"
echo "Images kept — you can remove them with:"
echo "  docker rmi $IMAGE_NAME:$FIRST_TAG $IMAGE_NAME:$SECOND_TAG"

echo ""
echo "=== Done ==="
echo "Full lifecycle exercised: build → run → verify → tag → inspect → cleanup"

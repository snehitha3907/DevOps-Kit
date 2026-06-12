#!/bin/bash
# 2026-06-12-compose-multi-service.sh
# Trying docker compose with a web + db stack — following the Docker quickstart

set -e

STACK_DIR=$(mktemp -d)
trap 'rm -rf "$STACK_DIR"' EXIT

cat > "$STACK_DIR/compose.yaml" << 'EOF'
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
  api:
    image: nginx:alpine
    ports:
      - "8081:80"
EOF

cd "$STACK_DIR"

echo "=== Starting multi-service stack ==="
docker compose up -d

echo "=== Checking containers ==="
docker compose ps

echo "=== Verifying web service responds ==="
sleep 2
curl -s -o /dev/null -w "web HTTP %{http_code}\n" http://localhost:8080 || echo "web not reachable yet — might need more time"

echo "=== Checking logs ==="
docker compose logs --tail=5

echo "=== Tearing down ==="
docker compose down

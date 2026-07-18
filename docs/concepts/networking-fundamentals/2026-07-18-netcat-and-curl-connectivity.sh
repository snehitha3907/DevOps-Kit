#!/usr/bin/env bash
# last_verified: 2026-07-18 · bash 5.1 · curl 8 · netcat (openbsd)
# Practice: test network connectivity and ports with curl and netcat (nc).
# I wrote this after the networking quickstart to actually feel packets move.

echo "== 1. Is the host reachable at all? (ICMP) =="
ping -c 3 1.1.1.1 || echo "ping blocked (common in CI) — moving on"

echo "== 2. Is a TCP port open? (nc connect probe) =="
HOST="example.com"
PORT=443
timeout 5 bash -c "echo > /dev/tcp/$HOST/$PORT" 2>/dev/null \
  && echo "$HOST:$PORT is OPEN (bash /dev/tcp)" \
  || echo "$HOST:$PORT is CLOSED/unreachable"

echo "== 3. Grab a header with curl to confirm HTTP works =="
curl -sS -I https://example.com | head -n 5

echo "== 4. Spin up a tiny listener and talk to it with nc =="
MSG="hello-from-nc"
PORT=9001
nc -l -p "$PORT" > /tmp/nc-recv.txt &
LISTENER=$!
sleep 1
echo "$MSG" | nc -N 127.0.0.1 "$PORT"
sleep 1
echo "listener received: $(cat /tmp/nc-recv.txt)"
kill "$LISTENER" 2>/dev/null

echo "== 5. Quick port-scan a few common ports on localhost =="
for p in 22 80 443 5432; do
  timeout 1 bash -c "echo > /dev/tcp/127.0.0.1/$p" 2>/dev/null \
    && echo "localhost:$p OPEN" || echo "localhost:$p closed"
done

rm -f /tmp/nc-recv.txt
echo "done"

# last_verified: 2026-10-19 · Prometheus n/a
"""Small service exposing custom Prometheus counters and histograms on /metrics.

Purpose: register a request counter and a response-latency histogram, serve
them on /metrics in Prometheus exposition format, and show how to verify the
scrape with promtool.

This is one way to do it; the prometheus_client docs also cover custom
registries, labels, and bucket tuning. The default histogram buckets are a
starting point and should be resized once a real latency distribution is
known.

Prerequisites:
  pip install prometheus-client

Steps:
  1. python3 custom-metrics-service.py --port 9091
  2. curl http://127.0.0.1:9091/metrics > /tmp/custom-metrics.out
  3. promtool check metrics /tmp/custom-metrics.out   # validates exposition format
  4. Point a Prometheus scrape job at http://127.0.0.1:9091/metrics and confirm the target is UP.

Verify:
  curl /metrics returns HELP/TYPE lines plus current counter and histogram
  samples; promtool check metrics exits 0 on the captured output; the scrape
  target reports UP in Prometheus.
"""

import argparse
import random
import sys
import threading
import time

try:
    from prometheus_client import Counter, Histogram, generate_latest, start_http_server
except ImportError as exc:  # pragma: no cover - prerequisite guidance
    print(
        "custom-metrics-service.py requires the prometheus-client package: "
        "pip install prometheus-client",
        file=sys.stderr,
    )
    raise

REQUESTS_TOTAL = Counter(
    "demo_http_requests_total",
    "Total demo requests handled.",
    ["method", "endpoint"],
)
REQUEST_LATENCY_SECONDS = Histogram(
    "demo_http_request_duration_seconds",
    "Demo request latency in seconds.",
)

STOP = threading.Event()

METHODS = ["GET", "POST"]
ENDPOINTS = ["/api/health", "/api/data", "/api/webhook"]


def emit_sample_data(samples=20):
    """Record a few representative requests so /metrics is not empty."""
    for _ in range(samples):
        method = random.choice(METHODS)
        endpoint = random.choice(ENDPOINTS)
        start = time.monotonic()
        time.sleep(random.uniform(0.005, 0.05))
        REQUESTS_TOTAL.labels(method=method, endpoint=endpoint).inc()
        REQUEST_LATENCY_SECONDS.observe(time.monotonic() - start)


def simulate_workload(stop):
    while not stop.is_set():
        emit_sample_data(5)
        stop.wait(0.5)


def run_server(port):
    start_http_server(port)
    worker = threading.Thread(target=simulate_workload, args=(STOP,), daemon=True)
    worker.start()
    print("serving /metrics on port %d (Ctrl-C to stop)" % port)
    try:
        while not STOP.is_set():
            time.sleep(1)
    except KeyboardInterrupt:
        print("shutting down")
    finally:
        STOP.set()


def main(argv=None):
    parser = argparse.ArgumentParser(
        description="Expose custom Prometheus counters and histograms on /metrics."
    )
    parser.add_argument(
        "--port", type=int, default=9091, help="Port to serve /metrics on."
    )
    parser.add_argument(
        "--once",
        action="store_true",
        help="Emit a sample snapshot to stdout and exit (useful for promtool).",
    )
    args = parser.parse_args(argv)
    if not 1 <= args.port <= 65535:
        parser.error("port must be in range 1-65535")
    emit_sample_data()
    if args.once:
        print(generate_latest().decode("utf-8"), end="")
        return 0
    run_server(args.port)
    return 0


if __name__ == "__main__":
    sys.exit(main())

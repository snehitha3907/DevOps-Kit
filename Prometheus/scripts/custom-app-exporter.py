# last_verified: 2026-09-30 · Prometheus n/a
"""Custom application exporter built from scratch with the standard library.

Purpose: expose a small set of application metrics on a /metrics endpoint
in Prometheus exposition format, without taking on an extra dependency.

This is one way to do it; the docs also describe client libraries that
handle exposition, registries, and histograms for you. This script keeps
the raw wiring visible so the format and the scrape contract are clear.

Steps:
  1. Run: python3 custom-app-exporter.py --port 8000
  2. Point a scrape job at the host:port (see configs/recording-vs-alerting-rules.yaml
     for what happens after metrics arrive).
  3. Visit /metrics to confirm output, then check the target is UP.

Verify: curl localhost:8000/metrics shows HELP/TYPE lines plus current
counter values; curl localhost:8000/healthz returns ok.
"""

import argparse
import threading
import time
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlparse


class AppMetrics:
    """Thread-safe counters for a demo request path."""

    def __init__(self):
        self._lock = threading.Lock()
        self.requests_total = 0
        self.errors_total = 0
        self.in_flight = 0
        self.latency_sum = 0.0
        self.latency_count = 0

    def observe(self, latency_seconds, failed):
        with self._lock:
            self.requests_total += 1
            if failed:
                self.errors_total += 1
            self.latency_sum += latency_seconds
            self.latency_count += 1

    def render(self):
        with self._lock:
            requests = self.requests_total
            errors = self.errors_total
            in_flight = self.in_flight
            avg = (self.latency_sum / self.latency_count) if self.latency_count else 0.0
        lines = [
            "# HELP demo_http_requests_total Total demo requests handled.",
            "# TYPE demo_http_requests_total counter",
            "demo_http_requests_total %d" % requests,
            "# HELP demo_http_errors_total Total failed demo requests.",
            "# TYPE demo_http_errors_total counter",
            "demo_http_errors_total %d" % errors,
            "# HELP demo_http_in_flight Current in-flight demo requests.",
            "# TYPE demo_http_in_flight gauge",
            "demo_http_in_flight %d" % in_flight,
            "# HELP demo_http_latency_seconds_avg Average observed latency.",
            "# TYPE demo_http_latency_seconds_avg gauge",
            "demo_http_latency_seconds_avg %.6f" % avg,
        ]
        return "\n".join(lines) + "\n"


METRICS = AppMetrics()


class Handler(BaseHTTPRequestHandler):
    def log_message(self, *args):  # keep scrape logs quiet; server logs via stderr otherwise
        pass

    def _send(self, code, body, content_type="text/plain"):
        data = body.encode("utf-8")
        self.send_response(code)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def do_GET(self):
        path = urlparse(self.path).path
        if path == "/metrics":
            self._send(200, METRICS.render())
            return
        if path == "/healthz":
            self._send(200, "ok\n")
            return
        if path == "/demo":
            # A fake workload endpoint so there is something to count.
            start = time.monotonic()
            failed = "fail=1" in (urlparse(self.path).query or "")
            with _in_flight():
                time.sleep(0.01)  # stand-in for real work
            METRICS.observe(time.monotonic() - start, failed)
            if failed:
                self._send(500, "simulated error\n")
            else:
                self._send(200, "demo ok\n")
            return
        self._send(404, "not found\n")


class _in_flight:
    def __enter__(self):
        with METRICS._lock:
            METRICS.in_flight += 1

    def __exit__(self, *exc):
        with METRICS._lock:
            METRICS.in_flight -= 1
        return False


def parse_args(argv=None):
    parser = argparse.ArgumentParser(description="Minimal Prometheus exporter from scratch.")
    parser.add_argument("--host", default="127.0.0.1", help="Interface to bind.")
    parser.add_argument("--port", type=int, default=8000, help="Port to serve /metrics on.")
    args = parser.parse_args(argv)
    if not 1 <= args.port <= 65535:
        parser.error("port must be in range 1-65535")
    return args


def main(argv=None):
    args = parse_args(argv)
    server = ThreadingHTTPServer((args.host, args.port), Handler)
    print("serving /metrics on %s:%d (Ctrl-C to stop)" % (args.host, args.port))
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        print("shutting down")
    finally:
        server.server_close()


if __name__ == "__main__":
    main()

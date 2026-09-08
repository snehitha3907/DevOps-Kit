# last_verified: 2026-09-08 · Monitoring & Observability Concepts · n/a
"""
I built this to practice the monitoring concepts from the primer: a metrics
exporter plus a structured logger, in one small Python program.

The exporter exposes Prometheus-style text metrics over HTTP on /metrics, and
the logger emits one JSON line per log record to stdout. The two surfaces feed
each other: every request bumps a counter, adds a latency observation, and
logs a structured line carrying the same route and status labels. That is the
RED method (Rate / Errors / Duration) and the structured-log half of the
observability exercise in one place.
"""

import json
import logging
import sys
import threading
from http.server import BaseHTTPRequestHandler, HTTPServer
from time import time


class StructuredLogger:
    """A logger that emits one JSON line per record — the structured-log half."""

    def __init__(self, name="app"):
        self.logger = logging.getLogger(name)
        self.logger.setLevel(logging.INFO)
        # Don't let the default logger add its own format; we want raw JSON.
        handler = logging.StreamHandler(sys.stdout)
        handler.setFormatter(logging.Formatter("%(message)s"))
        self.logger.addHandler(handler)

    def emit(self, level, message, **fields):
        record = {
            "timestamp": int(time()),
            "level": level,
            "message": message,
            **fields,
        }
        self.logger.info(json.dumps(record, default=str))


class MetricsExporter:
    """Prometheus-style text metrics, exposed over HTTP on /metrics."""

    def __init__(self):
        self._counters = {}
        self._gauges = {}
        self._histograms = {}
        self._lock = threading.Lock()

    def inc(self, name, value=1.0, labels=None):
        """Bump a counter — the Rate in RED."""
        with self._lock:
            key = self._key(name, labels)
            self._counters[key] = self._counters.get(key, 0.0) + value

    def set(self, name, value, labels=None):
        """Set a gauge — a point-in-time value such as queue depth."""
        with self._lock:
            self._gauges[self._key(name, labels)] = value

    def observe(self, name, value, labels=None):
        """Record a sample in a histogram — the Duration in RED."""
        with self._lock:
            self._histograms.setdefault(self._key(name, labels), []).append(value)

    @staticmethod
    def _key(name, labels):
        if not labels:
            return name
        joined = ",".join(f'{k}="{v}"' for k, v in sorted(labels.items()))
        return f'{name}{{{joined}}}'

    def render(self):
        """Produce the /metrics text body."""
        lines = []
        with self._lock:
            for key, val in sorted(self._counters.items()):
                lines.append(f"{key} {val}")
            for key, val in sorted(self._gauges.items()):
                lines.append(f"{key} {val}")
            for key, vals in sorted(self._histograms.items()):
                lines.append(f"{key}_count {len(vals)}")
                lines.append(f"{key}_sum {sum(vals)}")
        return "\n".join(lines) + "\n"


# A single exporter + logger shared across the request handler.
metrics = MetricsExporter()
log = StructuredLogger("metrics-demo")


class Handler(BaseHTTPRequestHandler):
    def do_GET(self):
        start = time()
        if self.path == "/metrics":
            body = metrics.render().encode()
            self.send_response(200)
            self.send_header("Content-Type", "text/plain; version=0.0.4")
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            status = "200"
        else:
            body = b"GET /metrics to read the exporter\n"
            self.send_response(204)
            self.send_header("Content-Length", str(len(body)))
            self.end_headers()
            self.wfile.write(body)
            status = "204"

        # The point of the exercise: metrics and logs carry the same labels.
        route = self.path
        metrics.inc("http_requests_total", labels={"route": route, "code": status})
        metrics.observe("http_request_duration_seconds", time() - start,
                        labels={"route": route, "code": status})
        log.emit("INFO", "request served", route=route, code=status,
                 duration_ms=round((time() - start) * 1000, 2))

    def log_message(self, fmt, *args):
        # Silence the default access-log noise; our StructuredLogger covers it.
        pass


def main():
    port = int(sys.argv[1]) if len(sys.argv) > 1 else 8000
    metrics.set("app_info", 1, labels={"version": "0.1.0"})
    server = HTTPServer(("0.0.0.0", port), Handler)
    log.emit("INFO", "exporter listening", port=port)
    try:
        server.serve_forever()
    except KeyboardInterrupt:
        pass
    finally:
        server.server_close()


if __name__ == "__main__":
    main()
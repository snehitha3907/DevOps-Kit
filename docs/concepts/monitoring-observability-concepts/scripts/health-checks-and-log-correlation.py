# last_verified: 2026-09-19 · monitoring-observability-concepts (stdlib only, no external version)
"""Scripted health checks with log correlation.

Combines two adjacent concepts: Networking Fundamentals (TCP/HTTP reachability
probing) with Monitoring & Observability (structured JSONL logs plus a small
correlation step that ties a failing check back to the log lines for that
target). This is one way to wire the two together; a bigger setup would ship
these signals to a collector instead of a local file.

Run:  python3 health-checks-and-log-correlation.py
The demo spins up two loopback HTTP servers (one healthy, one flaky), probes
four targets covering pass / HTTP-error / refused / DNS-failure, writes one
JSONL log per check, then prints a correlated failure report.
"""
import http.server
import json
import socket
import threading
import time
import urllib.request
import urllib.error

TIMEOUT_S = 2.0


def check_tcp(host, port, timeout=TIMEOUT_S):
    """Probe TCP reachability; returns dict with ok/latency/detail."""
    start = time.monotonic()
    try:
        with socket.create_connection((host, port), timeout=timeout):
            pass
    except socket.gaierror as exc:
        return {"ok": False, "latency_ms": None, "detail": "dns-failure: %s" % exc}
    except (ConnectionRefusedError, TimeoutError, OSError) as exc:
        ms = round((time.monotonic() - start) * 1000, 1)
        return {"ok": False, "latency_ms": ms, "detail": "%s: %s" % (type(exc).__name__, exc)}
    ms = round((time.monotonic() - start) * 1000, 1)
    return {"ok": True, "latency_ms": ms, "detail": "tcp-connect"}


def check_http(url, timeout=TIMEOUT_S):
    """GET a URL; non-2xx counts as unhealthy. Returns dict."""
    start = time.monotonic()
    try:
        with urllib.request.urlopen(url, timeout=timeout) as resp:
            ms = round((time.monotonic() - start) * 1000, 1)
            ok = 200 <= resp.status < 300
            return {"ok": ok, "latency_ms": ms,
                    "detail": "http-%s" % resp.status}
    except urllib.error.HTTPError as exc:
        ms = round((time.monotonic() - start) * 1000, 1)
        return {"ok": False, "latency_ms": ms, "detail": "http-%s" % exc.code}
    except Exception as exc:  # URLError wraps DNS/refused/timeout for urlopen
        ms = round((time.monotonic() - start) * 1000, 1)
        return {"ok": False, "latency_ms": ms,
                "detail": "%s: %s" % (type(exc).__name__, exc)}


def log_record(target, result):
    """One structured log line per check — the correlation key is `target`."""
    return {"ts": round(time.time(), 3), "check": "health", "target": target,
            "ok": result["ok"], "latency_ms": result["latency_ms"],
            "detail": result["detail"]}


def correlate(records):
    """Group failing targets with their own log lines (log correlation)."""
    by_target = {}
    for rec in records:
        by_target.setdefault(rec["target"], []).append(rec)
    report = {}
    for target, lines in by_target.items():
        failures = [r for r in lines if not r["ok"]]
        if failures:
            report[target] = {"failures": len(failures),
                              "last_detail": failures[-1]["detail"],
                              "context_lines": len(lines)}
    return report


class _Handler(http.server.BaseHTTPRequestHandler):
    flaky = False

    def do_GET(self):  # noqa: N802 (BaseHTTPRequestHandler naming)
        if self.flaky:
            body, status = b"boom\n", 500
        else:
            body, status = b"ok\n", 200
        self.send_response(status)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args):  # keep demo output clean
        pass


def _serve(handler_cls):
    srv = http.server.HTTPServer(("127.0.0.1", 0), handler_cls)
    thread = threading.Thread(target=srv.serve_forever, daemon=True)
    thread.start()
    return srv


def main():
    healthy = _serve(_Handler)
    flaky_cls = type("FlakyHandler", (_Handler,), {"flaky": True})
    flaky = _serve(flaky_cls)
    refused_port = 9  # discard port: nothing listens on loopback here

    targets = {
        "healthy-local": "http://127.0.0.1:%d/" % healthy.server_port,
        "flaky-local": "http://127.0.0.1:%d/" % flaky.server_port,
        "refused-port": "http://127.0.0.1:%d/" % refused_port,
        "bad-hostname": "http://nonexistent.invalid/",
    }
    records = []
    for name, url in targets.items():
        result = check_http(url)
        records.append(log_record(name, result))
        print("%-14s ok=%-5s latency=%s detail=%s"
              % (name, result["ok"], result["latency_ms"], result["detail"]))

    print("\ncorrelated failures:")
    print(json.dumps(correlate(records), indent=2))

    healthy.shutdown()
    flaky.shutdown()
    return records


if __name__ == "__main__":
    main()

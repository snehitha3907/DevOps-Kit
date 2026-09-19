# last_verified: 2026-09-19 · monitoring-observability-concepts (stdlib only, no external version)
"""Scripted health gate with correlated logs.

Combines Networking Fundamentals (DNS resolution timing plus TCP/HTTP
reachability probing) with Monitoring & Observability (one structured log
event per probe stage, tied together by a shared correlation id, plus a
gate verdict per target). This is one way to wire the two together: the
probe-correlate-decide shape mirrors a deployment checkpoint that holds a
rollout when health signals go red, while a larger setup would ship these
events to a collector instead of printing them locally.

Run:  python3 scripted-health-gate-with-correlated-logs.py
The demo spins up two loopback HTTP servers (fast healthy, slow healthy),
then evaluates four targets covering pass / slow-pass / refused / DNS
failure, prints one JSON event per probe stage, and ends with a per-target
gate verdict (proceed or hold) plus an overall go/no-go.
"""

import http.server
import json
import socket
import threading
import time
import urllib.error
import urllib.request

TIMEOUT_S = 2.0
SLOW_THRESHOLD_MS = 500.0


def resolve_dns(host, timeout=TIMEOUT_S):
    """Resolve a hostname; returns dict with ok/latency/detail."""
    start = time.monotonic()
    try:
        socket.getaddrinfo(host, None)
    except socket.gaierror as exc:
        ms = round((time.monotonic() - start) * 1000, 1)
        return {"ok": False, "latency_ms": ms, "detail": "dns-failure: %s" % exc}
    ms = round((time.monotonic() - start) * 1000, 1)
    return {"ok": True, "latency_ms": ms, "detail": "dns-ok"}


def check_tcp(host, port, timeout=TIMEOUT_S):
    """Probe TCP reachability; returns dict with ok/latency/detail."""
    start = time.monotonic()
    try:
        with socket.create_connection((host, port), timeout=timeout):
            pass
    except (ConnectionRefusedError, TimeoutError, OSError) as exc:
        ms = round((time.monotonic() - start) * 1000, 1)
        return {"ok": False, "latency_ms": ms,
                "detail": "%s: %s" % (type(exc).__name__, exc)}
    ms = round((time.monotonic() - start) * 1000, 1)
    return {"ok": True, "latency_ms": ms, "detail": "tcp-connect"}


def check_http(url, timeout=TIMEOUT_S):
    """GET a URL; non-2xx counts as unhealthy. Returns dict."""
    start = time.monotonic()
    try:
        with urllib.request.urlopen(url, timeout=timeout) as resp:
            ms = round((time.monotonic() - start) * 1000, 1)
            ok = 200 <= resp.status < 300
            return {"ok": ok, "latency_ms": ms, "detail": "http-%s" % resp.status}
    except urllib.error.HTTPError as exc:
        ms = round((time.monotonic() - start) * 1000, 1)
        return {"ok": False, "latency_ms": ms, "detail": "http-%s" % exc.code}
    except Exception as exc:  # URLError wraps DNS/refused/timeout for urlopen
        ms = round((time.monotonic() - start) * 1000, 1)
        return {"ok": False, "latency_ms": ms,
                "detail": "%s: %s" % (type(exc).__name__, exc)}


def log_event(correlation_id, target, stage, result):
    """One structured log event per probe stage, sharing a correlation id."""
    return {"ts": round(time.time(), 3), "correlation_id": correlation_id,
            "target": target, "stage": stage, "ok": result["ok"],
            "latency_ms": result["latency_ms"], "detail": result["detail"]}


def gate_verdict(events):
    """Decide proceed/hold per correlation id from its staged events."""
    by_id = {}
    for evt in events:
        by_id.setdefault(evt["correlation_id"], []).append(evt)
    verdicts = {}
    for cid, staged in by_id.items():
        failed = [e for e in staged if not e["ok"]]
        slow = [e for e in staged
                if e["latency_ms"] is not None and e["latency_ms"] > SLOW_THRESHOLD_MS]
        target = staged[0]["target"]
        if failed:
            verdicts[cid] = {"target": target, "verdict": "hold",
                             "reason": failed[0]["detail"],
                             "stages": len(staged)}
        elif slow:
            verdicts[cid] = {"target": target, "verdict": "hold",
                             "reason": "slow: %sms over %sms budget" % (
                                 slow[0]["latency_ms"], SLOW_THRESHOLD_MS),
                             "stages": len(staged)}
        else:
            verdicts[cid] = {"target": target, "verdict": "proceed",
                             "reason": "all stages ok", "stages": len(staged)}
    return verdicts


class _FastHandler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):  # noqa: N802 (BaseHTTPRequestHandler naming)
        body = b"ok\n"
        self.send_response(200)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *args):  # keep demo output clean
        pass


class _SlowHandler(_FastHandler):
    def do_GET(self):  # noqa: N802 (BaseHTTPRequestHandler naming)
        time.sleep(0.8)  # over the slow budget, still HTTP 200
        super().do_GET()


def _serve(handler_cls):
    srv = http.server.HTTPServer(("127.0.0.1", 0), handler_cls)
    thread = threading.Thread(target=srv.serve_forever, daemon=True)
    thread.start()
    return srv


def evaluate_target(correlation_id, name, host, port, url):
    """Run the DNS -> TCP -> HTTP stages for one target; returns events."""
    events = []
    dns = resolve_dns(host)
    events.append(log_event(correlation_id, name, "dns", dns))
    if not dns["ok"]:
        return events
    tcp = check_tcp(host, port)
    events.append(log_event(correlation_id, name, "tcp", tcp))
    if not tcp["ok"]:
        return events
    events.append(log_event(correlation_id, name, "http", check_http(url)))
    return events


def main():
    fast = _serve(_FastHandler)
    slow = _serve(_SlowHandler)
    refused_port = 9  # discard port: nothing listens on loopback here

    targets = {
        "fast-local": ("127.0.0.1", fast.server_port,
                        "http://127.0.0.1:%d/" % fast.server_port),
        "slow-local": ("127.0.0.1", slow.server_port,
                        "http://127.0.0.1:%d/" % slow.server_port),
        "refused-port": ("127.0.0.1", refused_port,
                         "http://127.0.0.1:%d/" % refused_port),
        "bad-hostname": ("nonexistent.invalid", 80, "http://nonexistent.invalid/"),
    }
    events = []
    for i, (name, (host, port, url)) in enumerate(targets.items(), start=1):
        cid = "chk-%02d" % i
        events.extend(evaluate_target(cid, name, host, port, url))

    for evt in events:
        print(json.dumps(evt))

    verdicts = gate_verdict(events)
    print("\ngate verdicts:")
    print(json.dumps(verdicts, indent=2))
    blocked = [v for v in verdicts.values() if v["verdict"] == "hold"]
    print("\noverall: %s (%d of %d targets on hold)"
          % ("NO-GO" if blocked else "GO", len(blocked), len(verdicts)))

    fast.shutdown()
    slow.shutdown()
    return events


if __name__ == "__main__":
    main()

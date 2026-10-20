# last_verified: 2026-10-20 · Grafana 13.x

"""Build a multi-panel service dashboard in Grafana from scratch via the HTTP API.

L3 — reference-style helper. Assumes Grafana is running and reachable.
"""

import json
import os
import sys
import urllib.request
import urllib.error


GRAFANA_URL = os.environ.get("GRAFANA_URL", "http://localhost:3000")
GRAFANA_TOKEN = os.environ.get("GRAFANA_TOKEN", "")
DATASOURCE_NAME = os.environ.get("DATASOURCE_NAME", "Prometheus")


def _request(method, path, payload=None):
    url = GRAFANA_URL.rstrip("/") + path
    data = json.dumps(payload).encode() if payload is not None else None
    req = urllib.request.Request(url, data=data, method=method)
    req.add_header("Authorization", f"Bearer {GRAFANA_TOKEN}")
    req.add_header("Content-Type", "application/json")
    try:
        with urllib.request.urlopen(req) as resp:
            return json.loads(resp.read().decode())
    except urllib.error.HTTPError as exc:
        body = exc.read().decode(errors="replace")
        raise RuntimeError(f"{method} {path} -> {exc.code}: {body}") from exc


def ensure_datasource():
    """Return the datasource uid, creating it if missing."""
    existing = _request("GET", "/api/datasources")
    for ds in existing:
        if ds.get("name") == DATASOURCE_NAME:
            return ds["uid"]
    created = _request("POST", "/api/datasources", {
        "name": DATASOURCE_NAME,
        "type": "prometheus",
        "url": "http://prometheus:9090",
        "access": "proxy",
        "isDefault": True,
    })
    return created["datasource"]["uid"]


def build_dashboard(ds_uid):
    panels = []
    # Panel 1: request rate
    panels.append({
        "id": 1,
        "type": "timeseries",
        "title": "Request rate (req/s)",
        "gridPos": {"h": 8, "w": 12, "x": 0, "y": 0},
        "datasource": {"uid": ds_uid},
        "targets": [{"expr": "rate(http_requests_total[5m])", "legendFormat": "{{handler}}"}],
    })
    # Panel 2: error rate
    panels.append({
        "id": 2,
        "type": "timeseries",
        "title": "Error rate (5xx)",
        "gridPos": {"h": 8, "w": 12, "x": 12, "y": 0},
        "datasource": {"uid": ds_uid},
        "targets": [{"expr": "rate(http_requests_total{status=~\"5..\"}[5m])", "legendFormat": "{{handler}}"}],
    })
    # Panel 3: latency p95
    panels.append({
        "id": 3,
        "type": "timeseries",
        "title": "p95 latency",
        "gridPos": {"h": 8, "w": 12, "x": 0, "y": 8},
        "datasource": {"uid": ds_uid},
        "targets": [{"expr": "histogram_quantile(0.95, rate(http_request_duration_seconds_bucket[5m]))", "legendFormat": "p95"}],
    })
    # Panel 4: uptime stat
    panels.append({
        "id": 4,
        "type": "stat",
        "title": "Service uptime",
        "gridPos": {"h": 8, "w": 12, "x": 12, "y": 8},
        "datasource": {"uid": ds_uid},
        "targets": [{"expr": "up", "legendFormat": "{{instance}}"}],
    })

    dashboard = {
        "dashboard": {
            "uid": "service-overview",
            "title": "Service overview",
            "tags": ["service", "overview"],
            "timezone": "browser",
            "panels": panels,
            "schemaVersion": 39,
            "version": 0,
            "refresh": "30s",
        },
        "folderId": 0,
        "overwrite": True,
    }
    result = _request("POST", "/api/dashboards/db", dashboard)
    return result


def main():
    if not GRAFANA_TOKEN:
        print("GRAFANA_TOKEN is required", file=sys.stderr)
        return 2
    ds_uid = ensure_datasource()
    result = build_dashboard(ds_uid)
    print(json.dumps(result, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

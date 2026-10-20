# last_verified: 2026-10-20 · graf 11.x
"""
Purpose: Build a multi-panel service dashboard in Grafana via the HTTP API.

This script creates a Prometheus datasource and a dashboard with four panels
(request rate, error rate, latency p95, and active requests) for a typical
service monitoring use case. It uses the Grafana HTTP API directly rather than
provisioning files, which is useful for dynamic or programmatic dashboard
creation.

When to use:
- Bootstrapping Grafana in environments where provisioning files aren't practical
- Creating dashboards programmatically from service metadata
- CI/CD pipelines that need to register service dashboards on deploy

Prerequisites:
- Grafana 11.x running and accessible
- Admin API key or basic auth credentials with Admin role
- Prometheus datasource already running and reachable from Grafana

Usage:
    export GRAFANA_URL=http://localhost:3000
    export GRAFANA_API_KEY=glsa_...
    export PROMETHEUS_URL=http://prometheus:9090
    python build-multi-panel-service-dashboard-via-http-api.py

Verify:
- Script exits 0 and prints the dashboard UID
- Dashboard appears in Grafana UI under "Service Dashboard"
- All four panels show "No data" initially (expected until metrics flow)

Common errors:
- 401 Unauthorized: API key missing or invalid
- 404 Not Found: Grafana URL wrong or API path changed
- 500 Internal Server Error: Prometheus URL unreachable from Grafana server
- Dashboard already exists: script updates existing dashboard by UID
"""

import argparse
import json
import os
import sys
import urllib.error
import urllib.request


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="Create a multi-panel service dashboard in Grafana via HTTP API"
    )
    parser.add_argument(
        "--grafana-url",
        default=os.environ.get("GRAFANA_URL", "http://localhost:3000"),
        help="Grafana base URL (default: GRAFANA_URL env or http://localhost:3000)",
    )
    parser.add_argument(
        "--api-key",
        default=os.environ.get("GRAFANA_API_KEY"),
        help="Grafana Admin API key (default: GRAFANA_API_KEY env)",
    )
    parser.add_argument(
        "--prometheus-url",
        default=os.environ.get("PROMETHEUS_URL", "http://prometheus:9090"),
        help="Prometheus URL for datasource (default: PROMETHEUS_URL env or http://prometheus:9090)",
    )
    parser.add_argument(
        "--dashboard-title",
        default="Service Dashboard",
        help="Dashboard title (default: Service Dashboard)",
    )
    parser.add_argument(
        "--dashboard-uid",
        default="service-dashboard",
        help="Dashboard UID for idempotent updates (default: service-dashboard)",
    )
    parser.add_argument(
        "--datasource-name",
        default="Prometheus",
        help="Datasource name (default: Prometheus)",
    )
    parser.add_argument(
        "--datasource-uid",
        default="prometheus",
        help="Datasource UID (default: prometheus)",
    )
    return parser.parse_args()


class GrafanaAPI:
    def __init__(self, base_url: str, api_key: str):
        self.base_url = base_url.rstrip("/")
        self.api_key = api_key
        self.headers = {
            "Authorization": f"Bearer {api_key}",
            "Content-Type": "application/json",
            "Accept": "application/json",
        }

    def _request(self, method: str, path: str, data: dict | None = None) -> dict:
        url = f"{self.base_url}{path}"
        body = json.dumps(data).encode("utf-8") if data else None
        req = urllib.request.Request(url, data=body, headers=self.headers, method=method)
        try:
            with urllib.request.urlopen(req) as resp:
                resp_data = resp.read().decode("utf-8")
                return json.loads(resp_data) if resp_data else {}
        except urllib.error.HTTPError as e:
            err_body = e.read().decode("utf-8")
            raise RuntimeError(f"Grafana API {method} {path} failed: {e.code} {e.reason} - {err_body}")
        except urllib.error.URLError as e:
            raise RuntimeError(f"Cannot reach Grafana at {self.base_url}: {e.reason}")

    def get_datasource_by_uid(self, uid: str) -> dict | None:
        try:
            return self._request("GET", f"/api/datasources/uid/{uid}")
        except RuntimeError as e:
            if "404" in str(e):
                return None
            raise

    def create_or_update_datasource(self, payload: dict) -> dict:
        existing = self.get_datasource_by_uid(payload["uid"])
        if existing:
            payload["id"] = existing["id"]
            return self._request("PUT", f"/api/datasources/{existing['id']}", payload)
        return self._request("POST", "/api/datasources", payload)

    def get_dashboard(self, uid: str) -> dict | None:
        try:
            return self._request("GET", f"/api/dashboards/uid/{uid}")
        except RuntimeError as e:
            if "404" in str(e):
                return None
            raise

    def create_or_update_dashboard(self, payload: dict) -> dict:
        existing = self.get_dashboard(payload["dashboard"]["uid"])
        if existing:
            payload["dashboard"]["version"] = existing["dashboard"]["version"] + 1
            payload["overwrite"] = True
        else:
            payload["overwrite"] = False
        return self._request("POST", "/api/dashboards/db", payload)


def build_datasource_payload(name: str, uid: str, url: str) -> dict:
    return {
        "name": name,
        "uid": uid,
        "type": "prometheus",
        "url": url,
        "access": "proxy",
        "isDefault": True,
        "jsonData": {
            "timeInterval": "15s",
            "queryTimeout": "60s",
        },
    }


def build_dashboard_payload(title: str, uid: str, datasource_uid: str) -> dict:
    return {
        "dashboard": {
            "uid": uid,
            "title": title,
            "timezone": "utc",
            "refresh": "30s",
            "time": {
                "from": "now-1h",
                "to": "now",
            },
            "panels": [
                {
                    "id": 1,
                    "title": "Request Rate (req/s)",
                    "type": "timeseries",
                    "gridPos": {"x": 0, "y": 0, "w": 12, "h": 8},
                    "datasource": {"type": "prometheus", "uid": datasource_uid},
                    "targets": [
                        {
                            "expr": 'sum(rate(http_requests_total[5m])) by (service, method)',
                            "legendFormat": "{{service}} {{method}}",
                            "refId": "A",
                        }
                    ],
                    "fieldConfig": {
                        "defaults": {
                            "unit": "reqps",
                            "custom": {"lineWidth": 2, "fillOpacity": 10},
                        }
                    },
                },
                {
                    "id": 2,
                    "title": "Error Rate (errors/s)",
                    "type": "timeseries",
                    "gridPos": {"x": 12, "y": 0, "w": 12, "h": 8},
                    "datasource": {"type": "prometheus", "uid": datasource_uid},
                    "targets": [
                        {
                            "expr": 'sum(rate(http_requests_total{status=~"5.."}[5m])) by (service)',
                            "legendFormat": "{{service}} 5xx",
                            "refId": "A",
                        }
                    ],
                    "fieldConfig": {
                        "defaults": {
                            "unit": "reqps",
                            "custom": {"lineWidth": 2, "fillOpacity": 10},
                            "thresholds": {
                                "mode": "absolute",
                                "steps": [
                                    {"color": "green", "value": None},
                                    {"color": "red", "value": 1},
                                ],
                            },
                        }
                    },
                },
                {
                    "id": 3,
                    "title": "Latency p95 (seconds)",
                    "type": "timeseries",
                    "gridPos": {"x": 0, "y": 8, "w": 12, "h": 8},
                    "datasource": {"type": "prometheus", "uid": datasource_uid},
                    "targets": [
                        {
                            "expr": 'histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (service, le))',
                            "legendFormat": "{{service}}",
                            "refId": "A",
                        }
                    ],
                    "fieldConfig": {
                        "defaults": {
                            "unit": "s",
                            "custom": {"lineWidth": 2, "fillOpacity": 10},
                            "thresholds": {
                                "mode": "absolute",
                                "steps": [
                                    {"color": "green", "value": None},
                                    {"color": "orange", "value": 0.5},
                                    {"color": "red", "value": 1},
                                ],
                            },
                        }
                    },
                },
                {
                    "id": 4,
                    "title": "Active Requests",
                    "type": "timeseries",
                    "gridPos": {"x": 12, "y": 8, "w": 12, "h": 8},
                    "datasource": {"type": "prometheus", "uid": datasource_uid},
                    "targets": [
                        {
                            "expr": "sum(http_requests_in_flight) by (service)",
                            "legendFormat": "{{service}}",
                            "refId": "A",
                        }
                    ],
                    "fieldConfig": {
                        "defaults": {
                            "unit": "short",
                            "custom": {"lineWidth": 2, "fillOpacity": 20},
                        }
                    },
                },
            ],
            "templating": {
                "list": [
                    {
                        "name": "service",
                        "type": "query",
                        "datasource": {"type": "prometheus", "uid": datasource_uid},
                        "query": "label_values(http_requests_total, service)",
                        "refresh": 1,
                        "includeAll": True,
                        "allValue": ".*",
                        "multi": True,
                    }
                ]
            },
        },
        "folderUid": "",
        "message": "Created/updated via HTTP API script",
        "overwrite": False,
    }


def main() -> int:
    args = parse_args()

    if not args.api_key:
        print("Error: GRAFANA_API_KEY not set", file=sys.stderr)
        return 1

    api = GrafanaAPI(args.grafana_url, args.api_key)

    print(f"Creating/updating datasource '{args.datasource_name}'...")
    ds_payload = build_datasource_payload(args.datasource_name, args.datasource_uid, args.prometheus_url)
    ds_result = api.create_or_update_datasource(ds_payload)
    print(f"Datasource ready: {ds_result.get('name')} (UID: {ds_result.get('uid')})")

    print(f"Creating/updating dashboard '{args.dashboard_title}'...")
    db_payload = build_dashboard_payload(args.dashboard_title, args.dashboard_uid, args.datasource_uid)
    db_result = api.create_or_update_dashboard(db_payload)
    print(f"Dashboard ready: {db_result.get('title')} (UID: {db_result.get('uid')}, URL: {args.grafana_url}/d/{db_result.get('uid')})")

    return 0


if __name__ == "__main__":
    sys.exit(main())
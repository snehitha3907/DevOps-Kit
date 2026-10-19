#!/usr/bin/env python3
# last_verified: 2026-10-19 · Grafana Cloud (n/a)
#
# Purpose: Create a Grafana Cloud stack via the API and send a first metric
# sample using the Graphite/OTLP endpoint. This is my first script that talks
# to the Grafana Cloud API directly instead of using the agent.
#
# When to use: you want to programmatically spin up a stack (or just exercise
# the API against an existing stack) and push a sample metric to verify the
# pipeline end-to-end. Good for learning the API surface or wiring into CI.
#
# Prerequisites: a Grafana Cloud account with API token (generate at
# grafana.com/orgs/<your-org>/api-keys). The token needs "metrics:write"
# scope at minimum. Stack creation also needs "stacks:write" if you don't
# already have a stack ID.
#
# Usage:
#   export GRAFANA_CLOUD_API_TOKEN="glc_..."
#   export GRAFANA_CLOUD_ORG="my-org"
#   python 2026-10-19-create-stack-and-send-metrics.py \
#     --stack-slug my-test-stack \
#     --metric-name "test.metric" \
#     --metric-value 42

import argparse
import json
import os
import sys
import time
import urllib.error
import urllib.parse
import urllib.request


GRAFANA_CLOUD_API_BASE = "https://api.grafana.com"
GRAFANA_CLOUD_METRICS_BASE = "https://prometheus-prod-{region}-backend.grafana.net"


def api_request(method, path, token, org, body=None, headers=None):
    """Make a request to the Grafana Cloud API."""
    url = f"{GRAFANA_CLOUD_API_BASE}{path}"
    req_headers = {
        "Authorization": f"Bearer {token}",
        "Content-Type": "application/json",
        "X-Grafana-Org": org,
    }
    if headers:
        req_headers.update(headers)

    data = json.dumps(body).encode() if body else None
    req = urllib.request.Request(url, data=data, headers=req_headers, method=method)

    try:
        with urllib.request.urlopen(req) as resp:
            return resp.status, json.loads(resp.read().decode())
    except urllib.error.HTTPError as e:
        err_body = e.read().decode() if e.fp else ""
        raise RuntimeError(f"API {method} {path} failed: {e.code} {e.reason} - {err_body}")


def create_stack(token, org, slug, region="us"):
    """Create a new Grafana Cloud stack."""
    print(f"Creating stack '{slug}' in region '{region}'...")
    body = {
        "slug": slug,
        "region": region,
        "plan": "free",
    }
    status, resp = api_request("POST", "/v1/stacks", token, org, body=body)
    if status in (200, 201):
        stack_id = resp.get("id")
        print(f"Stack created: id={stack_id}, slug={slug}")
        return stack_id
    elif status == 409:
        # Stack might already exist - try to get it
        print(f"Stack '{slug}' already exists, fetching...")
        return get_stack_id(token, org, slug)
    else:
        raise RuntimeError(f"Failed to create stack: {resp}")


def get_stack_id(token, org, slug):
    """Get stack ID by slug."""
    status, resp = api_request("GET", f"/v1/stacks/{slug}", token, org)
    if status == 200:
        return resp.get("id")
    raise RuntimeError(f"Stack '{slug}' not found")


def wait_for_stack_ready(token, org, stack_id, timeout=120):
    """Poll stack status until ready."""
    print("Waiting for stack to become ready...")
    start = time.time()
    while time.time() - start < timeout:
        status, resp = api_request("GET", f"/v1/stacks/{stack_id}", token, org)
        if status == 200:
            state = resp.get("status")
            print(f"  Stack status: {state}")
            if state == "running":
                return resp
            if state in ("error", "failed"):
                raise RuntimeError(f"Stack entered error state: {resp}")
        time.sleep(5)
    raise TimeoutError("Stack did not become ready in time")


def get_metrics_endpoint(stack_info):
    """Extract the metrics push endpoint from stack info."""
    # The stack info includes endpoints; we need the Prometheus remote-write URL
    endpoints = stack_info.get("endpoints", {})
    prometheus = endpoints.get("prometheus", {})
    return prometheus.get("url")


def send_metric_via_otlp(token, org, stack_id, metric_name, metric_value, region="us"):
    """Send a metric sample via the OTLP HTTP endpoint."""
    # Grafana Cloud OTLP HTTP endpoint format:
    # https://prometheus-prod-{region}-backend.grafana.net/api/prom/push
    # with headers: Authorization: Bearer <token>, X-Scope-OrgID: <stack_id>
    endpoint = f"https://prometheus-prod-{region}-backend.grafana.net/api/prom/push"

    # Simple Prometheus text format for a single sample
    timestamp_ms = int(time.time() * 1000)
    payload = f"{metric_name} {metric_value} {timestamp_ms}\n"

    headers = {
        "Authorization": f"Bearer {token}",
        "X-Scope-OrgID": str(stack_id),
        "Content-Type": "text/plain",
    }

    print(f"Sending metric to {endpoint}...")
    req = urllib.request.Request(endpoint, data=payload.encode(), headers=headers, method="POST")

    try:
        with urllib.request.urlopen(req) as resp:
            print(f"Push response: {resp.status}")
            return resp.status == 200
    except urllib.error.HTTPError as e:
        err_body = e.read().decode() if e.fp else ""
        print(f"Push failed: {e.code} {e.reason} - {err_body}")
        return False


def main():
    parser = argparse.ArgumentParser(
        description="Create Grafana Cloud stack and send first metric via API"
    )
    parser.add_argument("--stack-slug", required=True, help="Stack slug (unique name)")
    parser.add_argument("--region", default="us", choices=["us", "eu"], help="Stack region")
    parser.add_argument("--metric-name", default="test.first_metric", help="Metric name to send")
    parser.add_argument("--metric-value", type=float, default=1.0, help="Metric value to send")
    parser.add_argument("--skip-create", action="store_true", help="Use existing stack, don't create")
    args = parser.parse_args()

    token = os.environ.get("GRAFANA_CLOUD_API_TOKEN")
    org = os.environ.get("GRAFANA_CLOUD_ORG")

    if not token or not org:
        print("ERROR: Set GRAFANA_CLOUD_API_TOKEN and GRAFANA_CLOUD_ORG env vars", file=sys.stderr)
        sys.exit(1)

    try:
        if args.skip_create:
            stack_id = get_stack_id(token, org, args.stack_slug)
            print(f"Using existing stack: {stack_id}")
            stack_info = {"id": stack_id, "endpoints": {"prometheus": {"url": ""}}}
        else:
            stack_id = create_stack(token, org, args.stack_slug, args.region)
            stack_info = wait_for_stack_ready(token, org, stack_id)

        endpoint = get_metrics_endpoint(stack_info)
        if endpoint:
            print(f"Prometheus endpoint: {endpoint}")

        success = send_metric_via_otlp(
            token, org, stack_id, args.metric_name, args.metric_value, args.region
        )

        if success:
            print(f"\nSuccess! Metric '{args.metric_name}' sent to stack '{args.stack_slug}'")
            print("Check Explore in your Grafana Cloud instance to see the data.")
        else:
            print("\nMetric push failed. Check token scopes and stack status.")
            sys.exit(1)

    except Exception as e:
        print(f"\nError: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
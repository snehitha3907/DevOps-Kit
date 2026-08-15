# last_verified: 2026-08-15 · GitHub REST API
"""
I wanted to trigger a GitHub Actions workflow_dispatch event from a
script and then poll the API until the run finishes. The REST API is
the most portable surface — it works from CI, from my laptop, or from
anywhere with a GITHUB_TOKEN.

Usage:
    python 2026-08-15-trigger-workflow-dispatch-poll-status.py owner/repo workflow-name [branch]
"""
import json
import sys
import time
import urllib.error
import urllib.request


OWNER_REPO = sys.argv[1] if len(sys.argv) > 1 else "owner/repo"
WORKFLOW = sys.argv[2] if len(sys.argv) > 2 else "ci.yml"
REF = sys.argv[3] if len(sys.argv) > 3 else "main"
TOKEN = "YOUR_GITHUB_TOKEN_HERE"

BASE_URL = (
    f"https://api.github.com/repos/{OWNER_REPO}"
    f"/actions/workflows/{WORKFLOW}/runs"
)


def api(url, data=None, method=None):
    req = urllib.request.Request(url, method=method)
    req.add_header("Accept", "application/vnd.github+json")
    req.add_header("Authorization", f"Bearer {TOKEN}")
    req.add_header("User-Agent", "python-snippet")
    if data is not None:
        req.add_header("Content-Type", "application/json")
        return urllib.request.urlopen(req, data=json.dumps(data).encode())
    return urllib.request.urlopen(req)


def trigger():
    url = (
        f"https://api.github.com/repos/{OWNER_REPO}"
        f"/actions/workflows/{WORKFLOW}/dispatches"
    )
    api(url, {"ref": REF}, "POST")
    print(f"Triggered {WORKFLOW} on {REF}")


def poll():
    while True:
        try:
            resp = api(BASE_URL)
        except urllib.error.HTTPError as exc:
            print(f"API error {exc.code}: {exc.reason}", file=sys.stderr)
            sys.exit(1)
        runs = json.loads(resp.read()).get("workflow_runs", [])
        if not runs:
            print("No runs found yet — waiting...")
            time.sleep(5)
            continue
        run = runs[0]
        print(f"Run {run['id']}: {run['status']} / {run.get('conclusion')}")
        if run["status"] == "completed":
            return run["html_url"]
        time.sleep(10)


if __name__ == "__main__":
    trigger()
    print("Polling...")
    print(poll())

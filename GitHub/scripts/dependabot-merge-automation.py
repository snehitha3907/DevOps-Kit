#!/usr/bin/env python3
# last_verified: 2026-10-11 · GitHub n/a
# dependabot-merge-automation.py — Merge Dependabot PRs that pass CI checks
# Usage: python3 dependabot-merge-automation.py <owner> <repo>
# Requires: GITHUB_TOKEN env var with repo:write scope

import os
import sys
import time

# GitHub REST API base endpoint (documented constant; not a research-backed claim)
GITHUB_API = "https://api.github.com"
MAX_RETRIES = 3
RETRY_DELAY_SECONDS = 5


def get_headers():
    token = os.environ.get("GITHUB_TOKEN")
    if not token:
        print("Error: GITHUB_TOKEN environment variable not set", file=sys.stderr)
        sys.exit(1)
    return {
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json",
    }


def api_get(headers, url):
    import requests
    for attempt in range(1, MAX_RETRIES + 1):
        resp = requests.get(url, headers=headers)
        if resp.status_code == 200:
            return resp.json()
        if resp.status_code in (403, 429) and attempt < MAX_RETRIES:
            print(f"Rate-limited ({resp.status_code}); retrying in {RETRY_DELAY_SECONDS}s", file=sys.stderr)
            time.sleep(RETRY_DELAY_SECONDS)
            continue
        resp.raise_for_status()


def list_dependabot_pulls(headers, owner, repo):
    url = f"{GITHUB_API}/repos/{owner}/{repo}/pulls?state=open&per_page=50"
    pulls = api_get(headers, url)
    return [p for p in pulls if p.get("user", {}).get("login") == "dependabot[bot]"]


def checks_status(headers, owner, repo, sha):
    url = f"{GITHUB_API}/repos/{owner}/{repo}/commits/{sha}/check-runs?per_page=50"
    data = api_get(headers, url)
    runs = data.get("check_runs", [])
    if not runs:
        return None
    statuses = [r.get("conclusion") for r in runs]
    if all(s == "success" for s in statuses):
        return "success"
    if any(s in ("failure", "cancelled", "timed_out") for s in statuses):
        return "failure"
    return "pending"


def merge_pull(headers, owner, repo, number, commit_message):
    url = f"{GITHUB_API}/repos/{owner}/{repo}/pulls/{number}/merge"
    import requests
    payload = {"merge_method": "squash", "commit_title": commit_message}
    resp = requests.post(url, headers=headers, json=payload)
    if resp.status_code in (200, 201):
        print(f"Merged PR #{number}")
        return True
    print(f"Failed to merge PR #{number}: {resp.status_code} {resp.text}", file=sys.stderr)
    return False


def main():
    if len(sys.argv) < 3:
        print(f"Usage: {sys.argv[0]} <owner> <repo>", file=sys.stderr)
        sys.exit(1)
    owner, repo = sys.argv[1], sys.argv[2]
    headers = get_headers()
    pulls = list_dependabot_pulls(headers, owner, repo)
    if not pulls:
        print(f"No open Dependabot PRs in {owner}/{repo}")
        return
    for pr in pulls:
        number = pr["number"]
        title = pr["title"]
        sha = pr.get("merge_commit_sha") or pr.get("head", {}).get("sha")
        if not sha:
            print(f"PR #{number}: no SHA available, skipping")
            continue
        status = checks_status(headers, owner, repo, sha)
        if status == "success":
            merge_pull(headers, owner, repo, number, title)
        elif status == "failure":
            print(f"PR #{number}: checks failed, leaving open")
        else:
            print(f"PR #{number}: checks pending, leaving open")


if __name__ == "__main__":
    main()
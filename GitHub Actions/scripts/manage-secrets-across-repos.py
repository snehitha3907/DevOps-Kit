#!/usr/bin/env python3
# last_verified: 2026-10-03 · GitHub Actions n/a

"""
manage-secrets-across-repos.py — manage GitHub Actions secrets across multiple repositories.

Purpose
-------
Bulk create, update, list, or delete repository-level Actions secrets from a single
invocation. Useful when the same secret (e.g. a cloud provider credential or a
signing key) must be present in dozens of repos and you want a repeatable, auditable
way to keep them in sync.

When to use
-----------
- You maintain a fleet of repositories that share a common secret.
- You rotate credentials and need to push the new value everywhere at once.
- You want to audit which repositories currently have a given secret configured.

Prerequisites
-------------
- Python 3.9+
- `requests` and `PyNaCl` (`pip install requests pynacl`)
- A GitHub token with `repo` scope (for private repos) or `public_repo` (for public)
  and `actions:write` permission on each target repository.
- The token must be able to read the repository's public key (`GET
  /repos/{owner}/{repo}/actions/secrets/public-key`).

Steps
-----
1. Prepare a CSV or JSON file mapping repository names to secret values, or
   pass a single value to apply to all repositories.
2. Run the script with the desired subcommand (`sync`, `list`, `delete`).
3. Verify the output — each repository reports success or a specific error.

Verify
------
- After `sync`, spot-check a few repositories in the GitHub UI
  (Settings → Secrets and variables → Actions) to confirm the secret exists.
- After `list`, confirm the secret names match expectations.
- After `delete`, confirm the secret is gone from the UI.

Common errors
-------------
- **401 Unauthorized** — token lacks `actions:write` or has expired.
- **404 Not Found** — repository name is wrong or token cannot access it.
- **Public key fetch failed** — the repository has no Actions enabled, or the
  token lacks permission to read the public key.
- **Encryption error** — PyNaCl not installed or the public key is malformed.

Rollback
--------
Re-run `sync` with the previous secret values from a backup CSV/JSON, or
manually restore each secret in the GitHub UI.

References
----------
- GitHub Actions secrets API: https://docs.github.com/en/rest/actions/secrets
- libsodium sealed box encryption (used by GitHub): https://libsodium.gitbook.io/doc/public-key_cryptography/sealed_boxes
"""

import argparse
import base64
import csv
import json
import os
import sys
from pathlib import Path
from typing import Dict, List, Optional, Tuple

import requests
from nacl import encoding, public


API_BASE = "https://api.github.com"
DEFAULT_TIMEOUT = 30


class GitHubSecretsManager:
    """Manage GitHub Actions secrets across multiple repositories."""

    def __init__(self, token: str, owner: str, timeout: int = DEFAULT_TIMEOUT):
        self.token = token
        self.owner = owner
        self.timeout = timeout
        self.session = requests.Session()
        self.session.headers.update(
            {
                "Authorization": f"Bearer {token}",
                "Accept": "application/vnd.github+json",
                "X-GitHub-Api-Version": "2022-11-28",
            }
        )

    def _get_public_key(self, repo: str) -> Tuple[str, str]:
        """Fetch the repository's Actions secrets public key.

        Returns:
            (key_id, base64_encoded_public_key)
        """
        url = f"{API_BASE}/repos/{self.owner}/{repo}/actions/secrets/public-key"
        resp = self.session.get(url, timeout=self.timeout)
        if resp.status_code == 404:
            raise RuntimeError(f"Repository '{self.owner}/{repo}' not found or Actions not enabled")
        resp.raise_for_status()
        data = resp.json()
        return data["key_id"], data["key"]

    @staticmethod
    def _encrypt_secret(public_key_b64: str, secret_value: str) -> str:
        """Encrypt a secret value using the repository's public key."""
        public_key = public.PublicKey(public_key_b64, encoding.Base64Encoder())
        sealed_box = public.SealedBox(public_key)
        encrypted = sealed_box.encrypt(secret_value.encode("utf-8"))
        return base64.b64encode(encrypted).decode("utf-8")

    def create_or_update_secret(
        self, repo: str, secret_name: str, secret_value: str
    ) -> bool:
        """Create or update a single secret in a repository.

        Returns True on success, False on failure (error printed to stderr).
        """
        try:
            key_id, public_key_b64 = self._get_public_key(repo)
            encrypted_value = self._encrypt_secret(public_key_b64, secret_value)

            url = f"{API_BASE}/repos/{self.owner}/{repo}/actions/secrets/{secret_name}"
            payload = {"encrypted_value": encrypted_value, "key_id": key_id}
            resp = self.session.put(url, json=payload, timeout=self.timeout)
            resp.raise_for_status()
            return True
        except Exception as e:
            print(f"  ✗ {repo}: {e}", file=sys.stderr)
            return False

    def delete_secret(self, repo: str, secret_name: str) -> bool:
        """Delete a secret from a repository.

        Returns True on success (including already absent), False on error.
        """
        try:
            url = f"{API_BASE}/repos/{self.owner}/{repo}/actions/secrets/{secret_name}"
            resp = self.session.delete(url, timeout=self.timeout)
            if resp.status_code == 404:
                print(f"  - {repo}: secret '{secret_name}' not present")
                return True
            resp.raise_for_status()
            return True
        except Exception as e:
            print(f"  ✗ {repo}: {e}", file=sys.stderr)
            return False

    def list_secrets(self, repo: str) -> List[str]:
        """List secret names in a repository (values are never returned by the API)."""
        url = f"{API_BASE}/repos/{self.owner}/{repo}/actions/secrets"
        secret_names: List[str] = []
        page = 1
        while True:
            resp = self.session.get(
                url, params={"page": page, "per_page": 100}, timeout=self.timeout
            )
            resp.raise_for_status()
            data = resp.json()
            secret_names.extend(s["name"] for s in data.get("secrets", []))
            if len(data.get("secrets", [])) < 100:
                break
            page += 1
        return secret_names


def parse_repo_list(arg: str) -> List[str]:
    """Parse a comma-separated list or a file with one repo per line."""
    path = Path(arg)
    if path.exists():
        return [line.strip() for line in path.read_text().splitlines() if line.strip()]
    return [r.strip() for r in arg.split(",") if r.strip()]


def parse_secret_map(arg: str) -> Dict[str, str]:
    """Parse secret mappings from JSON file, CSV file, or key=value pairs."""
    path = Path(arg)
    if path.exists():
        if path.suffix.lower() == ".json":
            return json.loads(path.read_text())
        if path.suffix.lower() == ".csv":
            with path.open() as f:
                reader = csv.DictReader(f)
                return {row["repository"]: row["value"] for row in reader}
    # Fallback: comma-separated key=value pairs
    result = {}
    for pair in arg.split(","):
        if "=" in pair:
            k, v = pair.split("=", 1)
            result[k.strip()] = v.strip()
    return result


def load_repos_from_csv(path: Path) -> List[str]:
    """Load repository names from a CSV file with a 'repository' column."""
    with path.open() as f:
        reader = csv.DictReader(f)
        return [row["repository"].strip() for row in reader if row.get("repository")]


def cmd_sync(args: argparse.Namespace, manager: GitHubSecretsManager) -> int:
    """Sync secrets across repositories."""
    repos = parse_repo_list(args.repos)
    secret_map = parse_secret_map(args.secrets)

    if not repos:
        print("No repositories specified", file=sys.stderr)
        return 1

    if not secret_map:
        print("No secrets specified", file=sys.stderr)
        return 1

    # If secret_map has one entry and no repository keys, apply to all repos
    if len(secret_map) == 1 and next(iter(secret_map)) not in repos:
        single_value = next(iter(secret_map.values()))
        secret_map = {repo: single_value for repo in repos}

    secret_names = list({name for name in secret_map.keys()})
    print(f"Syncing {len(secret_names)} secret(s) to {len(repos)} repository(ies)...")

    success_count = 0
    for repo in repos:
        print(f"\n{repo}:")
        for secret_name in secret_names:
            value = secret_map.get(repo) or secret_map.get(secret_name)
            if value is None:
                print(f"  ⊘ {secret_name}: no value provided for this repo")
                continue
            if manager.create_or_update_secret(repo, secret_name, value):
                print(f"  ✓ {secret_name}")
                success_count += 1

    print(f"\nCompleted: {success_count} secret operations succeeded")
    return 0 if success_count > 0 else 1


def cmd_list(args: argparse.Namespace, manager: GitHubSecretsManager) -> int:
    """List secrets in each repository."""
    repos = parse_repo_list(args.repos)

    if not repos:
        print("No repositories specified", file=sys.stderr)
        return 1

    print(f"Listing secrets for {len(repos)} repository(ies)...\n")
    for repo in repos:
        try:
            secrets = manager.list_secrets(repo)
            if secrets:
                print(f"{repo}: {', '.join(sorted(secrets))}")
            else:
                print(f"{repo}: (no secrets)")
        except Exception as e:
            print(f"{repo}: ERROR - {e}", file=sys.stderr)
    return 0


def cmd_delete(args: argparse.Namespace, manager: GitHubSecretsManager) -> int:
    """Delete a secret from repositories."""
    repos = parse_repo_list(args.repos)

    if not repos:
        print("No repositories specified", file=sys.stderr)
        return 1

    if not args.secret_name:
        print("Secret name required for delete", file=sys.stderr)
        return 1

    print(f"Deleting secret '{args.secret_name}' from {len(repos)} repository(ies)...")
    success_count = 0
    for repo in repos:
        if manager.delete_secret(repo, args.secret_name):
            print(f"  ✓ {repo}")
            success_count += 1

    print(f"\nCompleted: {success_count} deletion(s) succeeded")
    return 0 if success_count > 0 else 1


def main() -> int:
    parser = argparse.ArgumentParser(
        description="Manage GitHub Actions secrets across multiple repositories",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # Sync a single secret to multiple repos from a CSV (columns: repository,value)
  %(prog)s sync --repos repos.txt --secrets secrets.csv --token $GH_TOKEN --owner myorg

  # Apply the same secret value to all listed repos
  %(prog)s sync --repos repo1,repo2,repo3 --secrets AWS_KEY=abc123 --token $GH_TOKEN --owner myorg

  # List all secrets in each repo
  %(prog)s list --repos repo1,repo2,repo3 --token $GH_TOKEN --owner myorg

  # Delete a secret from multiple repos
  %(prog)s delete --repos repo1,repo2,repo3 --secret-name OLD_KEY --token $GH_TOKEN --owner myorg
""",
    )
    parser.add_argument(
        "--token",
        required=True,
        help="GitHub token with actions:write permission (or GITHUB_TOKEN env var)",
    )
    parser.add_argument(
        "--owner", required=True, help="GitHub organization or user owning the repositories"
    )
    parser.add_argument(
        "--timeout", type=int, default=DEFAULT_TIMEOUT, help="Request timeout in seconds"
    )

    subparsers = parser.add_subparsers(dest="command", required=True)

    # sync subcommand
    sync_parser = subparsers.add_parser("sync", help="Create or update secrets")
    sync_parser.add_argument(
        "--repos", required=True, help="Comma-separated repos, or path to file (one per line or CSV with 'repository' column)"
    )
    sync_parser.add_argument(
        "--secrets",
        required=True,
        help="Secret mappings: JSON file, CSV file (repository,value), or comma-separated key=value pairs. If a single value is given, it is applied to all repos.",
    )

    # list subcommand
    list_parser = subparsers.add_parser("list", help="List secret names in each repository")
    list_parser.add_argument(
        "--repos", required=True, help="Comma-separated repos, or path to file (one per line or CSV with 'repository' column)"
    )

    # delete subcommand
    delete_parser = subparsers.add_parser("delete", help="Delete a secret from repositories")
    delete_parser.add_argument(
        "--repos", required=True, help="Comma-separated repos, or path to file (one per line or CSV with 'repository' column)"
    )
    delete_parser.add_argument("--secret-name", required=True, help="Name of the secret to delete")

    args = parser.parse_args()

    token = args.token or os.environ.get("GITHUB_TOKEN")
    if not token:
        print("Error: GitHub token required (--token or GITHUB_TOKEN env var)", file=sys.stderr)
        return 1

    manager = GitHubSecretsManager(token, args.owner, args.timeout)

    if args.command == "sync":
        return cmd_sync(args, manager)
    elif args.command == "list":
        return cmd_list(args, manager)
    elif args.command == "delete":
        return cmd_delete(args, manager)
    return 1


if __name__ == "__main__":
    sys.exit(main())
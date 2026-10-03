#!/usr/bin/env python3
# last_verified: 2026-10-03 · GitHub Actions n/a

"""
manage-secrets-across-repos.py — bulk management of repository-level Actions secrets.

Purpose
-------
Create, update, list, or delete repository-level GitHub Actions secrets from a
single invocation, across an explicit set of repositories. The target fleet is
always named on the command line, and every write is planned and printed before
anything is sent, because a mis-typed repository name in a bulk write is not
something the API will warn you about.

When to use
-----------
- A credential has to be present in many repositories and the fleet is known
  ahead of time.
- A credential is being rotated and the new value is distributed from one file.
- The set of repositories holding a given secret is being audited.

Prerequisites
-------------
- Python 3.9+
- The `requests` and `PyNaCl` packages (`pip install requests pynacl`). PyNaCl
  supplies the sealed-box encryption the API expects; a value is never uploaded
  in the clear.
- A token that can read each repository's secrets public key and write its
  secrets. The public-key read is a separate permission from the write, and a
  token missing the read fails at the first request of every repository.
- Either `--token` or the `GITHUB_TOKEN` environment variable.
- Optional: set `GITHUB_API_VERSION` to pin the REST API version header. Left
  unset, the header is omitted and the server's current default applies.

Inputs
------
`--repos` accepts one of three forms, and the suffix decides how a file is read,
because a one-repo-per-line list and a CSV are both plain text but need different
parsers:

  - `--repos repo1,repo2,repo3` — a comma-separated list.
  - `--repos repos.txt` — a text file with one repository per line.
  - `--repos repos.csv` — a CSV with a `repository` column.

`--secrets` likewise:

  - `--secrets AWS_KEY=abc123` — one or more comma-separated `NAME=VALUE` pairs,
    each applied to every repository in `--repos`. A value that itself contains a
    comma cannot be expressed this way; use a file.
  - `--secrets secrets.csv` — a CSV with `repository` and `value` columns, and an
    optional `name` column. A blank `repository` means "every repo in `--repos`".
  - `--secrets secrets.json` — either a list of `{"repository", "name", "value"}`
    objects, or a flat `{"NAME": "value"}` object applied to every repository.

`--secret-name` supplies the secret name for file sources that have no `name`
column, which is the usual shape for a "one secret, many repos" rotation.

Steps
-----
1. Build the repository list and the secret source.
2. Run the subcommand: `sync`, `list`, or `delete`.
3. Read the printed plan, then confirm each repository's result.

Verify
------
- After `sync`, the plan line and the per-repository result lines should account
  for every planned write; a `✗` line names the repository and the failure.
- After `list`, compare the names against the secret names in the source file.
- After `delete`, re-run `list` and confirm the name is gone.

Common errors
-------------
- **`--secrets: 'foo' is not NAME=VALUE`** — an inline pair is missing its `=`.
- **`missing required column(s) value`** — a secrets CSV lacks a required column;
  the message lists the columns actually found.
- **`secret source names repository 'repoC', which is not in --repos`** — the
  source file references a repository outside the target fleet. This is a typo
  guard, not a warning; fix the name or add the repository.
- **401** — the token is expired or lacks the write permission.
- **404 on the public-key read** — the repository name is wrong, the token cannot
  see it, or Actions is not enabled for it.
- **`libsodium` / `nacl` import error** — PyNaCl is not installed.

Rollback
--------
Re-run `sync` from the previous values file to overwrite what was just written.
Deletes are not recoverable through this script; a deleted secret must be set
again from a value you still hold.

Exit codes
----------
0 all operations succeeded (or `--dry-run` printed a plan) · 1 at least one
operation failed · 2 the repository list or secret source could not be
interpreted, and nothing was sent.
"""

import argparse
import base64
import csv
import json
import os
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Optional, Sequence, Tuple

import requests
from nacl import encoding, public

API_BASE = "https://api.github.com"
DEFAULT_TIMEOUT = 30
PER_PAGE = 100
API_VERSION_ENV = "GITHUB_API_VERSION"
TOKEN_ENV = "GITHUB_TOKEN"

EXIT_OK = 0
EXIT_FAILED = 1
EXIT_USAGE = 2

SECRETS_COLUMNS = ("repository", "value")


class SpecError(Exception):
    """A repository list or secret source that cannot be turned into writes."""


@dataclass(frozen=True)
class SecretSpec:
    """One source row. An empty `repo` means every repository in --repos."""

    repo: str
    name: str
    value: str


class GitHubSecretsManager:
    """Thin wrapper over the repository-level Actions secrets endpoints."""

    def __init__(self, token: str, owner: str, timeout: int = DEFAULT_TIMEOUT):
        self.token = token
        self.owner = owner
        self.timeout = timeout
        self.session = requests.Session()
        headers = {
            "Authorization": f"Bearer {token}",
            "Accept": "application/vnd.github+json",
        }
        api_version = os.environ.get(API_VERSION_ENV)
        if api_version:
            headers["X-GitHub-Api-Version"] = api_version
        self.session.headers.update(headers)

    def _get_public_key(self, repo: str) -> Tuple[str, str]:
        """Return (key_id, base64 public key) for a repository."""
        url = f"{API_BASE}/repos/{self.owner}/{repo}/actions/secrets/public-key"
        resp = self.session.get(url, timeout=self.timeout)
        if resp.status_code == 404:
            raise RuntimeError(
                f"{repo}: not found, not visible to this token, or Actions is not enabled"
            )
        resp.raise_for_status()
        data = resp.json()
        return data["key_id"], data["key"]

    @staticmethod
    def _encrypt_secret(public_key_b64: str, secret_value: str) -> str:
        """Seal the value against the repository's public key."""
        public_key = public.PublicKey(public_key_b64, encoding.Base64Encoder())
        return base64.b64encode(
            public.SealedBox(public_key).encrypt(secret_value.encode("utf-8"))
        ).decode("utf-8")

    def create_or_update_secret(self, repo: str, secret_name: str, secret_value: str) -> bool:
        """Create or update one secret. Returns False and reports on stderr."""
        try:
            key_id, public_key_b64 = self._get_public_key(repo)
            url = f"{API_BASE}/repos/{self.owner}/{repo}/actions/secrets/{secret_name}"
            payload = {
                "encrypted_value": self._encrypt_secret(public_key_b64, secret_value),
                "key_id": key_id,
            }
            self.session.put(url, json=payload, timeout=self.timeout).raise_for_status()
            return True
        except Exception as exc:  # noqa: BLE001 - one repo must not abort the fleet
            print(f"  ✗ {repo}: {secret_name}: {exc}", file=sys.stderr)
            return False

    def delete_secret(self, repo: str, secret_name: str) -> bool:
        """Delete one secret. An absent secret counts as done."""
        try:
            url = f"{API_BASE}/repos/{self.owner}/{repo}/actions/secrets/{secret_name}"
            resp = self.session.delete(url, timeout=self.timeout)
            if resp.status_code == 404:
                print(f"  - {repo}: {secret_name}: not present")
                return True
            resp.raise_for_status()
            return True
        except Exception as exc:  # noqa: BLE001
            print(f"  ✗ {repo}: {secret_name}: {exc}", file=sys.stderr)
            return False

    def list_secrets(self, repo: str) -> List[str]:
        """Return the secret names configured in a repository, following pages.

        `total_count` decides when to stop when the response carries it; the
        per-page length is only the fallback, so a response without the count
        still terminates. An empty page always ends the loop, which keeps a
        `total_count` that disagrees with the payload from spinning forever.
        """
        url = f"{API_BASE}/repos/{self.owner}/{repo}/actions/secrets"
        names: List[str] = []
        page = 1
        while True:
            resp = self.session.get(
                url, params={"page": page, "per_page": PER_PAGE}, timeout=self.timeout
            )
            resp.raise_for_status()
            data = resp.json()
            batch = [entry["name"] for entry in data.get("secrets", [])]
            names.extend(batch)
            total = data.get("total_count")
            if not batch:
                break
            if isinstance(total, int):
                if len(names) >= total:
                    break
            elif len(batch) < PER_PAGE:
                break
            page += 1
        return names


def read_csv_rows(path: Path, required: Sequence[str]) -> List[Dict[str, str]]:
    """Read a CSV, failing with the header it found when a column is missing."""
    with path.open(newline="") as handle:
        reader = csv.DictReader(handle)
        if reader.fieldnames is None:
            raise SpecError(
                f"{path}: file is empty, expected a header row with: {', '.join(required)}"
            )
        header = [(name or "").strip() for name in reader.fieldnames]
        missing = [column for column in required if column not in header]
        if missing:
            raise SpecError(
                f"{path}: missing required column(s) {', '.join(missing)}; "
                f"found {', '.join(header) or '(none)'}"
            )
        return [
            {(key or "").strip(): (value or "").strip() for key, value in row.items()}
            for row in reader
        ]


def load_repos_from_csv(path: Path) -> List[str]:
    """Repository names from a CSV carrying a `repository` column."""
    rows = read_csv_rows(path, ["repository"])
    repos = [row["repository"] for row in rows if row["repository"]]
    if not repos:
        raise SpecError(f"{path}: no repository names in the 'repository' column")
    return repos


def parse_repo_list(arg: str) -> List[str]:
    """Resolve --repos from a CSV file, a line-per-repo file, or a comma list."""
    path = Path(arg)
    if path.is_file():
        if path.suffix.lower() == ".csv":
            return load_repos_from_csv(path)
        repos = [line.strip() for line in path.read_text().splitlines() if line.strip()]
        if not repos:
            raise SpecError(f"{path}: no repository names, one per line expected")
        return repos
    repos = [item.strip() for item in arg.split(",") if item.strip()]
    if not repos:
        raise SpecError("--repos resolved to an empty list")
    return repos


def _spec_from_row(row: Dict[str, str], default_name: str, where: str) -> SecretSpec:
    """Build one spec from a CSV/JSON row, naming it from the row or the flag."""
    name = row.get("name") or default_name
    if not name:
        raise SpecError(f"{where}: no secret name - add a 'name' column or pass --secret-name")
    if "value" not in row:
        raise SpecError(f"{where}: no 'value' entry")
    return SecretSpec(row.get("repository") or row.get("repo") or "", name, row["value"])


def _specs_from_pairs(arg: str) -> List[SecretSpec]:
    """Parse comma-separated NAME=VALUE pairs, each applied to every repository."""
    specs: List[SecretSpec] = []
    for pair in arg.split(","):
        if "=" not in pair:
            raise SpecError(f"--secrets: '{pair}' is not NAME=VALUE")
        name, value = pair.split("=", 1)
        if not name.strip():
            raise SpecError(f"--secrets: '{pair}' has an empty secret name")
        specs.append(SecretSpec("", name.strip(), value))
    return specs


def _specs_from_json(path: Path, default_name: str) -> List[SecretSpec]:
    """Parse a JSON object of NAME/value pairs or a JSON list of rows."""
    try:
        data = json.loads(path.read_text())
    except json.JSONDecodeError as exc:
        raise SpecError(f"{path}: invalid JSON ({exc})") from exc
    if isinstance(data, dict):
        return [SecretSpec("", str(name), str(value)) for name, value in data.items()]
    if not isinstance(data, list):
        raise SpecError(f"{path}: expected a NAME/value object or a list of rows")
    specs: List[SecretSpec] = []
    for index, row in enumerate(data, start=1):
        where = f"{path} entry {index}"
        if not isinstance(row, dict):
            raise SpecError(f"{where}: expected an object with repository/name/value keys")
        specs.append(_spec_from_row({str(k): str(v) for k, v in row.items()}, default_name, where))
    return specs


def _specs_from_csv(path: Path, default_name: str) -> List[SecretSpec]:
    """Parse a CSV with `repository` and `value` columns plus an optional `name`."""
    rows = read_csv_rows(path, SECRETS_COLUMNS)
    return [
        _spec_from_row(row, default_name, f"{path} line {number}")
        for number, row in enumerate(rows, start=2)
    ]


def load_secret_specs(arg: str, default_name: Optional[str]) -> List[SecretSpec]:
    """Resolve --secrets into source rows, before any repository is expanded."""
    path = Path(arg)
    if not path.is_file():
        if default_name:
            raise SpecError(
                "--secret-name applies to a --secrets file source; inline NAME=VALUE "
                "pairs carry their own names"
            )
        return _specs_from_pairs(arg)
    suffix = path.suffix.lower()
    if suffix == ".json":
        return _specs_from_json(path, default_name or "")
    if suffix == ".csv":
        return _specs_from_csv(path, default_name or "")
    raise SpecError(f"{path}: unsupported --secrets file type, use .csv or .json")


def expand(specs: Sequence[SecretSpec], repos: Sequence[str]) -> List[Tuple[str, str, str]]:
    """Turn source rows into concrete (repository, name, value) writes.

    A row with an explicit repository must name a member of --repos: the fleet
    named on the command line is the only place repositories come from, so a
    typo in the source cannot silently introduce a new target.
    """
    fleet = list(dict.fromkeys(repos))
    writes: Dict[Tuple[str, str], str] = {}
    for spec in specs:
        if spec.repo and spec.repo not in fleet:
            raise SpecError(
                f"secret source names repository '{spec.repo}', which is not in --repos "
                f"({', '.join(fleet)}) - add it or fix the spelling"
            )
        for repo in ([spec.repo] if spec.repo else fleet):
            key = (repo, spec.name)
            if key in writes and writes[key] != spec.value:
                raise SpecError(
                    f"conflicting values for '{spec.name}' in '{repo}' - the source "
                    "specifies it more than once"
                )
            writes[key] = spec.value
    return [(repo, name, value) for (repo, name), value in writes.items()]


def cmd_sync(args: argparse.Namespace, manager: GitHubSecretsManager) -> int:
    """Create or update secrets across the fleet."""
    try:
        repos = parse_repo_list(args.repos)
        specs = load_secret_specs(args.secrets, args.secret_name)
        writes = expand(specs, repos)
    except SpecError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return EXIT_USAGE
    if not writes:
        print("error: --secrets resolved to no writes", file=sys.stderr)
        return EXIT_USAGE

    targets = len({repo for repo, _, _ in writes})
    print(f"Plan: {len(writes)} write(s) across {targets} repository(ies)")
    for repo, name, _ in writes:
        print(f"  {repo}  {name}")
    if args.dry_run:
        print("\n--dry-run: nothing sent.")
        return EXIT_OK

    succeeded = sum(
        1 for repo, name, value in writes if manager.create_or_update_secret(repo, name, value)
    )
    print(f"\nCompleted: {succeeded}/{len(writes)} write(s) succeeded")
    return EXIT_OK if succeeded == len(writes) else EXIT_FAILED


def cmd_list(args: argparse.Namespace, manager: GitHubSecretsManager) -> int:
    """List secret names in each repository."""
    try:
        repos = parse_repo_list(args.repos)
    except SpecError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return EXIT_USAGE

    print(f"Listing secrets for {len(repos)} repository(ies)\n")
    failed = 0
    for repo in repos:
        try:
            names = manager.list_secrets(repo)
        except Exception as exc:  # noqa: BLE001 - one repo must not abort the fleet
            print(f"  ✗ {repo}: {exc}", file=sys.stderr)
            failed += 1
            continue
        print(f"{repo}: {', '.join(sorted(names)) if names else '(no secrets)'}")
    return EXIT_OK if failed == 0 else EXIT_FAILED


def cmd_delete(args: argparse.Namespace, manager: GitHubSecretsManager) -> int:
    """Delete one named secret from each repository."""
    try:
        repos = parse_repo_list(args.repos)
    except SpecError as exc:
        print(f"error: {exc}", file=sys.stderr)
        return EXIT_USAGE

    print(f"Plan: delete '{args.secret_name}' from {len(repos)} repository(ies)")
    for repo in repos:
        print(f"  {repo}  {args.secret_name}")
    if args.dry_run:
        print("\n--dry-run: nothing sent.")
        return EXIT_OK

    succeeded = sum(1 for repo in repos if manager.delete_secret(repo, args.secret_name))
    print(f"\nCompleted: {succeeded}/{len(repos)} deletion(s) succeeded")
    return EXIT_OK if succeeded == len(repos) else EXIT_FAILED


def build_parser() -> argparse.ArgumentParser:
    """Build the argument parser, including the shared --repos help text."""
    parser = argparse.ArgumentParser(
        description="Manage repository-level GitHub Actions secrets across multiple repositories",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Options that apply to the whole run (--owner, --token, --timeout) go before the
subcommand; options that apply to one operation go after it.

Examples:
  # One secret, same value in every listed repo
  %(prog)s --owner myorg sync --repos repo1,repo2,repo3 --secrets AWS_KEY=abc123

  # Two secrets, same values in every listed repo
  %(prog)s --owner myorg sync --repos repo1,repo2 --secrets AWS_KEY=abc123,APP_KEY=def456

  # Per-repo values from files: repos.csv needs a 'repository' column, secrets.csv
  # needs 'repository' and 'value', and --secret-name names the secret
  %(prog)s --owner myorg sync --repos repos.csv --secrets secrets.csv --secret-name AWS_KEY

  # Preview the plan without sending anything
  %(prog)s --owner myorg sync --repos repo1,repo2 --secrets AWS_KEY=abc123 --dry-run

  # List secret names (token read from $GITHUB_TOKEN)
  %(prog)s --owner myorg list --repos repo1,repo2,repo3

  # Delete a secret from multiple repos
  %(prog)s --owner myorg delete --repos repo1,repo2,repo3 --secret-name OLD_KEY
""",
    )
    parser.add_argument(
        "--token",
        default=None,
        help=f"GitHub token able to read and write repository secrets (or ${TOKEN_ENV})",
    )
    parser.add_argument(
        "--owner", required=True, help="GitHub organization or user owning the repositories"
    )
    parser.add_argument(
        "--timeout", type=int, default=DEFAULT_TIMEOUT, help="Request timeout in seconds"
    )

    repos_help = (
        "Comma-separated repositories, a text file with one per line, "
        "or a CSV with a 'repository' column"
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    sync_parser = subparsers.add_parser("sync", help="Create or update secrets")
    sync_parser.add_argument("--repos", required=True, help=repos_help)
    sync_parser.add_argument(
        "--secrets",
        required=True,
        help=(
            "Comma-separated NAME=VALUE pairs applied to every repo, a CSV with "
            "'repository' and 'value' columns, or a JSON list of "
            "{repository, name, value} rows"
        ),
    )
    sync_parser.add_argument(
        "--secret-name",
        default=None,
        help="Secret name for file sources that have no 'name' column",
    )
    sync_parser.add_argument(
        "--dry-run", action="store_true", help="Print the plan without sending requests"
    )

    list_parser = subparsers.add_parser("list", help="List secret names in each repository")
    list_parser.add_argument("--repos", required=True, help=repos_help)

    delete_parser = subparsers.add_parser("delete", help="Delete a secret from repositories")
    delete_parser.add_argument("--repos", required=True, help=repos_help)
    delete_parser.add_argument(
        "--secret-name", required=True, help="Name of the secret to delete"
    )
    delete_parser.add_argument(
        "--dry-run", action="store_true", help="Print the plan without sending requests"
    )
    return parser


def main() -> int:
    args = build_parser().parse_args()

    token = args.token or os.environ.get(TOKEN_ENV)
    if not token:
        print(
            f"error: a GitHub token is required (--token or ${TOKEN_ENV})", file=sys.stderr
        )
        return EXIT_USAGE

    manager = GitHubSecretsManager(token, args.owner, args.timeout)
    handlers = {"sync": cmd_sync, "list": cmd_list, "delete": cmd_delete}
    return handlers[args.command](args, manager)


if __name__ == "__main__":
    sys.exit(main())

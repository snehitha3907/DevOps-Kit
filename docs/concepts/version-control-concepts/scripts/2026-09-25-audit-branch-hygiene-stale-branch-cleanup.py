# last_verified: 2026-09-25 · version-control-concepts L2
"""
Practice script: audit branch hygiene and stale-branch cleanup with Python over git log.

I wrote this to learn how to programmatically analyze a git repository for branch
health — finding stale branches, measuring branch age, and identifying branches
that violate trunk-based development principles (long-lived feature branches).

Run from inside a git repository. Uses `git` CLI via subprocess for portability.
"""

import subprocess
import sys
import argparse
from datetime import datetime, timezone, timedelta
from typing import List, Dict, Optional
from dataclasses import dataclass


@dataclass
class BranchInfo:
    name: str
    last_commit_date: datetime
    last_commit_sha: str
    last_commit_subject: str
    author: str
    days_stale: int
    is_merged: bool
    upstream_gone: bool


def run_git(args: List[str]) -> str:
    """Run a git command and return stdout, or raise on error."""
    result = subprocess.run(
        ["git"] + args,
        capture_output=True,
        text=True,
        check=False
    )
    if result.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)} failed: {result.stderr.strip()}")
    return result.stdout.strip()


def get_all_branches(include_remote: bool = False) -> List[str]:
    """Get list of local (and optionally remote) branch names."""
    args = ["branch", "--format=%(refname:short)"]
    if include_remote:
        args.append("-a")
    else:
        args.append("-l")
    output = run_git(args)
    branches = [line.strip() for line in output.splitlines() if line.strip()]
    # Filter out HEAD and remote tracking branches if not requested
    if not include_remote:
        branches = [b for b in branches if not b.startswith("origin/")]
    return branches


def get_branch_info(branch: str) -> BranchInfo:
    """Get detailed info for a single branch."""
    # Last commit info
    fmt = "%(committerdate:iso8601)|%H|%s|%an"
    output = run_git(["log", "-1", f"--format={fmt}", branch])
    if not output:
        raise ValueError(f"No commits found for branch {branch}")
    date_str, sha, subject, author = output.split("|", 3)
    last_commit_date = datetime.fromisoformat(date_str.replace("Z", "+00:00"))
    if last_commit_date.tzinfo is None:
        last_commit_date = last_commit_date.replace(tzinfo=timezone.utc)

    now = datetime.now(timezone.utc)
    days_stale = (now - last_commit_date).days

    # Check if merged into main
    try:
        run_git(["merge-base", "--is-ancestor", branch, "main"])
        is_merged = True
    except RuntimeError:
        is_merged = False

    # Check if upstream tracking branch is gone (for local branches tracking remotes)
    upstream_gone = False
    try:
        upstream = run_git(["rev-parse", "--abbrev-ref", f"{branch}@{{u}}"])
        # Check if upstream ref exists
        run_git(["rev-parse", "--verify", upstream])
    except RuntimeError:
        upstream_gone = True

    return BranchInfo(
        name=branch,
        last_commit_date=last_commit_date,
        last_commit_sha=sha[:8],
        last_commit_subject=subject,
        author=author,
        days_stale=days_stale,
        is_merged=is_merged,
        upstream_gone=upstream_gone
    )


def find_stale_branches(
    max_age_days: int = 14,
    exclude: List[str] = None,
    include_merged: bool = False,
    include_main: bool = False
) -> List[BranchInfo]:
    """Find branches that haven't been updated in max_age_days."""
    if exclude is None:
        exclude = ["main", "master", "develop", "release"]

    branches = get_all_branches()
    stale = []

    for branch in branches:
        if branch in exclude and not include_main:
            continue

        try:
            info = get_branch_info(branch)
        except (ValueError, RuntimeError) as e:
            print(f"Warning: could not analyze {branch}: {e}", file=sys.stderr)
            continue

        if info.days_stale >= max_age_days:
            if not include_merged and info.is_merged:
                continue
            stale.append(info)

    return stale


def print_branch_report(branches: List[BranchInfo], show_merged: bool = False):
    """Print a formatted report of branch hygiene."""
    if not branches:
        print("No stale branches found.")
        return

    print(f"\n{'Branch':<35} {'Age':>4} {'SHA':<8} {'Author':<20} {'Status':<12} Subject")
    print("-" * 110)

    for b in sorted(branches, key=lambda x: x.days_stale, reverse=True):
        status_parts = []
        if b.is_merged:
            status_parts.append("merged")
        if b.upstream_gone:
            status_parts.append("upstream-gone")
        status = ", ".join(status_parts) if status_parts else "active"

        if not show_merged and b.is_merged:
            continue

        print(
            f"{b.name:<35} {b.days_stale:>4}d {b.last_commit_sha:<8} "
            f"{b.author:<20} {status:<12} {b.last_commit_subject[:50]}"
        )


def print_summary(branches: List[BranchInfo]):
    """Print summary statistics."""
    total = len(branches)
    merged = sum(1 for b in branches if b.is_merged)
    upstream_gone = sum(1 for b in branches if b.upstream_gone)
    oldest = max(branches, key=lambda x: x.days_stale) if branches else None

    print(f"\n=== Branch Hygiene Summary ===")
    print(f"Total stale branches (>{branches[0].days_stale if branches else 0}d): {total}")
    print(f"  Already merged to main:     {merged}")
    print(f"  Upstream tracking gone:     {upstream_gone}")
    if oldest:
        print(f"  Oldest: {oldest.name} ({oldest.days_stale}d, {oldest.last_commit_subject[:60]})")


def main():
    parser = argparse.ArgumentParser(
        description="Audit git branch hygiene — find stale and problematic branches",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python %(prog)s --max-age 14
  python %(prog)s --max-age 30 --include-merged --exclude main master release
  python %(prog)s --format json --output stale-branches.json
        """
    )
    parser.add_argument(
        "--max-age", "-a", type=int, default=14,
        help="Maximum branch age in days before considered stale (default: 14)"
    )
    parser.add_argument(
        "--exclude", "-e", nargs="+", default=["main", "master", "develop", "release"],
        help="Branch names to exclude from analysis (default: main master develop release)"
    )
    parser.add_argument(
        "--include-merged", action="store_true",
        help="Include branches already merged to main in results"
    )
    parser.add_argument(
        "--format", "-f", choices=["table", "json"], default="table",
        help="Output format (default: table)"
    )
    parser.add_argument(
        "--output", "-o", type=str,
        help="Write output to file instead of stdout"
    )
    args = parser.parse_args()

    try:
        # Verify we're in a git repo
        run_git(["rev-parse", "--git-dir"])
    except RuntimeError:
        print("Error: not a git repository (or git not in PATH)", file=sys.stderr)
        sys.exit(1)

    stale = find_stale_branches(
        max_age_days=args.max_age,
        exclude=args.exclude,
        include_merged=args.include_merged
    )

    if args.format == "json":
        import json
        data = [
            {
                "name": b.name,
                "last_commit_date": b.last_commit_date.isoformat(),
                "last_commit_sha": b.last_commit_sha,
                "last_commit_subject": b.last_commit_subject,
                "author": b.author,
                "days_stale": b.days_stale,
                "is_merged": b.is_merged,
                "upstream_gone": b.upstream_gone
            }
            for b in stale
        ]
        output = json.dumps(data, indent=2)
    else:
        print_branch_report(stale, show_merged=args.include_merged)
        print_summary(stale)
        return

    if args.output:
        with open(args.output, "w") as f:
            f.write(output)
        print(f"Wrote {len(stale)} stale branches to {args.output}")
    else:
        print(output)


if __name__ == "__main__":
    main()
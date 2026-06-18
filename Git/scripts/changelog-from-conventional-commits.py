#!/usr/bin/env python3
"""
Generate a changelog from conventional commits in a git repository.

Parses commit messages following the Conventional Commits specification
(https://www.conventionalcommits.org/) and outputs a grouped Markdown changelog
suitable for release notes.

Usage:
    python changelog-from-conventional-commits.py --from v1.0.0 --to v2.0.0
    python changelog-from-conventional-commits.py --range v1.0.0..HEAD
    git log --oneline --format="%s" | python changelog-from-conventional-commits.py --stdin
"""

import argparse
import re
import subprocess
import sys
from collections import OrderedDict

TYPE_ORDER = ["feat", "fix", "docs", "refactor", "perf", "test", "chore", "style", "ci", "build", "revert"]
TYPE_LABELS = {
    "feat": "Features",
    "fix": "Bug Fixes",
    "docs": "Documentation",
    "refactor": "Refactors",
    "perf": "Performance Improvements",
    "test": "Tests",
    "chore": "Chores",
    "style": "Style",
    "ci": "CI/CD",
    "build": "Build System",
    "revert": "Reverts",
}
CONVENTIONAL_PATTERN = re.compile(
    r"^(?P<type>\w+)(?:\((?P<scope>[\w.-]+)\))?(?P<breaking>!)?:\s*(?P<description>.+)$"
)


def parse_conventional_commit(message):
    match = CONVENTIONAL_PATTERN.match(message)
    if not match:
        return None
    return {
        "type": match.group("type"),
        "scope": match.group("scope"),
        "breaking": match.group("breaking") == "!",
        "description": match.group("description").strip(),
    }


def fetch_commits_from_git(commit_range, repo_path):
    try:
        cmd = ["git", "log", "--oneline", "--format=%s", commit_range]
        if repo_path:
            cmd.extend(["-C", repo_path])
        result = subprocess.run(cmd, capture_output=True, text=True, check=True)
        return [line.strip() for line in result.stdout.splitlines() if line.strip()]
    except subprocess.CalledProcessError as e:
        print(f"Error: git log failed for range '{commit_range}': {e.stderr.strip()}", file=sys.stderr)
        sys.exit(1)
    except FileNotFoundError:
        print("Error: git is not installed or not found in PATH.", file=sys.stderr)
        sys.exit(1)


def read_stdin():
    lines = [line.strip() for line in sys.stdin.readlines() if line.strip()]
    if not lines:
        print("Error: no input received on stdin.", file=sys.stderr)
        sys.exit(1)
    return lines


def group_commits(commits):
    groups = OrderedDict()
    breaking_changes = []
    uncategorized = []

    for raw in commits:
        parsed = parse_conventional_commit(raw)
        if parsed is None:
            uncategorized.append(raw)
            continue

        entry = f" {parsed['description']}"
        if parsed["scope"]:
            entry = f" **{parsed['scope']}:**{entry}"

        type_key = parsed["type"]
        if type_key not in groups:
            groups[type_key] = []
        groups[type_key].append(entry)

        if parsed["breaking"]:
            breaking_changes.append(entry)

    return groups, breaking_changes, uncategorized


def render_markdown(groups, breaking_changes, uncategorized, from_ref, to_ref):
    lines = []
    title = f"## Changelog"
    if from_ref and to_ref:
        title = f"## [{to_ref}] - {from_ref} → {to_ref}"
    elif to_ref:
        title = f"## [{to_ref}]"
    lines.append(title)
    lines.append("")

    if breaking_changes:
        lines.append("### ⚠ BREAKING CHANGES")
        for entry in breaking_changes:
            lines.append(f"-{entry}")
        lines.append("")

    for type_key in TYPE_ORDER:
        if type_key not in groups:
            continue
        label = TYPE_LABELS.get(type_key, type_key.capitalize())
        lines.append(f"### {label}")
        for entry in groups[type_key]:
            lines.append(f"-{entry}")
        lines.append("")

    for type_key in groups:
        if type_key not in TYPE_ORDER:
            label = TYPE_LABELS.get(type_key, type_key.capitalize())
            lines.append(f"### {label}")
            for entry in groups[type_key]:
                lines.append(f"-{entry}")
            lines.append("")

    if uncategorized:
        lines.append("### Uncategorized")
        for entry in uncategorized:
            lines.append(f"- {entry}")
        lines.append("")

    return "\n".join(lines).rstrip() + "\n"


def parse_args(argv=None):
    parser = argparse.ArgumentParser(
        description="Generate a changelog from conventional commits.",
        epilog="Examples:\n"
        "  %(prog)s --from v1.0.0 --to v2.0.0\n"
        "  %(prog)s --range v1.0.0..HEAD\n"
        "  git log --oneline --format='%%s' | %(prog)s --stdin",
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    source = parser.add_mutually_exclusive_group(required=True)
    source.add_argument("--range", help="Git revision range (e.g. v1.0.0..HEAD)")
    source.add_argument("--from", dest="from_ref", help="Starting ref (tag, commit)")
    source.add_argument("--stdin", action="store_true", help="Read commit messages from stdin")
    parser.add_argument("--to", dest="to_ref", default="HEAD", help="Ending ref (default: HEAD)")
    parser.add_argument("--repo", help="Path to git repository (default: current directory)")
    return parser.parse_args(argv)


def main():
    args = parse_args()
    commits = []

    if args.stdin:
        commits = read_stdin()
        from_ref, to_ref = None, None
    elif args.range:
        commits = fetch_commits_from_git(args.range, args.repo)
        from_ref, to_ref = None, args.range
    elif args.from_ref:
        commit_range = f"{args.from_ref}..{args.to_ref}"
        commits = fetch_commits_from_git(commit_range, args.repo)
        from_ref, to_ref = args.from_ref, args.to_ref

    if not commits:
        print("No commits found.", file=sys.stderr)
        sys.exit(0)

    groups, breaking_changes, uncategorized = group_commits(commits)

    markdown = render_markdown(groups, breaking_changes, uncategorized, from_ref, to_ref)
    sys.stdout.write(markdown)


if __name__ == "__main__":
    main()

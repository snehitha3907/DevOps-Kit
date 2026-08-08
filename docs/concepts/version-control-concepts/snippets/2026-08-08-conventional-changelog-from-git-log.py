# last_verified: 2026-08-08 · python n/a

"""
Changelog generator from git log + conventional commits — L2 concept
exercise for Version Control Concepts.

I wrote this because I kept hand-writing changelogs before releases.
Conventional Commits put the category (feat, fix, etc.) right in the
commit subject, so I can parse it straight out of `git log` and group
changes by section without maintaining a separate CHANGELOG.md file.
"""

import re
import subprocess
import sys
from collections import defaultdict
from dataclasses import dataclass

# I use unit-separator (0x1f) between fields and record-separator (0x1e)
# between commits. These control characters never appear in normal
# commit messages, so splitting is safe even when subjects contain
# spaces, colons, or parentheses.
FIELD_SEP = chr(0x1f)
RECORD_SEP = chr(0x1e)

# Conventional commit pattern:
#   type(scope?): subject   or   type!: subject  (breaking change)
# I chose a regex because the subject is a single line and the
# pattern fits in one expression more cleanly than splitting by hand.
CONVENTIONAL_RE = re.compile(
    r"^(?P<type>\w+)"
    r"(?:\((?P<scope>[^)]+)\))?"
    r"(?P<breaking>!)?"
    r":\s+(?P<subject>.+)$"
)

# BREAKING CHANGE can also appear as a footer in the commit body,
# not just as the `!` after the type. I check both forms.
BREAKING_FOOTER_RE = re.compile(r"^BREAKING[ -]CHANGE:", re.IGNORECASE)

# Map conventional commit types to changelog section headers.
TYPE_DISPLAY = {
    "feat": "Features",
    "fix": "Fixes",
    "docs": "Documentation",
    "style": "Styles",
    "refactor": "Refactors",
    "perf": "Performance",
    "test": "Tests",
    "chore": "Chores",
    "ci": "CI",
    "build": "Build",
    "revert": "Reverts",
}


@dataclass
class Commit:
    hash: str
    type: str
    scope: str | None
    subject: str
    is_breaking: bool = False


def get_commits(repo: str | None = None) -> list[Commit]:
    # The format string embeds raw control chars between fields and
    # records. Git outputs them literally and they survive the
    # subprocess call because they are not null bytes.
    fmt = f"%H{FIELD_SEP}%s{FIELD_SEP}%b{RECORD_SEP}"

    cmd = ["git"]
    if repo:
        cmd += ["-C", repo]
    cmd += ["log", f"--pretty=format:{fmt}"]

    result = subprocess.run(
        cmd, capture_output=True, text=True, check=True
    )

    commits: list[Commit] = []
    for record in result.stdout.split(RECORD_SEP):
        record = record.strip()
        if not record:
            continue
        parts = record.split(FIELD_SEP)
        if len(parts) < 3:
            continue
        full_hash = parts[0].strip()
        subject = parts[1].strip()
        body = parts[2].strip()

        m = CONVENTIONAL_RE.match(subject)
        if not m:
            continue

        is_breaking = bool(m.group("breaking"))
        if not is_breaking:
            for line in body.splitlines():
                if BREAKING_FOOTER_RE.match(line.strip()):
                    is_breaking = True
                    break

        commits.append(Commit(
            hash=full_hash[:7],
            type=m.group("type"),
            scope=m.group("scope"),
            subject=m.group("subject"),
            is_breaking=is_breaking,
        ))

    return commits


def group_by_section(commits: list[Commit]) -> dict[str, list[Commit]]:
    # I group commits into buckets so the changelog reads like it
    # was written by hand, not dumped straight from git.
    sections: dict[str, list[Commit]] = defaultdict(list)
    for c in commits:
        if c.is_breaking:
            sections["Breaking Changes"].append(c)
        else:
            label = TYPE_DISPLAY.get(c.type, f"{c.type}s".capitalize())
            sections[label].append(c)
    return sections


def format_changelog(commits: list[Commit]) -> str:
    sections = group_by_section(commits)
    # I order sections to match what I expect in a typical changelog —
    # breaking changes first, then features, fixes, etc.
    preferred_order = [
        "Breaking Changes", "Features", "Fixes", "Documentation",
        "Styles", "Refactors", "Performance", "Tests", "Chores",
    ]

    lines: list[str] = ["## Changelog", ""]
    remaining: dict[str, list[Commit]] = dict(sections)

    for name in preferred_order:
        items = remaining.pop(name, None)
        if not items:
            continue
        lines.append(f"### {name}")
        lines.append("")
        for c in items:
            scope = f"({c.scope})" if c.scope else ""
            lines.append(f"- {c.type}{scope}: {c.subject} (`{c.hash}`)")
        lines.append("")

    # Anything left over goes at the bottom so nothing is dropped.
    for name, items in remaining.items():
        lines.append(f"### {name}")
        lines.append("")
        for c in items:
            scope = f"({c.scope})" if c.scope else ""
            lines.append(f"- {c.type}{scope}: {c.subject} (`{c.hash}`)")
        lines.append("")

    return "\n".join(lines).rstrip() + "\n"


def main() -> int:
    repo = sys.argv[1] if len(sys.argv) > 1 else None
    try:
        commits = get_commits(repo)
    except subprocess.CalledProcessError as exc:
        print(f"git log failed: {exc.stderr}", file=sys.stderr)
        return 1
    except FileNotFoundError:
        print("git is not installed or not on PATH", file=sys.stderr)
        return 1

    if not commits:
        print("No conventional commits found.", file=sys.stderr)
        return 1

    print(format_changelog(commits))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

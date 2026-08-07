# last_verified: 2026-08-07 · python n/a

"""
Log parsing and filtering helper — L2 concept exercise for
Scripting & Automation (Bash/Python).

I wrote this because I kept copy-pasting one-off log filters into
shell history. This module centralizes the parsing logic so I can
import it in notebooks or call it from bash with `python -m`.
"""

import re
import sys
from collections import Counter
from pathlib import Path


# --- Exercise 1: basic pattern matching ---
# I used a compiled regex instead of string splitting because log lines
# have variable whitespace and I want to match the level (INFO/WARN/ERROR)
# at the start of each line. Calling `match` on individual lines handles
# the timestamp and level cleanly without needing the MULTILINE flag.

LEVEL_RE = re.compile(r"^(?P<ts>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})\s+(?P<level>\w+)\s+(?P<msg>.+)$")


def parse_line(line: str) -> dict | None:
    """Return a structured dict for one log line, or None if it doesn't match."""
    line = line.rstrip("\n")
    m = LEVEL_RE.match(line)
    if not m:
        return None
    return {
        "timestamp": m.group("ts"),
        "level": m.group("level"),
        "message": m.group("msg"),
    }


def filter_lines(lines: list[str], level: str | None = None, contains: str | None = None) -> list[dict]:
    """Filter parsed lines by log level and/or substring in the message."""
    results = []
    for line in lines:
        entry = parse_line(line)
        if entry is None:
            continue
        if level and entry["level"] != level.upper():
            continue
        if contains and contains not in entry["message"]:
            continue
        results.append(entry)
    return results


def count_by_level(lines: list[str]) -> Counter:
    """Return a Counter of log levels found in the input lines."""
    counts = Counter()
    for line in lines:
        entry = parse_line(line)
        if entry:
            counts[entry["level"]] += 1
    return counts


def tail_file(path: str, n: int = 50) -> list[str]:
    """Read the last n lines from a file. I used this instead of loading
    the whole file because large logs can be gigabytes."""
    p = Path(path)
    if not p.exists():
        raise FileNotFoundError(f"No log file at {path}")
    with p.open("r", encoding="utf-8", errors="replace") as f:
        all_lines = f.readlines()
    return all_lines[-n:]


# --- CLI entry point ---
# I wired this up so I can run the module directly from bash:
#   python log_helper.py --file app.log --level ERROR --tail 20
# The argparse setup was the easiest way to get help text and type
# conversion without pulling in click or typer.

def main() -> int:
    import argparse

    parser = argparse.ArgumentParser(description="Parse and filter log lines.")
    parser.add_argument("--file", required=True, help="Path to log file")
    parser.add_argument("--level", help="Filter to this log level (e.g. ERROR)")
    parser.add_argument("--contains", help="Only lines whose message contains this substring")
    parser.add_argument("--tail", type=int, default=50, help="Read last N lines (default 50)")
    parser.add_argument("--counts", action="store_true", help="Print level counts instead of matching lines")
    args = parser.parse_args()

    try:
        lines = tail_file(args.file, args.tail)
    except FileNotFoundError as exc:
        print(exc, file=sys.stderr)
        return 1

    if args.counts:
        counts = count_by_level(lines)
        for level, n in counts.most_common():
            print(f"{level:>7}: {n}")
        return 0

    matches = filter_lines(lines, level=args.level, contains=args.contains)
    for entry in matches:
        print(f"{entry['timestamp']} {entry['level']:>7} {entry['message']}")

    print(f"\nMatched {len(matches)} lines.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

# last_verified: 2026-09-23 · git (n/a)
"""Branch divergence with git rev-list — L2 concept exercise.

I kept getting confused about who was ahead, so I wrote this to
make `git rev-list --left-right --count` concrete. I pass two
branch names and it tells me how many commits each side has that
the other does not.
"""

import subprocess
import sys


# I wrap rev-list in one helper because I kept mistyping the
# triple-dot range. The docs example used `A...B` and that worked
# first try, so I stuck with it.
def divergence_counts(repo, left, right):
    # I use --left-right --count so git prints "ahead behind" as
    # two numbers, e.g. "2 5" means left is 2 ahead, 5 behind.
    result = subprocess.run(
        ["git", "-C", repo, "rev-list", "--left-right", "--count",
         f"{left}...{right}"],
        capture_output=True, text=True, check=True,
    )
    ahead, behind = result.stdout.strip().split()
    return int(ahead), int(behind)


# I added this list view because the counts alone did not tell me
# which commits were unique. The `<` / `>` markers show the side.
def list_unique_commits(repo, left, right, limit=10):
    result = subprocess.run(
        ["git", "-C", repo, "rev-list", "--left-right", "--oneline",
         f"{left}...{right}"],
        capture_output=True, text=True, check=True,
    )
    lines = [line for line in result.stdout.splitlines() if line.strip()]
    # I slice here because in a real repo this list can be long
    # and I only want a quick glance while learning.
    return lines[:limit]


def main():
    repo = sys.argv[1] if len(sys.argv) > 1 else "."
    left = sys.argv[2] if len(sys.argv) > 2 else "main"
    right = sys.argv[3] if len(sys.argv) > 3 else "HEAD"
    try:
        ahead, behind = divergence_counts(repo, left, right)
    except subprocess.CalledProcessError as exc:
        print(f"rev-list failed: {exc.stderr.strip()}", file=sys.stderr)
        return 1
    except FileNotFoundError:
        print("git is not on PATH", file=sys.stderr)
        return 1
    print(f"{left} is {ahead} ahead, {behind} behind {right}")
    # Got stuck on: I first tried `A..B` (two dots) and only saw
    # one side. Switching to three dots gave me both sides.
    for line in list_unique_commits(repo, left, right):
        print(line)
    # What I'd try next: wrap this in a loop over all local
    # branches so I can spot stale ones quickly.
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

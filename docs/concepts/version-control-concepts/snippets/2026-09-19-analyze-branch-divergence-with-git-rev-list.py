# last_verified: 2026-09-19 · Version Control Concepts n/a
import subprocess
import sys


def get_revs(repo_path, branch):
    """Return the set of commit SHAs reachable from a branch."""
    result = subprocess.run(
        ["git", "-C", repo_path, "rev-list", branch],
        capture_output=True, text=True, check=True,
    )
    return set(line for line in result.stdout.strip().split("\n") if line)


def analyze_divergence(repo_path, branch_a, branch_b):
    """Compare two branches with git rev-list to find divergent commits."""
    revs_a = get_revs(repo_path, branch_a)
    revs_b = get_revs(repo_path, branch_b)
    only_a = revs_a - revs_b
    only_b = revs_b - revs_a
    print(f"Branches compared: {branch_a} vs {branch_b}")
    print(f"Commits only in {branch_a}: {len(only_a)}")
    for commit in sorted(only_a)[:5]:
        show = subprocess.run(
            ["git", "-C", repo_path, "show", "--stat", "--oneline", commit],
            capture_output=True, text=True,
        )
        print(f"  {show.stdout.splitlines()[0]}")
    print(f"Commits only in {branch_b}: {len(only_b)}")
    for commit in sorted(only_b)[:5]:
        show = subprocess.run(
            ["git", "-C", repo_path, "show", "--stat", "--oneline", commit],
            capture_output=True, text=True,
        )
        print(f"  {show.stdout.splitlines()[0]}")
    return only_a, only_b


if __name__ == "__main__":
    repo = sys.argv[1] if len(sys.argv) > 1 else "."
    a = sys.argv[2] if len(sys.argv) > 2 else "main"
    b = sys.argv[3] if len(sys.argv) > 3 else "feature"
    analyze_divergence(repo, a, b)

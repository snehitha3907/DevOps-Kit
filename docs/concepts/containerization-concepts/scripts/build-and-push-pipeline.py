# last_verified: 2026-09-02 · python n/a

"""
Automated container image build and push pipeline — L3 concept exercise
combining containerization with CI/CD.

I sketched this because the typical "build then push" shell one-liner
(`docker build && docker tag && docker push`) hides a few decisions that
matter once you wire it into CI:
  - tagging by commit SHA AND `latest` (so deploy tools can pin a SHA but
    developers can still `docker pull myapp:latest`)
  - using `docker buildx` so the same script works on a CI runner's
    platform without juggling per-architecture manifests by hand
  - skipping the push when the build fails, and exiting non-zero so the
    CI step is marked red (not "succeeded with warnings")

I deliberately did NOT add registry login helpers — those belong in the
CI runner's secret store, not in the script. The script assumes `docker`
is already authenticated (CI sets `DOCKER_CONFIG` with a pre-written
`config.json`, or the runner caches the previous login).

Usage:
    python3 build_and_push.py <image_name> [<commit_sha>]
"""

import argparse
import os
import shlex
import subprocess
import sys
from datetime import datetime, timezone


def run(cmd: list[str], cwd: str | None = None) -> subprocess.CompletedProcess[str]:
    """Run a command and surface a clean error if it fails.

    I print the exact command (shell-quoted) before running it because the
    first time CI failed for me the issue was that a tag contained a
    stray newline from a CI variable — easier to spot in the log.
    """
    printable = " ".join(shlex.quote(part) for part in cmd)
    print(f"\n$ {printable}", flush=True)
    return subprocess.run(
        cmd, cwd=cwd, check=True, text=True, capture_output=True
    )


def resolve_sha(explicit: str | None) -> str:
    """Pick a tag-friendly identifier for this build.

    I prefer GITHUB_SHA / CI_COMMIT_SHA env vars when present because CI
    already guarantees they exist; otherwise I fall back to a UTC
    timestamp so repeated local runs don't collide on `latest`.
    """
    if explicit:
        return explicit
    for env_var in ("GITHUB_SHA", "CI_COMMIT_SHA", "COMMIT_SHA"):
        value = os.environ.get(env_var, "").strip()
        if value:
            return value[:12]
    return datetime.now(timezone.utc).strftime("%Y%m%d-%H%M%S")


def build_and_push(image_name: str, sha: str, push: bool) -> int:
    tags = [
        f"{image_name}:{sha}",
        f"{image_name}:latest",
    ]

    # I use buildx build (not plain `docker build`) so multi-arch and
    # registry-push-from-builder work the same way locally and in CI.
    # `--load` keeps the image in the local daemon for testing; in CI
    # you'd swap to `--push` and remove the second `docker push` step.
    cmd = [
        "docker", "buildx", "build",
        "--tag", tags[0],
        "--tag", tags[1],
        "--load",
        ".",
    ]
    try:
        run(cmd)
    except subprocess.CalledProcessError as exc:
        print(f"build failed (exit {exc.returncode}):", file=sys.stderr)
        print(exc.stderr.strip(), file=sys.stderr)
        return exc.returncode

    if not push:
        print("\nBuilt locally; skipping push (--no-push).")
        for tag in tags:
            print(f"  available: {tag}")
        return 0

    # A second explicit `docker push` for each tag is redundant with
    # buildx --push, but I'm leaving the loop here because the original
    # one-liner pattern (`docker push $TAG`) is what most CI snippets
    # actually use, and I want this script to mirror that shape so the
    # diff against an existing pipeline is small.
    for tag in tags:
        try:
            run(["docker", "push", tag])
        except subprocess.CalledProcessError as exc:
            print(f"push of {tag} failed (exit {exc.returncode}):", file=sys.stderr)
            print(exc.stderr.strip(), file=sys.stderr)
            return exc.returncode

    print("\nDone. Pushed:")
    for tag in tags:
        print(f"  {tag}")
    return 0


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__.splitlines()[0])
    parser.add_argument("image", help="Image name, e.g. ghcr.io/me/myapp")
    parser.add_argument("sha", nargs="?", help="Commit SHA tag (auto-detected if omitted)")
    parser.add_argument("--no-push", action="store_true",
                        help="Build only; do not push to the registry")
    args = parser.parse_args()

    sha = resolve_sha(args.sha)
    return build_and_push(args.image, sha, push=not args.no_push)


if __name__ == "__main__":
    raise SystemExit(main())
# last_verified: 2026-08-12 · Docker n/a
"""Build, run, then clean down a Docker container and its image.

Following the Get Started tutorial, I kept leaving stale containers behind,
so I scripted the build -> run -> cleanup loop. The explicit image tag keeps
the image from showing up as an anonymous <none> entry in `docker images`.
"""

import subprocess
import sys

# Explicit tag so the image is never an anonymous <none> entry.
IMAGE_NAME = "getting-started"
CONTAINER_NAME = "getting-started-run"


def run_docker(args, check=True):
    """Run a docker subcommand and stream its output."""
    result = subprocess.run(
        ["docker", *args],
        capture_output=True,
        text=True,
        check=check,
    )
    if result.stdout:
        print(result.stdout.strip())
    if result.stderr:
        print(result.stderr.strip(), file=sys.stderr)
    return result


def build(image):
    """Build the image from the current directory's Dockerfile."""
    run_docker(["build", "-t", image, "."])


def run_container(image, name):
    """Start the container in the background on localhost:3000."""
    run_docker(["run", "-d", "--name", name, "-p", "127.0.0.1:3000:3000", image])
    print(f"container '{name}' is serving at 127.0.0.1:3000")


def cleanup(name, image):
    """Stop and remove the container, then drop the image."""
    stop = run_docker(["stop", name], check=False)
    if stop.returncode != 0:
        print("container already stopped", file=sys.stderr)
    run_docker(["rm", name], check=False)
    run_docker(["rmi", image], check=False)
    print("cleanup done")


def main():
    print("building...")
    build(IMAGE_NAME)
    print("starting...")
    run_container(IMAGE_NAME, CONTAINER_NAME)
    print("stopping and removing everything...")
    cleanup(CONTAINER_NAME, IMAGE_NAME)


if __name__ == "__main__":
    main()

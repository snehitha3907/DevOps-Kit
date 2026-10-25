#!/usr/bin/env python3
# last_verified: 2026-10-23 · terraform + google provider (version not pinned in research)

import argparse, os, subprocess, sys, tempfile, textwrap
from pathlib import Path

TF = textwrap.dedent("""
    terraform { required_providers { google = { source = "hashicorp/google" } } }
    provider "google" { project = var.project; region = var.region }
    variable "project" { type = string }
    variable "region" { type = string; default = "us-central1" }
    variable "service_name" { type = string }
    variable "image" { type = string }
    resource "google_cloud_run_v2_service" "svc" {
      name = var.service_name; location = var.region; project = var.project
      template { containers = [{ image = var.image }] }
      traffic { percent = 100; latest_revision = true }
    }
    output "url" { value = google_cloud_run_v2_service.svc.uri }
""").strip()

def run(cmd, cwd):
    print(">>> " + " ".join(cmd))
    r = subprocess.run(cmd, cwd=cwd, capture_output=True, text=True)
    if r.stdout: print(r.stdout.rstrip())
    if r.stderr: print(r.stderr.rstrip(), file=sys.stderr)
    if r.returncode: raise SystemExit(r.returncode)

def main():
    p = argparse.ArgumentParser()
    p.add_argument("--project", required=True)
    p.add_argument("--region", default="us-central1")
    p.add_argument("--service-name", required=True)
    p.add_argument("--image", required=True)
    a = p.parse_args()
    with tempfile.TemporaryDirectory(prefix="tf-") as d:
        Path(d, "main.tf").write_text(TF + "\n")
        Path(d, "terraform.tfvars").write_text(
            f'project="{a.project}"\nregion="{a.region}"\nservice_name="{a.service_name}"\nimage="{a.image}"\n'
        )
        env = os.environ.copy(); env["TF_IN_AUTOMATION"] = "1"
        run(["terraform", "init", "-input=false"], d)
        run(["terraform", "plan", "-input=false"], d)
        run(["terraform", "apply", "-auto-approve"], d)
        run(["terraform", "output", "-raw", "url"], d)

if __name__ == "__main__":
    main()

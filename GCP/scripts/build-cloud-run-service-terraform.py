#!/usr/bin/env python3
# last_verified: 2026-09-29 · terraform + google provider (version not pinned in research)
#
# Purpose: Generate and apply a minimal Terraform configuration that deploys
# a container image to Cloud Run. The script writes the Terraform files to a
# temporary directory, runs `terraform init`, `terraform plan`, and
# `terraform apply`, then prints the service URL.
#
# When to use: you want a reproducible, scripted way to stand up a Cloud Run
# service without manually editing .tf files. Good for CI jobs or quick
# environment spin-up.
#
# Prerequisites: gcloud authenticated (`gcloud auth application-default login`),
# Terraform installed on PATH, a GCP project with Cloud Run and Artifact Registry
# APIs enabled, and a container image already pushed to Artifact Registry (or
# Docker Hub). The generated config leaves provider versions unpinned so
# `terraform init` resolves whatever is current; add a version constraint to the
# `required_providers` block once you have validated the resource surface you
# rely on.
#
# Usage:
#   python build-cloud-run-service-terraform.py \
#     --project my-gcp-project \
#     --region us-central1 \
#     --service-name hello-cloudrun \
#     --image us-docker.pkg.dev/cloudrun/container/hello:latest

import argparse
import os
import subprocess
import sys
import tempfile
import textwrap
from pathlib import Path


TERRAFORM_TEMPLATE = textwrap.dedent("""
    terraform {
      required_providers {
        google = {
          source = "hashicorp/google"
        }
      }
    }

    provider "google" {
      project = var.project
      region  = var.region
    }

    variable "project" {
      type        = string
      description = "GCP project ID"
    }

    variable "region" {
      type        = string
      description = "GCP region for the Cloud Run service"
      default     = "us-central1"
    }

    variable "service_name" {
      type        = string
      description = "Name of the Cloud Run service"
    }

    variable "image" {
      type        = string
      description = "Container image to deploy (Artifact Registry or Docker Hub)"
    }

    variable "cpu" {
      type        = number
      description = "CPU limit (vCPUs)"
      default     = 1
    }

    variable "memory" {
      type        = string
      description = "Memory limit (e.g., 512Mi, 1Gi)"
      default     = "512Mi"
    }

    variable "min_instances" {
      type        = number
      description = "Minimum number of instances (0 for scale-to-zero)"
      default     = 0
    }

    variable "max_instances" {
      type        = number
      description = "Maximum number of instances"
      default     = 10
    }

    resource "google_cloud_run_v2_service" "default" {
      name     = var.service_name
      location = var.region
      project  = var.project

      template {
        containers = [{
          image = var.image
          resources = {
            limits = {
              cpu    = var.cpu
              memory = var.memory
            }
          }
        }]
        scaling {
          min_instance_count = var.min_instances
          max_instance_count = var.max_instances
        }
      }

      traffic = [{
        percent         = 100
        latest_revision = true
      }]
    }

    resource "google_cloud_run_v2_service_iam_member" "public" {
      project  = var.project
      location = var.region
      service  = google_cloud_run_v2_service.default.name
      role     = "roles/run.invoker"
      member   = "allUsers"
    }

    output "service_url" {
      description = "HTTPS URL of the deployed Cloud Run service"
      value       = google_cloud_run_v2_service.default.uri
    }
""").strip()


def run_cmd(cmd, cwd=None, env=None, check=True):
    """Run a command, streaming output. Return CompletedProcess."""
    print(f">>> {' '.join(cmd)}")
    result = subprocess.run(cmd, cwd=cwd, env=env, capture_output=True, text=True)
    if result.stdout:
        print(result.stdout.rstrip())
    if result.stderr:
        print(result.stderr.rstrip(), file=sys.stderr)
    if check and result.returncode != 0:
        raise subprocess.CalledProcessError(result.returncode, cmd, result.stdout, result.stderr)
    return result


def main():
    parser = argparse.ArgumentParser(
        description="Deploy a container image to Cloud Run using Terraform"
    )
    parser.add_argument("--project", required=True, help="GCP project ID")
    parser.add_argument("--region", default="us-central1", help="GCP region")
    parser.add_argument("--service-name", required=True, help="Cloud Run service name")
    parser.add_argument("--image", required=True, help="Container image (e.g., us-docker.pkg.dev/project/repo/image:tag)")
    parser.add_argument("--cpu", type=int, default=1, help="CPU limit (vCPUs)")
    parser.add_argument("--memory", default="512Mi", help="Memory limit (e.g., 512Mi, 1Gi)")
    parser.add_argument("--min-instances", type=int, default=0, help="Minimum instances (0 = scale to zero)")
    parser.add_argument("--max-instances", type=int, default=10, help="Maximum instances")
    parser.add_argument("--auto-approve", action="store_true", help="Skip interactive apply confirmation")
    args = parser.parse_args()

    with tempfile.TemporaryDirectory(prefix="tf-cloudrun-") as tmpdir:
        tf_dir = Path(tmpdir)
        main_tf = tf_dir / "main.tf"
        main_tf.write_text(TERRAFORM_TEMPLATE + "\n")

        tfvars = tf_dir / "terraform.tfvars"
        tfvars.write_text(textwrap.dedent(f"""
            project         = "{args.project}"
            region          = "{args.region}"
            service_name    = "{args.service_name}"
            image           = "{args.image}"
            cpu             = {args.cpu}
            memory          = "{args.memory}"
            min_instances   = {args.min_instances}
            max_instances   = {args.max_instances}
        """).strip() + "\n")

        env = os.environ.copy()
        env["TF_IN_AUTOMATION"] = "1"

        print(f"Working in {tf_dir}")
        run_cmd(["terraform", "fmt"], cwd=tf_dir, env=env)
        run_cmd(["terraform", "init", "-input=false"], cwd=tf_dir, env=env)
        run_cmd(["terraform", "validate"], cwd=tf_dir, env=env)
        run_cmd(["terraform", "plan", "-input=false", "-out=tfplan"], cwd=tf_dir, env=env)

        apply_cmd = ["terraform", "apply", "-input=false"]
        if args.auto_approve:
            apply_cmd.append("-auto-approve")
        apply_cmd.append("tfplan")
        run_cmd(apply_cmd, cwd=tf_dir, env=env)

        output_result = run_cmd(
            ["terraform", "output", "-raw", "service_url"],
            cwd=tf_dir, env=env, check=False
        )
        if output_result.returncode == 0 and output_result.stdout.strip():
            print(f"\nService deployed: {output_result.stdout.strip()}")
        else:
            print("\nApply completed. Run `terraform output service_url` in the working directory to get the URL.")


if __name__ == "__main__":
    try:
        main()
    except subprocess.CalledProcessError as e:
        print(f"\nCommand failed with exit code {e.returncode}", file=sys.stderr)
        sys.exit(e.returncode)
    except KeyboardInterrupt:
        print("\nInterrupted", file=sys.stderr)
        sys.exit(130)
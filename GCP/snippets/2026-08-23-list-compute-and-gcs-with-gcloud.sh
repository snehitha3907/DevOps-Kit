#!/bin/bash
# last_verified: 2026-08-23 · GCP SDK (gcloud CLI)
# I wanted to see what's running in my GCP project and what storage buckets I have.

# List all Compute Engine instances in the current project.
gcloud compute instances list

# List all Cloud Storage buckets.
gcloud storage buckets list

# Filter to only running instances with the fields I care about.
gcloud compute instances list --filter="status=RUNNING" --format="table(name,zone,machineType,status)"

# Show bucket details in a compact table.
gcloud storage buckets list --format="table(name,location,storageClass)"

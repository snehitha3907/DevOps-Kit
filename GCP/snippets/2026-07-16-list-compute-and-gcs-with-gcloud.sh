#!/bin/bash
# last_verified: 2026-07-16 · GCP SDK (gcloud CLI)
# I wanted to list what I have in my GCP project — Compute Engine instances and GCS buckets.

# List Compute Engine instances across all zones in my project.
gcloud compute instances list

# List all Cloud Storage buckets in my project.
gcloud storage buckets list

# I added a filter to only show running instances.
gcloud compute instances list --filter="status=RUNNING"

# I used format to get a clean table with just the columns I care about.
gcloud storage buckets list --format="table(name,location,storageClass)"

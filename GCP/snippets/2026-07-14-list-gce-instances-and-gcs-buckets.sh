#!/usr/bin/env bash
# last_verified: 2026-07-14 - gcloud CLI n/a
# I listed Compute Engine instances and Cloud Storage buckets

gcloud compute instances list --format="table(name, zone, status, machineType)"
gsutil ls

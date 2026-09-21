#!/usr/bin/env bash
# last_verified: 2026-09-21 · GCP gcloud CLI
# gcp-013: following the Compute Engine quickstart — launch a VM, add a firewall rule, SSH in.
# I wanted one throwaway VM to click through the quickstart steps in order.

VM_NAME="${1:-quickstart-vm}"
ZONE="${2:-us-central1-a}"

# I am passing zone explicitly because the docs example relied on a
# pre-set default zone and mine was empty, so the create kept prompting me.
echo "Creating VM $VM_NAME in $ZONE..."
gcloud compute instances create "$VM_NAME" \
  --zone="$ZONE" \
  --machine-type=e2-micro \
  --image-family=debian-12 \
  --image-project=debian-cloud \
  --tags=http-server

# Doing the firewall rule here because the VM came up but port 80
# timed out until I allowed it for the http-server tag.
echo "Allowing port 80 to instances tagged http-server..."
gcloud compute firewall-rules create allow-http-to-quickstart \
  --allow=tcp:80 \
  --target-tags=http-server

echo "Checking the new instance..."
gcloud compute instances describe "$VM_NAME" --zone="$ZONE" --format="get(status,networkInterfaces[0].accessConfigs[0].natIP)"

# I used --command first so a failed login would not leave me
# sitting in an interactive session wondering what broke.
echo "Trying SSH with a quick remote command..."
gcloud compute ssh "$VM_NAME" --zone="$ZONE" --command="hostname && uname -a"

echo "Done. Next I would try connecting again without --command for a longer session."

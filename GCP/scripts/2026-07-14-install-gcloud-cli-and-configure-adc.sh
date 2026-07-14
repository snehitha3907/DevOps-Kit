#!/usr/bin/env bash
# last_verified: 2026-07-14 - gcloud CLI n/a
# I installed the gcloud CLI and set up Application Default Credentials

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
sudo apt-get update && sudo apt-get install -y google-cloud-cli
gcloud --version
gcloud init --console-only
gcloud auth application-default login

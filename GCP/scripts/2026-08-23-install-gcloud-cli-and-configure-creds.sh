#!/bin/bash
# last_verified: 2026-08-23 · GCP SDK (gcloud CLI)
# Install gcloud CLI and set up application-default credentials.

echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
sudo apt-get update && sudo apt-get install -y google-cloud-sdk
gcloud --version
gcloud init
gcloud auth application-default login
gcloud config list

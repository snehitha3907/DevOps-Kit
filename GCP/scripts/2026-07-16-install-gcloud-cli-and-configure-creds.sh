#!/bin/bash
# last_verified: 2026-07-16 · GCP SDK (gcloud CLI)
# I wanted to install gcloud CLI so I could start using GCP from my terminal.

# I followed the official install steps — adding the Google Cloud repo and installing the SDK.
echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl -fsSL https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg
sudo apt-get update && sudo apt-get install -y google-cloud-sdk

# I checked it installed correctly.
gcloud --version

# I initialized gcloud — this asks me to pick a project and region interactively.
gcloud init

# I set up application-default credentials so my local code can authenticate with GCP APIs.
gcloud auth application-default login

# Quick verify — this should show my project info without re-authenticating.
gcloud config list

#!/bin/bash
# Install kind and kubectl, then spin up my first cluster
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x ./kubectl && sudo mv ./kubectl /usr/local/bin/kubectl
kind create cluster --name my-first-cluster
kubectl cluster-info

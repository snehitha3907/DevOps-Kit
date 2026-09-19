#!/bin/sh
# last_verified: 2026-09-19 · Flux CD 2.x (flux CLI)

# I wanted to install the Flux CLI and run `flux check --pre` to see if a
# cluster is ready for Flux. This is the smallest thing that does it.

# Install the Flux CLI from the official install script (drops flux into /usr/local/bin)
curl -sSfL https://raw.githubusercontent.com/fluxcd/flux2/main/install.sh | sudo bash

# Verify the binary landed
flux --version

# Check that the cluster is ready for Flux: cert-manager, CRDs, network policy, etc.
flux check --pre
#!/usr/bin/env bash
# last_verified: 2026-09-19 · pulumi n/a
# I just got the Pulumi CLI and started a plain Python project.
# Run from an empty dir. I picked Python so I can use for-loops later.
command -v pulumi >/dev/null || { echo "pulumi not found yet"; exit 1; }
pulumi version
mkdir -p demo && cd demo || exit 1
pulumi new python --yes --name demo
pulumi stack init dev
pulumi preview

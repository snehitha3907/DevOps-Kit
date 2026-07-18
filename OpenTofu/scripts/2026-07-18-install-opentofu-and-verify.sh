# last_verified: 2026-07-18 · OpenTofu n/a

#!/bin/bash
# Install OpenTofu and verify with tofu --version
echo "Downloading the OpenTofu install script"
curl -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
# I trusted the official install script, then pipe it to sh
sh install-opentofu.sh
# Verify the binary landed and prints a version
tofu --version

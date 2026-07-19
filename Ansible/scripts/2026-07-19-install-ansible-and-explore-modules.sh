#!/bin/bash
# last_verified: 2026-07-19 · Ansible 2.18
# Install Ansible, check the version, and look up docs for the ping module

# I set up a Python venv and pip-installed ansible so I don't mess with system packages
python3 -m venv ~/ansible-env
source ~/ansible-env/bin/activate
pip install ansible

# Sanity check — which version did I get?
ansible --version

# I wanted to see what the ping module actually does before running it
ansible-doc ping

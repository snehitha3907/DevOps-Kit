#!/bin/bash
# Install Ansible and run my first ad-hoc command
sudo apt update && sudo apt install ansible -y
ansible --version
ansible localhost -m ping

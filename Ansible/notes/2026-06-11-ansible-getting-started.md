# Following Ansible Getting Started Guide

I worked through the official Ansible getting started guide and hit a few snags.

## Initial setup

Installed Ansible with `sudo apt install ansible -y`. The install worked smoothly, but I noticed the version was older than what the docs showed.

## Writing the inventory

The guide uses SSH by default, but for localhost I needed `ansible_connection=local` in the inventory. Without this, Ansible tries to SSH to localhost which fails on my machine. This wasn't obvious from the quick examples.

## First playbook attempt

My playbook worked for a basic install, but I hit a permission error when using `apt` module. Had to add `become: yes` at the playbook level to run with sudo privileges. The guide mentioned privilege escalation but didn't emphasize it enough for a simple apt install.

## Idempotent runs

The idempotent nature is slick. When I ran the playbook twice, the second run showed "ok=3" instead of "changed=1" — nothing changed because nginx was already installed and running. This is exactly what the primer promised.

## Got stuck on

The `become` flag. I kept getting "permission denied" errors until I realized apt requires root. L2 task but the docs assumed I knew this beforehand. Also, `update_cache: yes` takes extra time on first run but is necessary for fresh installs.
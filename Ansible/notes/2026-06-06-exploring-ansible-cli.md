# Exploring Ansible CLI

I installed Ansible and tried ad-hoc commands. Here's what I learned.

## Installing Ansible

`sudo apt install ansible -y` did it. `ansible --version` confirmed it's there.

## Ad-hoc commands

Ran `ansible localhost -m ping` and got "pong" back. That's the simplest ad-hoc command — just checks connectivity. Then tried `ansible localhost -m command -a "hostname"` to run a shell command on localhost.

## Inventory

Created a tiny inventory file with just `localhost`. Ran `ansible-inventory --list` to see how Ansible sees it. It showed localhost with connection vars.

## Got stuck on

The `localhost` setup. By default Ansible connects via SSH, but localhost doesn't need that. Using `ansible localhost` works because it connects to itself, but for real servers I'd need SSH keys set up.

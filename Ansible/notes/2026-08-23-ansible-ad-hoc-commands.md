---
last_verified: 2026-08-23
tool_version: n/a
sources: []
---

# Ansible ad-hoc commands — first contact

I installed Ansible today and ran my first ad-hoc command. Here's what happened.

## What I was trying to do

I wanted to ping all my hosts without writing a playbook. The docs say ad-hoc commands let you run a single module against inventory — seemed perfect for a quick sanity check.

## What actually worked

Installed with pip (`pip install ansible`). Created a simple inventory file with one localhost entry and `ansible_connection: local`. Ran:

```
ansible all -i inventory.ini -m ping
```

It worked. Got back `SUCCESS` for localhost. That felt good.

## What tripped me up

I forgot to add `ansible_connection: local` to my inventory and got a SSH error — Ansible tried to SSH into localhost because that's the default connection method. Took me a minute to realize it wasn't a firewall issue.

Also tried `ansible all -m shell -a "uptime"` without `-i` and it complained about no inventory. Forgot that ad-hoc still needs an inventory source.

## What I'd try next

I want to try running a command against multiple hosts and see how the output looks. Also curious about `ansible-doc` to look up module options without leaving the terminal.

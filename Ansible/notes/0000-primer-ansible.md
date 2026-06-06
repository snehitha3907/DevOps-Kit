# Ansible — quick primer

> First-day notes for someone who's never used Ansible. Personal voice, plain language.

## What is it?

Ansible is an automation tool for configuring and managing servers. It's like SSH'ing into machines one by one, but instead you write playbooks that describe what you want and Ansible makes it happen. Think of it as "infrastructure as code" for any system you can SSH into, without needing agents running on those systems.

## What does it do?

You write YAML files called playbooks that declare the desired state — which packages should be installed, which config files should exist, which services should run. Ansible connects via SSH, pushes small Python scripts, and executes them. It handles the complexity of idempotent changes: run a playbook twice and it only makes changes if needed.

## Why does it exist?

Before Ansible, I was writing shell scripts and manually copying them to each server. That breaks when servers diverge or when I need to do rolling updates across many machines. Ansible's push-based model works from my laptop, and the SSH-only requirement means I can manage almost any Linux box without installing extra software first.

## Key terminology

- **Control node** — Your machine running Ansible. That's where you write and execute playbooks.
- **Managed node** — Servers you manage. Any machine you can SSH into.
- **Inventory** — List of managed nodes. An INI file mapping hostnames to IPs.
- **Playbook** — YAML file describing tasks to run on hosts.
- **Module** — Reusable action like `apt`, `copy`, or `service`.
- **Task** — Single step in a playbook. Each calls one module.
- **Role** — Packaged collection of playbooks, vars, and templates.
- **Idempotent** — Running twice produces the same result as running once.

## A tiny example

```yaml
---
- hosts: webservers
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
```

This playbook installs nginx on any host in the "webservers" group from your inventory.

## What I'll cover next

I'll install Ansible and run my first ad-hoc command, then write a playbook to configure a test server.
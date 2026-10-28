---
last_verified: 2026-10-28
tool_version: ansible-core 2.21.5
sources:
  - https://github.com/ansible/ansible/releases/tag/v2.21.5
  - https://thelinuxcode.com/ansible-cheat-sheet-practical-commands-patterns-and-production-habits-2026
---

# Integrating Ansible with Network Devices

## Purpose

Reference for driving network equipment (switches, routers, firewalls) with Ansible using the network collection ecosystem, connection plugins, and idempotent modules.

## When to use

- You manage a fleet of network devices and want declarative, version-controlled configuration.
- You need to enforce a baseline across multi-vendor gear without logging into each box.
- You are migrating from manual CLI runbooks to repeatable automation.

## Prerequisites

- ansible-core 2.21.5 installed.
- Network collections installed (`cisco.ios`, `arista.eos`, `junipernetworks.junos`, etc.).
- SSH reachability from the control node to device management interfaces.
- Credentials stored via Ansible Vault or an external secret store.

## Steps

### 1. Inventory with connection variables

Group devices by platform and set the connection plugin and network OS:

```yaml
all:
  children:
    cisco_ios:
      hosts:
        sw1.example.com:
          ansible_host: 10.0.0.1
      vars:
        ansible_connection: network_cli
        ansible_network_os: cisco.ios.ios
        ansible_user: admin
```

### 2. Install the collection

```bash
ansible-galaxy collection install cisco.ios
```

Pin collections in `collections/requirements.yml` for reproducibility.

### 3. Write a playbook using network modules

```yaml
- name: Configure NTP on Cisco IOS devices
  hosts: cisco_ios
  gather_facts: false
  tasks:
    - name: Set NTP servers
      cisco.ios.ios_ntp_global:
        config:
          servers:
            - server: 10.0.0.53
              prefer: true
        state: merged
```

### 4. Use `network_cli` with privilege escalation

Most devices require enable mode. Set `ansible_become: true` and `ansible_become_method: enable` in inventory or group vars.

### 5. Validate before commit

Run in check mode first:

```bash
ansible-playbook site.yml --check --diff
```

### 6. Apply changes

```bash
ansible-playbook site.yml
```

## Verify

- Run `ansible-playbook site.yml --check` — expect zero changes on a second run (idempotency).
- Confirm device config with the vendor CLI or a `show running-config` task.
- Review the Ansible report for failed hosts.

## Rollback

- Revert via a playbook that restores the prior saved config, or restore from a backup captured before the run.
- Keep a timestamped backup of `running-config` captured in a pre-task.

## Common errors

- **Connection timeout**: verify SSH and that `ansible_host` resolves; check firewall rules on TCP/22.
- **Authentication failed**: confirm vaulted credentials and that the user has privilege level 15.
- **Module not found**: collection not installed; run `ansible-galaxy collection install`.
- **Idempotency drift**: prefer `state: merged` with full config; avoid `command`/`shell` for config changes.

## References

- Ansible network automation guide (ansible-core 2.21.5): https://github.com/ansible/ansible/releases/tag/v2.21.5
- Production habits reference: https://thelinuxcode.com/ansible-cheat-sheet-practical-commands-patterns-and-production-habits-2026

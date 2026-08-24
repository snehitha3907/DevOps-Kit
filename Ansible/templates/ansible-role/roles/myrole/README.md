# last_verified: 2026-08-24 · Ansible 11.4.0
# myrole

A scaffold Ansible role with Molecule testing. Use this as a starting point for new roles.

## Requirements

- Ansible >= 2.15
- Docker (for Molecule tests)
- Python >= 3.10 with `molecule[docker]` installed

## Role Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `myrole_packages` | `[nginx]` | Packages to install |
| `myrole_service_name` | `nginx` | systemd service name |
| `myrole_config_dir` | `/etc/nginx` | Configuration directory |
| `myrole_server_listen_port` | `80` | Port to listen on |
| `myrole_server_name` | `localhost` | Server name directive |

## Dependencies

None.

## Example Playbook

```yaml
- hosts: webservers
  become: true
  roles:
    - role: myrole
      vars:
        myrole_server_listen_port: 8080
        myrole_server_name: example.com
```

## Testing

```bash
# Run full Molecule test cycle (destroy, create, converge, verify, destroy)
molecule test

# Just converge without destroying
molecule converge

# Run only verification
molecule verify

# Login to the test container for debugging
molecule login
```

## License

MIT

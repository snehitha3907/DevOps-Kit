#!/bin/bash
# Run my first Ansible playbook to configure a local target

# Create inventory with localhost using connection=local
cat > inventory.ini <<'EOF'
[local]
localhost ansible_connection=local
EOF

# Create playbook to install and start nginx on localhost
cat > first-playbook.yaml <<'EOF'
---
- name: Configure local web server
  hosts: local
  become: yes
  tasks:
    - name: Install nginx
      apt:
        name: nginx
        state: present
        update_cache: yes

    - name: Ensure nginx is running
      service:
        name: nginx
        state: started
        enabled: yes
EOF

# Run the playbook
ansible-playbook -i inventory.ini first-playbook.yaml
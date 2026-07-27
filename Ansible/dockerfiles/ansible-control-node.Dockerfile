# last_verified: 2026-07-25 · Ansible n/a

FROM python:3.11-slim AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    openssh-client \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir "ansible-core==2.20.*"

RUN ansible-galaxy collection install \
    community.docker:3.9.0 \
    community.general:7.1.0 \
    ansible.posix:1.5.4

RUN useradd -m -u 1000 ansible && \
    mkdir -p /home/ansible/projects && \
    chown -R ansible:ansible /home/ansible

USER ansible
WORKDIR /home/ansible/projects

CMD ["ansible", "--version"]

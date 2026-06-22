#!/bin/bash
# Install GitLab Runner and register for a project
# docs: https://docs.gitlab.com/runner/install/linux-repo.html
curl -L "https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh" | sudo bash
sudo apt-get install -y gitlab-runner
sudo gitlab-runner register --non-interactive \
  --url "https://gitlab.com/" \
  --registration-token "YOUR_TOKEN" \
  --executor "shell" \
  --description "my-first-runner"
sudo gitlab-runner list

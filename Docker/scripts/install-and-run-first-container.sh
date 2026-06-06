#!/bin/bash
# Install Docker and run my first container
sudo apt update && sudo apt install docker.io -y
sudo systemctl start docker
docker --version
docker run hello-world
docker images
docker ps -a

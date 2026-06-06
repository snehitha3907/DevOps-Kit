#!/bin/bash

# Install Docker and run nginx container
if ! command -v docker &> /dev/null; then
    echo "Docker not found — installing..."
    sudo apt update && sudo apt install docker.io -y
fi

echo "Docker version: $(docker --version)"
sudo docker run -d --name my-nginx -p 8080:80 nginx
echo "Nginx running on http://localhost:8080"
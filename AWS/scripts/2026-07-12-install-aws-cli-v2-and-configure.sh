#!/bin/bash
# Install AWS CLI v2 and set up credentials
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install
aws --version
rm -rf aws awscliv2.zip
aws configure
aws sts get-caller-identity

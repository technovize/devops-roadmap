#!/usr/bin/env bash
set -euo pipefail

# Most likely cause: Security group blocks port 22
MY_IP=$(curl -s ifconfig.me)
aws ec2 authorize-security-group-ingress \
  --group-id sg-xxxxxxxx \
  --protocol tcp --port 22 \
  --cidr "${MY_IP}/32"

# Wrong key permissions fix
chmod 400 my-first-keypair.pem

# Wrong username per AMI type:
# Amazon Linux 2 -> ec2-user
# Ubuntu         -> ubuntu
# RHEL           -> ec2-user
# Debian         -> admin

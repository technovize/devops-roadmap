#!/usr/bin/env bash
set -euo pipefail

# Configure AWS CLI
aws configure

# Create a key pair
aws ec2 create-key-pair \
  --key-name my-first-keypair \
  --query 'KeyMaterial' \
  --output text > my-first-keypair.pem
chmod 400 my-first-keypair.pem

# Find latest Amazon Linux 2 AMI
AMI_ID=$(aws ec2 describe-images \
  --owners amazon \
  --filters "Name=name,Values=amzn2-ami-hvm-*-x86_64-gp2" \
  --query 'sort_by(Images, &CreationDate)[-1].ImageId' \
  --output text)

# Launch instance
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type t2.micro \
  --key-name my-first-keypair \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=lab-vm}]' \
  --query 'Instances[0].InstanceId' \
  --output text)

echo "Instance ID: $INSTANCE_ID"

# Wait for instance to be running
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Get public IP
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].PublicIpAddress' \
  --output text)

echo "Connect with: ssh -i my-first-keypair.pem ec2-user@$PUBLIC_IP"

# SSH in and explore
ssh -i my-first-keypair.pem ec2-user@$PUBLIC_IP
# Inside: uname -a | df -h | free -m | curl ipinfo.io

# TERMINATE when done (avoid charges)
aws ec2 terminate-instances --instance-ids $INSTANCE_ID

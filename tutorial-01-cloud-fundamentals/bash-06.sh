#!/usr/bin/env bash
set -euo pipefail

# Find all running instances immediately
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].[InstanceId,InstanceType,LaunchTime]' \
  --output table

# Terminate all running instances (use with caution)
aws ec2 describe-instances \
  --filters "Name=instance-state-name,Values=running" \
  --query 'Reservations[*].Instances[*].InstanceId' \
  --output text | xargs aws ec2 terminate-instances --instance-ids

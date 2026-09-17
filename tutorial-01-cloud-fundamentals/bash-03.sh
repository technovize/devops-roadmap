#!/usr/bin/env bash
set -euo pipefail

# List all AWS regions
aws ec2 describe-regions --output table

# List AZs in us-east-1
aws ec2 describe-availability-zones \
  --region us-east-1 \
  --output table

# Count total regions
aws ec2 describe-regions \
  --query 'length(Regions)' \
  --output text

# Compare latency to different regions (ping the public endpoints)
for region in us-east-1 eu-west-1 ap-southeast-1; do
  echo -n "Latency to $region: "
  ping -c 3 ec2.$region.amazonaws.com 2>/dev/null | \
    grep 'avg' | awk -F'/' '{print $5"ms"}'
done

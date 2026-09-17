#!/usr/bin/env bash
set -euo pipefail

# Check your AWS region
echo $AWS_DEFAULT_REGION
aws configure get region

# Resources may be in a different region — list across all
for region in $(aws ec2 describe-regions --query 'Regions[].RegionName' --output text); do
  count=$(aws ec2 describe-instances \
    --region $region \
    --filters "Name=instance-state-name,Values=running" \
    --query 'length(Reservations[*].Instances[*])' \
    --output text 2>/dev/null || echo "0")
  [[ "$count" -gt "0" ]] && echo "$region: $count instances"
done

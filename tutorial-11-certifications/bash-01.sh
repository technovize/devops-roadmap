#!/usr/bin/env bash
set -euo pipefail

# Labs to complete while studying — these directly map to exam scenarios

# 1. Build a multi-tier VPC from scratch
aws ec2 create-vpc --cidr-block 10.0.0.0/16
# Add public/private subnets, IGW, NAT gateway, route tables

# 2. Launch an EC2 Auto Scaling Group behind an ALB
# 3. Set up RDS Multi-AZ with a read replica
# 4. Configure S3 lifecycle policies and cross-region replication
# 5. Implement an IAM policy with least privilege for an EC2 instance role
# 6. Set up CloudFront in front of an S3 static site

#!/usr/bin/env bash
set -euo pipefail

# The resource exists in AWS but not in Terraform state
# Fix: Import the existing resource into state
terraform import aws_vpc.main vpc-0123456789abcdef0

# Then plan to verify alignment
terraform plan
# Should show: No changes (if the code matches the existing resource)

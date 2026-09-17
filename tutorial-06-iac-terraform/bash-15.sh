#!/usr/bin/env bash
set -euo pipefail

# Terraform plan shows: "Plan: 1 to add" but resource still exists logically

# Option A: Remove from state and re-import
terraform state rm aws_instance.web
terraform import aws_instance.web i-0123456789abcdef0

# Option B: Let Terraform recreate it
terraform apply   # Will create a new resource to match desired state

# Prevention: Never manually modify resources managed by Terraform
# Use IaC for ALL changes to managed resources

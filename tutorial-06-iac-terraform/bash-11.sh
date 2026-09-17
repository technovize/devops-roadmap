#!/usr/bin/env bash
set -euo pipefail

# Run the lab
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply -auto-approve

# Inspect state
terraform state list
terraform show
terraform output

# Clean up
terraform destroy -auto-approve

#!/usr/bin/env bash
set -euo pipefail

# Apply with a specific vars file
terraform apply -var-file="staging.tfvars"

# Pass sensitive variables via environment variable (not in files)
export TF_VAR_db_password="securepassword123"
terraform apply -var-file="staging.tfvars"

#!/usr/bin/env bash
set -euo pipefail

# Terraform built-in validation
terraform fmt -check -recursive    # Check formatting without modifying
terraform validate                 # Validate HCL syntax and config

# TFLint — linting for Terraform (catches AWS-specific mistakes)
tflint --init
tflint --recursive

# Checkov — security and compliance scanning for IaC
checkov -d . --framework terraform
checkov --compact --quiet

# tfsec — security scanner for Terraform
tfsec .

# Terrascan
terrascan scan -i terraform

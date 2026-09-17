#!/usr/bin/env bash
set -euo pipefail

# Generate a Terraform plan as JSON
terraform plan -out=tfplan
terraform show -json tfplan > tfplan.json

# Evaluate OPA policies against the plan
opa eval \
  --input tfplan.json \
  --data policies/terraform/ \
  --format pretty \
  "data.terraform.required_tags.violation"

#!/usr/bin/env bash
set -euo pipefail

# -- Initial Setup ----------------------------------------------------------

# Initialize — download providers and configure backend
terraform init

# Format all .tf files consistently
terraform fmt -recursive

# Validate syntax and configuration correctness
terraform validate


# -- Planning ---------------------------------------------------------------

# Generate and display an execution plan
terraform plan -var-file="staging.tfvars"

# Save plan to a file (use this in CI/CD — apply exactly what was planned)
terraform plan -var-file="staging.tfvars" -out=tfplan

# Show the saved plan in human-readable format
terraform show tfplan


# -- Applying ---------------------------------------------------------------

# Apply the saved plan (no interactive prompt)
terraform apply tfplan

# Apply directly with auto-approval (use with caution — only in trusted CI/CD)
terraform apply -var-file="staging.tfvars" -auto-approve


# -- Inspecting State -------------------------------------------------------

# List all resources in state
terraform state list

# Show details of a specific resource
terraform state show aws_db_instance.main

# Show all outputs
terraform output

# Show a specific output
terraform output rds_endpoint


# -- Targeted Operations ----------------------------------------------------

# Plan/apply only specific resources (use sparingly)
terraform plan -target=aws_security_group.alb
terraform apply -target=aws_security_group.alb

# Remove a resource from state without destroying it
terraform state rm aws_s3_bucket.legacy


# -- Destruction ------------------------------------------------------------

# Destroy all managed resources (DANGEROUS — requires confirmation)
terraform destroy -var-file="staging.tfvars"

# Destroy a specific resource
terraform destroy -target=aws_db_instance.main -var-file="staging.tfvars"

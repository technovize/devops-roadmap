#!/usr/bin/env bash
set -euo pipefail

# Install
pip install checkov

# Scan Terraform directory
checkov -d ./terraform --framework terraform

# Scan with specific checks only
checkov -d ./terraform --check CKV_AWS_2,CKV_AWS_8,CKV_AWS_18

# Skip specific checks (with documented justification)
checkov -d ./terraform --skip-check CKV_AWS_144  # S3 cross-region replication — not needed

# Scan CloudFormation
checkov -d ./cloudformation --framework cloudformation

# Output SARIF for GitHub Security tab
checkov -d ./terraform --output sarif --output-file checkov.sarif

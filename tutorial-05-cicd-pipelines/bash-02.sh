#!/usr/bin/env bash
set -euo pipefail

# Python
flake8 .                            # PEP 8 style checking
black --check .                     # Code formatting
mypy app/                           # Type checking
bandit -r app/                      # Security linting

# JavaScript/TypeScript
eslint src/
prettier --check src/

# Terraform
terraform fmt -check
tflint

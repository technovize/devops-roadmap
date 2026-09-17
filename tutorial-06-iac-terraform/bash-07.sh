#!/usr/bin/env bash
set -euo pipefail

# Create a new workspace
terraform workspace new staging
terraform workspace new production

# Switch between workspaces
terraform workspace select staging

# List workspaces
terraform workspace list

# Show current workspace
terraform workspace show

#!/usr/bin/env bash
set -euo pipefail

# Check internet connectivity and proxy settings
curl -I https://registry.terraform.io

# Common fix: clear the plugin cache and retry
rm -rf .terraform
terraform init

# Fix for air-gapped environments: use a local mirror
terraform init -plugin-dir=/path/to/local/plugins

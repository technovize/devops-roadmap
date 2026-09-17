#!/usr/bin/env bash
set -euo pipefail

# Fix
aws configure
# Enter: Access Key ID, Secret Access Key, region, output format (json)

# Or via environment variables
export AWS_ACCESS_KEY_ID="your-key"
export AWS_SECRET_ACCESS_KEY="your-secret"
export AWS_DEFAULT_REGION="us-east-1"

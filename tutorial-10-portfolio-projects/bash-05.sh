#!/usr/bin/env bash
set -euo pipefail

# Problem: reviewer can't reproduce without your AWS credentials

# Fix A: Add a complete Prerequisites section to README
## Prerequisites
# - AWS account with free tier
# - AWS CLI configured (aws configure)
# - Terraform >= 1.7.0 (brew install terraform)
# - kubectl >= 1.29 (brew install kubectl)

# Fix B: Provide a destroy-and-recreate script to show it works
./scripts/demo.sh     # Provisions everything, waits 60s, destroys

# Fix C: Include a recorded terminal session (asciinema)
pip install asciinema
asciinema rec demo.cast
# Run your project commands
asciinema upload demo.cast   # Get a shareable link

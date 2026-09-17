#!/usr/bin/env bash
set -euo pipefail

# Install pre-commit
pip install pre-commit

# Install the hooks defined in .pre-commit-config.yaml
pre-commit install

# Run manually against all files
pre-commit run --all-files

# Update hooks to latest versions
pre-commit autoupdate

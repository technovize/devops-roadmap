#!/usr/bin/env bash
set -euo pipefail

# Install
pip install pip-audit

# Audit the current environment
pip-audit

# Audit a requirements file
pip-audit -r requirements.txt

# Output in JSON
pip-audit -r requirements.txt -f json -o pip-audit-report.json

# Automatically fix vulnerabilities (updates to safe versions in requirements.txt)
pip-audit -r requirements.txt --fix

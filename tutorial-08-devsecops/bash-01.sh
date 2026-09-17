#!/usr/bin/env bash
set -euo pipefail

# Install
pip install bandit

# Scan the entire application directory
bandit -r app/ -f json -o bandit-report.json

# Scan with specific severity and confidence thresholds
# -ll = only report MEDIUM and HIGH severity
# -ii = only report MEDIUM and HIGH confidence
bandit -r app/ -ll -ii

# Scan with custom configuration
bandit -r app/ -c bandit.yaml

#!/usr/bin/env bash
set -euo pipefail

# Run Bandit
pip install bandit
bandit vulnerable_app.py -f text

# Run Semgrep
pip install semgrep
semgrep --config=p/python vulnerable_app.py

# Fix each issue and re-run until clean

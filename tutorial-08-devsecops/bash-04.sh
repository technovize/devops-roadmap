#!/usr/bin/env bash
set -euo pipefail

# Install
pip install safety

# Scan requirements.txt against the vulnerability database
safety check -r requirements.txt

# Scan with JSON output for CI/CD parsing
safety check -r requirements.txt --json --output safety-report.json

# Scan and fail on vulnerabilities above a severity threshold
safety check -r requirements.txt --severity medium

# Example output
+==============================================================================+
| REPORT                                                                       |
| checked 47 packages, using free DB (updated once a month)                   |
+==============================+===========+==========================+=========+
| package                      | installed | affected                | ID      |
+==============================+===========+==========================+=========+
| django                       | 4.2.0     | <4.2.9                  | 65771   |
| requests                     | 2.28.0    | <2.31.0                 | 62044   |
+==============================+===========+==========================+=========+

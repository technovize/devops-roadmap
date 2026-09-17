#!/usr/bin/env bash
set -euo pipefail

# Common cause: Missing dependencies in requirements.txt
pip freeze > requirements.txt  # Capture all current deps

# Common cause: requirements.txt not pinned
# Bad:  boto3
# Good: boto3==1.34.0

# Common cause: Python version mismatch
python3 --version             # Check local version
# Match it in Dockerfile: FROM python:3.12-slim

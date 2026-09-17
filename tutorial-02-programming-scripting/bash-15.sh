#!/usr/bin/env bash
set -euo pipefail

# Never use sudo pip — use a virtual environment instead
python3 -m venv venv
source venv/bin/activate
pip install boto3 requests pyyaml

# Or install for current user only
pip install --user boto3

#!/usr/bin/env bash
set -euo pipefail

# Create a virtual environment
python3 -m venv venv

# Activate it
source venv/bin/activate          # Linux/macOS
venv\Scripts\activate             # Windows

# Install dependencies
pip install boto3 requests pyyaml python-dotenv

# Save dependencies to a requirements file
pip freeze > requirements.txt

# Install from requirements file (in CI/CD)
pip install -r requirements.txt

# Deactivate when done
deactivate

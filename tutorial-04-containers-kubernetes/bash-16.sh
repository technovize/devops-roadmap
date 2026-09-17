#!/usr/bin/env bash
set -euo pipefail

# Check why cache is being invalidated
docker build --no-cache=false -t my-app:test .

# Common cause: COPY . . before pip install
# Bad order (cache busted on any code change):
# COPY . .
# RUN pip install -r requirements.txt

# Good order (requirements cached separately):
# COPY requirements.txt .
# RUN pip install -r requirements.txt
# COPY . .

# Use BuildKit for better caching
export DOCKER_BUILDKIT=1
docker build -t my-app:latest .

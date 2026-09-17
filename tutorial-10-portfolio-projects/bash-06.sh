#!/usr/bin/env bash
set -euo pipefail

# Check image size
docker images myapp

# Common culprits:
docker history myapp --no-trunc | head -20

# Fix 1: Switch to slim base
# FROM python:3.12 (900MB) -> FROM python:3.12-slim (150MB)

# Fix 2: Use multi-stage builds
# Builder stage (with build tools) -> Production stage (runtime only)

# Fix 3: Clean up in the same layer
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential && \
    pip install -r requirements.txt && \
    apt-get purge -y build-essential && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Target: under 200MB for a Python web application

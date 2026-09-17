#!/usr/bin/env bash
set -euo pipefail

# Build and test
docker build -t django-app:local .
docker run --rm -p 8000:8000 -e DJANGO_SETTINGS_MODULE=config.settings django-app:local

# Check image size
docker images django-app:local

# Check the user inside the container
docker run --rm django-app:local whoami   # Should print: appuser

# Scan for vulnerabilities
docker run --rm aquasec/trivy:latest image django-app:local

#!/usr/bin/env bash
set -euo pipefail

# Verify no root user
docker inspect --format='{{.Config.User}}' my-app:1.0.0

# Check image layers for sensitive data
docker history my-app:1.0.0

# Scan for secrets baked into the image
trivy image --scanners secret my-app:1.0.0

# Verify the image is signed (Cosign)
cosign verify --certificate-identity-regexp=".*" \
  --certificate-oidc-issuer="https://token.actions.githubusercontent.com" \
  ghcr.io/myorg/my-app:sha-abc123

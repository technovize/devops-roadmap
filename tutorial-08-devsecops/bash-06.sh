#!/usr/bin/env bash
set -euo pipefail

# Install
brew install trivy       # macOS
apt install trivy        # Ubuntu

# Scan a local image
trivy image my-app:1.0.0

# Scan an image in a registry
trivy image ghcr.io/myorg/my-app:sha-abc123

# Scan and fail on HIGH or CRITICAL findings (use in CI/CD)
trivy image --severity HIGH,CRITICAL --exit-code 1 my-app:1.0.0

# Scan and output SARIF for GitHub Security tab
trivy image \
  --format sarif \
  --output trivy-results.sarif \
  my-app:1.0.0

# Scan a filesystem (useful in multi-stage builds)
trivy fs --severity HIGH,CRITICAL .

# Scan a Kubernetes cluster for vulnerabilities
trivy k8s --report summary cluster

# Scan infrastructure as code
trivy config --severity HIGH,CRITICAL ./terraform/

# Generate SBOM (Software Bill of Materials)
trivy image --format cyclonedx --output sbom.json my-app:1.0.0

#!/usr/bin/env bash
set -euo pipefail

# Install Trivy
brew install trivy      # macOS
# or
apt-get install trivy  # Ubuntu

# Scan an intentionally old image
trivy image python:3.8-slim

# Count vulnerabilities by severity
trivy image python:3.8-slim --format json | \
  jq '[.Results[].Vulnerabilities[] | .Severity] | group_by(.) | map({(.[0]): length}) | add'

# Compare with a newer image
trivy image python:3.12-slim

# Scan your own built image
docker build -t myapp:test .
trivy image myapp:test --severity HIGH,CRITICAL --exit-code 1

# Generate an SBOM (Software Bill of Materials)
trivy image myapp:test --format cyclonedx --output sbom.json
cat sbom.json | jq '.components | length'  # Count components

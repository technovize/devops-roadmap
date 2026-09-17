#!/usr/bin/env bash
set -euo pipefail

# Container image vulnerability scanning
trivy image $REGISTRY/$IMAGE_NAME:$COMMIT_SHA \
  --severity HIGH,CRITICAL \
  --exit-code 1         # Fail the pipeline on HIGH or CRITICAL findings

# Software Composition Analysis (SCA) — check dependencies
safety check -r requirements.txt    # Python
npm audit --audit-level=high        # Node.js

# Secret scanning — ensure no credentials slipped into code
trufflehog git file://. --only-verified
gitleaks detect --source .

#!/usr/bin/env bash
set -euo pipefail

# Check if the vulnerability has a fix available
trivy image myapp:latest --severity HIGH,CRITICAL

# If "No fixed version" — you can't fix it, but you should document it
# Add an exception with justification:
trivy image myapp:latest \
  --severity HIGH,CRITICAL \
  --ignore-unfixed           # Skip vulnerabilities with no fix available

# Or use a .trivyignore file for specific CVEs with documented justification:
cat > .trivyignore << 'EOF'
# CVE-2023-12345 - Affects only specific usage pattern we don't use
# Documented exception approved by security team on 2026-01-15
CVE-2023-12345
EOF

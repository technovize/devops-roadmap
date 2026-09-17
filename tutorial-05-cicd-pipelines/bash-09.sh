#!/usr/bin/env bash
set -euo pipefail

# Smoke test — quick sanity checks
curl -f https://api.myapp.com/health || (kubectl rollout undo deployment/my-app -n production && exit 1)
pytest tests/smoke/ --base-url=https://api.myapp.com

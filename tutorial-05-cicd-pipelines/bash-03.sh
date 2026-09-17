#!/usr/bin/env bash
set -euo pipefail

# Python
pytest tests/unit/ \
  --cov=app \
  --cov-report=xml \
  --cov-fail-under=80     # Fail if code coverage drops below 80%

# Node.js
npm test -- --coverage

# Java
mvn test

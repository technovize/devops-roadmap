#!/usr/bin/env bash
set -euo pipefail

# The switch — atomic, instant, zero-downtime
kubectl patch service my-app -n production \
  -p '{"spec":{"selector":{"slot":"green"}}}'

# Instant rollback if issues found
kubectl patch service my-app -n production \
  -p '{"spec":{"selector":{"slot":"blue"}}}'

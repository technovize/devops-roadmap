#!/usr/bin/env bash
set -euo pipefail

# Bad: Fails if directory already exists
mkdir /tmp/deployment

# Good: Idempotent — safe to run multiple times
mkdir -p /tmp/deployment

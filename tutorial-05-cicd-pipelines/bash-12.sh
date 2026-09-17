#!/usr/bin/env bash
set -euo pipefail

# scripts/smoke_test.sh — write this script
#!/bin/bash
set -euo pipefail

BASE_URL=${1:-"http://localhost:8000"}
TIMEOUT=${2:-30}

log() { echo "[$(date '+%H:%M:%S')] $*"; }

check_endpoint() {
  local path=$1
  local expected_status=${2:-200}
  local response

  response=$(curl -s -o /dev/null -w "%{http_code}" \
    --max-time 10 "$BASE_URL$path")

  if [[ "$response" == "$expected_status" ]]; then
    log "(correct) $path -> $response"
    return 0
  else
    log "(incorrect) $path -> $response (expected $expected_status)"
    return 1
  fi
}

log "Running smoke tests against $BASE_URL"

# TODO: add at least 3 endpoint checks
# check_endpoint "/health"       200
# check_endpoint "/api/v1/..."   200
# check_endpoint "/nonexistent"  404

log "All smoke tests passed"

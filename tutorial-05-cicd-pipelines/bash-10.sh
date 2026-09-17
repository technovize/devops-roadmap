#!/usr/bin/env bash
set -euo pipefail

# Slack notification via webhook
curl -X POST $SLACK_WEBHOOK_URL \
  -H 'Content-type: application/json' \
  --data "{\"text\": \"(yes) Deployed my-app $COMMIT_SHA to production\"}"

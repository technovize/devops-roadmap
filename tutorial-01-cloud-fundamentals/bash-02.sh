#!/usr/bin/env bash
set -euo pipefail

# AWS: Create a $10 budget alert
aws budgets create-budget \
  --account-id $(aws sts get-caller-identity --query Account --output text) \
  --budget '{
    "BudgetName": "learning-budget",
    "BudgetLimit": {"Amount": "10", "Unit": "USD"},
    "TimeUnit": "MONTHLY",
    "BudgetType": "COST"
  }' \
  --notifications-with-subscribers '[{
    "Notification": {
      "NotificationType": "ACTUAL",
      "ComparisonOperator": "GREATER_THAN",
      "Threshold": 80
    },
    "Subscribers": [{
      "SubscriptionType": "EMAIL",
      "Address": "your@email.com"
    }]
  }]'

# GCP: Set a budget alert in the Console
# Billing -> Budgets & Alerts -> Create Budget -> $10 -> 80% threshold

# Azure: Set a budget in Cost Management
# Cost Management -> Budgets -> Add -> $10 -> Alert at 80%

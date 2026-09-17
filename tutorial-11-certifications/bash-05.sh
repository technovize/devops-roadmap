#!/usr/bin/env bash
set -euo pipefail

# Strategy: Skip and return
# If a task takes more than 8 minutes: skip it, mark it, return at the end

# Speed shortcuts:
alias k=kubectl
export do="--dry-run=client -o yaml"
export now="--force --grace-period 0"

# Generate boilerplate instead of typing from scratch
k run pod1 --image=nginx $do > pod1.yaml && vi pod1.yaml && k apply -f pod1.yaml

# Use kubectl explain for quick reference (no browser needed)
k explain pod.spec.containers.securityContext
k explain deployment.spec.strategy.rollingUpdate

# Search docs efficiently:
# 1. Press Ctrl+F in browser
# 2. Search for the exact resource type name
# 3. Kubernetes docs have great CTRL+F-able examples

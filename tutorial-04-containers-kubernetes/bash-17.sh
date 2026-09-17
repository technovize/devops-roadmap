#!/usr/bin/env bash
set -euo pipefail

# Error: no matches for kind "Ingress" in version "networking.k8s.io/v1beta1"

# Fix: Check the correct API version for your Kubernetes version
kubectl api-resources | grep Ingress

# Update the apiVersion in your manifest:
# Old: apiVersion: networking.k8s.io/v1beta1
# New: apiVersion: networking.k8s.io/v1

# Check available API versions
kubectl api-versions | grep networking

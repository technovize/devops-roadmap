#!/usr/bin/env bash
set -euo pipefail

# Check sync status
argocd app get myapp

# Check what's out of sync
argocd app diff myapp

# Common cause: Resource in cluster was modified manually
# Fix A: Sync to Git (overwrite manual changes)
argocd app sync myapp --force

# Fix B: If the change was intentional, update Git to match
# kubectl get deployment myapp -o yaml -> update in Git

# Common cause: Image tag changed but ImagePolicy not configured
# Fix: Use ArgoCD Image Updater or update the tag in Git manually

# Check ArgoCD logs
kubectl logs -n argocd deployment/argocd-application-controller

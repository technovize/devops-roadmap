#!/usr/bin/env bash
set -euo pipefail

# Create the argocd namespace and install ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f \
  https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Wait for all pods to be ready
kubectl wait --for=condition=Ready pod --all -n argocd --timeout=300s

# Access the ArgoCD UI (port-forward for local access)
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Get the initial admin password
argocd admin initial-password -n argocd

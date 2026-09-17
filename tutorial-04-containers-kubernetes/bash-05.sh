#!/usr/bin/env bash
set -euo pipefail

# -- Applying Manifests -----------------------------------

# Apply a manifest (create or update)
kubectl apply -f deployment.yaml

# Apply all manifests in a directory
kubectl apply -f ./k8s/

# Delete resources defined in a manifest
kubectl delete -f deployment.yaml


# -- Inspecting Resources --------------------------------

# List all resources in a namespace
kubectl get all -n production

# List Pods with extra info (node, IP)
kubectl get pods -n production -o wide

# Describe a resource in detail (events, conditions, config)
kubectl describe pod my-app-abc123 -n production

# Get resource as YAML (useful for exporting or debugging)
kubectl get deployment my-app -n production -o yaml


# -- Logs and Debugging ----------------------------------

# View Pod logs
kubectl logs my-app-abc123 -n production

# Follow logs in real time
kubectl logs -f my-app-abc123 -n production

# View logs from a previous (crashed) container
kubectl logs my-app-abc123 -n production --previous

# Open a shell inside a running container
kubectl exec -it my-app-abc123 -n production -- bash

# Run a temporary debug Pod
kubectl run debug --image=busybox -it --rm -- sh


# -- Deployments -----------------------------------------

# Check rollout status
kubectl rollout status deployment/my-app -n production

# View rollout history
kubectl rollout history deployment/my-app -n production

# Roll back to the previous version
kubectl rollout undo deployment/my-app -n production

# Roll back to a specific revision
kubectl rollout undo deployment/my-app -n production --to-revision=3

# Trigger a new rollout (useful to force a pod restart)
kubectl rollout restart deployment/my-app -n production


# -- Scaling ---------------------------------------------

# Manually scale a deployment
kubectl scale deployment my-app --replicas=5 -n production


# -- Namespaces ------------------------------------------

# List all namespaces
kubectl get namespaces

# Set a default namespace for your session
kubectl config set-context --current --namespace=production

#!/usr/bin/env bash
set -euo pipefail

# Speed drill: complete each of these in under 3 minutes

# 1. Create a Pod named 'web' using nginx:1.25, expose port 80, add label env=prod
kubectl run web --image=nginx:1.25 --port=80 --labels=env=prod

# 2. Create a Deployment 'api' with 3 replicas of python:3.12-slim
kubectl create deployment api --image=python:3.12-slim --replicas=3

# 3. Create a ClusterIP service exposing the api deployment on port 8000
kubectl expose deployment api --port=8000 --target-port=8000

# 4. Create a ConfigMap 'app-config' with key LOG_LEVEL=debug
kubectl create configmap app-config --from-literal=LOG_LEVEL=debug

# 5. Create a Secret 'db-secret' with key password=mysecretpassword
kubectl create secret generic db-secret --from-literal=password=mysecretpassword

# 6. Get all pods sorted by creation time
kubectl get pods --sort-by=.metadata.creationTimestamp

# 7. Scale the api deployment to 5 replicas
kubectl scale deployment api --replicas=5

# 8. Drain node worker-1 safely
kubectl drain worker-1 --ignore-daemonsets --delete-emptydir-data

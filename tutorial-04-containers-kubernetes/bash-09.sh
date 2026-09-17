#!/usr/bin/env bash
set -euo pipefail

# minikube — the classic local K8s option
brew install minikube
minikube start
kubectl get nodes

# kind (Kubernetes in Docker) — fast, lightweight, great for CI
brew install kind
kind create cluster
kubectl get nodes

# Docker Desktop — includes a built-in K8s cluster (enable in settings)

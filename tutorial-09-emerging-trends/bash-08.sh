#!/usr/bin/env bash
set -euo pipefail

# Fermyon Spin — building WASM microservices
spin new -t http-py payment-handler --accept-defaults
cd payment-handler

# spin.toml — the WASM app manifest
cat spin.toml
# [application]
# name = "payment-handler"
# version = "0.1.0"
#
# [[component]]
# id = "payment"
# source = "app.wasm"
# [component.trigger]
# route = "/api/payments/..."

# Build and run locally
spin build
spin up

# Deploy to Kubernetes via SpinKube (runs WASM natively without a container runtime)
kubectl apply -f https://github.com/spinkube/spin-operator/releases/latest/download/install.yaml
kubectl apply -f spinapp.yaml

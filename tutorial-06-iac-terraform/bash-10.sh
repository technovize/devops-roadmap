#!/usr/bin/env bash
set -euo pipefail

# Run Terratest tests
cd test
go test -v -timeout 30m ./...

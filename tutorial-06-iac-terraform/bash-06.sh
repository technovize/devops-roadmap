#!/usr/bin/env bash
set -euo pipefail

terraform {
  cloud {
    organization = "myorg"
    workspaces {
      name = "myapp-production"
    }
  }
}

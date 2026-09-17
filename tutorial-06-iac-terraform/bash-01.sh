#!/usr/bin/env bash
set -euo pipefail

# Imperative — "Run these commands to create a bucket"
aws s3api create-bucket --bucket my-app-data --region us-east-1
aws s3api put-bucket-versioning --bucket my-app-data --versioning-configuration Status=Enabled

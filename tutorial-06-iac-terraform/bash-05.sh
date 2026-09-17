#!/usr/bin/env bash
set -euo pipefail

# Create the S3 bucket for state
aws s3api create-bucket \
  --bucket myorg-terraform-state \
  --region us-east-1

# Enable versioning (allows rollback to previous state)
aws s3api put-bucket-versioning \
  --bucket myorg-terraform-state \
  --versioning-configuration Status=Enabled

# Enable server-side encryption
aws s3api put-bucket-encryption \
  --bucket myorg-terraform-state \
  --server-side-encryption-configuration \
    '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

# Create DynamoDB table for state locking
aws dynamodb create-table \
  --table-name terraform-state-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1

#!/usr/bin/env bash
set -euo pipefail

# Step 1: Create the S3 bucket and DynamoDB table (one-time, manual)
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
BUCKET_NAME="terraform-state-${ACCOUNT_ID}"

aws s3api create-bucket \
  --bucket "$BUCKET_NAME" \
  --region us-east-1

aws s3api put-bucket-versioning \
  --bucket "$BUCKET_NAME" \
  --versioning-configuration Status=Enabled

aws s3api put-bucket-encryption \
  --bucket "$BUCKET_NAME" \
  --server-side-encryption-configuration \
  '{"Rules":[{"ApplyServerSideEncryptionByDefault":{"SSEAlgorithm":"AES256"}}]}'

aws dynamodb create-table \
  --table-name terraform-state-locks \
  --attribute-definitions AttributeName=LockID,AttributeType=S \
  --key-schema AttributeName=LockID,KeyType=HASH \
  --billing-mode PAY_PER_REQUEST \
  --region us-east-1

# Step 2: Add the backend configuration to your Terraform
cat > backend.tf << EOF
terraform {
  backend "s3" {
    bucket         = "$BUCKET_NAME"
    key            = "labs/vpc/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-locks"
  }
}
EOF

# Step 3: Migrate existing local state to remote
terraform init -migrate-state

# Step 4: Verify state is in S3
aws s3 ls s3://$BUCKET_NAME/labs/vpc/

# Step 5: Test locking (open two terminals and run apply simultaneously)
# Terminal 1: terraform apply (will acquire lock)
# Terminal 2: terraform apply (will show: "Error: Error acquiring the state lock")

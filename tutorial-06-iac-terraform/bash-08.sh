#!/usr/bin/env bash
set -euo pipefail

# -- Create or Update ------------------------------------------------------

# Create a new stack
aws cloudformation create-stack \
  --stack-name myapp-staging-vpc \
  --template-body file://cloudformation/vpc.yaml \
  --parameters \
    ParameterKey=ProjectName,ParameterValue=myapp \
    ParameterKey=Environment,ParameterValue=staging \
  --capabilities CAPABILITY_NAMED_IAM \
  --region us-east-1

# Wait for stack creation to complete
aws cloudformation wait stack-create-complete \
  --stack-name myapp-staging-vpc

# Create a Change Set (preview changes before applying)
aws cloudformation create-change-set \
  --stack-name myapp-staging-vpc \
  --template-body file://cloudformation/vpc.yaml \
  --change-set-name update-vpc-cidr \
  --parameters \
    ParameterKey=ProjectName,ParameterValue=myapp \
    ParameterKey=Environment,ParameterValue=staging

# Describe the Change Set (review the proposed changes)
aws cloudformation describe-change-set \
  --stack-name myapp-staging-vpc \
  --change-set-name update-vpc-cidr

# Execute the Change Set
aws cloudformation execute-change-set \
  --stack-name myapp-staging-vpc \
  --change-set-name update-vpc-cidr


# -- Inspection ------------------------------------------------------------

# List stacks
aws cloudformation list-stacks --stack-status-filter CREATE_COMPLETE UPDATE_COMPLETE

# Show stack outputs
aws cloudformation describe-stacks \
  --stack-name myapp-staging-vpc \
  --query "Stacks[0].Outputs"

# Detect drift (manual changes outside CloudFormation)
aws cloudformation detect-stack-drift --stack-name myapp-staging-vpc
aws cloudformation describe-stack-drift-detection-status --stack-drift-detection-id <id>


# -- Deletion --------------------------------------------------------------

# Delete a stack (destroys all resources it manages)
aws cloudformation delete-stack --stack-name myapp-staging-vpc
aws cloudformation wait stack-delete-complete --stack-name myapp-staging-vpc

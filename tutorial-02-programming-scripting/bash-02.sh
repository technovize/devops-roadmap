#!/bin/bash

ENVIRONMENT=$1  # First argument passed to the script

if [ "$ENVIRONMENT" == "production" ]; then
    echo "Running production deployment checks..."
elif [ "$ENVIRONMENT" == "staging" ]; then
    echo "Deploying to staging..."
else
    echo "Unknown environment: $ENVIRONMENT"
    exit 1  # Exit with a non-zero code to signal failure
fi

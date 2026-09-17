#!/bin/bash

# Define a reusable function
check_service() {
    local SERVICE_NAME=$1
    if systemctl is-active --quiet "$SERVICE_NAME"; then
        echo "(correct) $SERVICE_NAME is running"
    else
        echo "(incorrect) $SERVICE_NAME is NOT running"
        return 1
    fi
}

# Call the function
check_service "nginx"
check_service "postgresql"
check_service "redis"

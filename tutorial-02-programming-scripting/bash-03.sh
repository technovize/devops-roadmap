#!/bin/bash

# Loop over a list of servers
SERVERS=("web-01" "web-02" "web-03")

for SERVER in "${SERVERS[@]}"; do
    echo "Checking health of $SERVER..."
    curl -s "http://$SERVER/health" || echo "WARNING: $SERVER is not responding"
done

#!/usr/bin/env bash
set -euo pipefail

# Install Falco on Kubernetes
helm repo add falcosecurity https://falcosecurity.github.io/charts
helm install falco falcosecurity/falco \
  --namespace falco --create-namespace \
  --set driver.kind=ebpf \              # Use eBPF driver (no kernel module required)
  --set falcosidekick.enabled=true \    # Forward alerts to Slack/PagerDuty
  --set falcosidekick.config.slack.webhookurl=$SLACK_WEBHOOK

#!/usr/bin/env bash
set -euo pipefail

# Deploy the stack (requires a running Kubernetes cluster)
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update

helm install monitoring prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --set grafana.adminPassword=admin \
  --wait

# Access Grafana
kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring &

# Export a dashboard to JSON (for committing to Git)
# In Grafana: Dashboard -> Share -> Export -> Save to file

# Write the runbook (this is the exercise)
cat > RUNBOOK.md << 'EOF'
# Observability Stack Runbook

## Dashboard URLs
- Grafana: https://grafana.yourdomain.com
- Prometheus: https://prometheus.yourdomain.com

## Common Alerts and Response Procedures

### HighErrorRate
**Severity:** Critical
**Meaning:** More than 5% of requests are returning 5xx errors

**Immediate actions:**
1. Check recent deployments: `kubectl rollout history deployment/myapp -n production`
2. Check application logs: `kubectl logs -n production -l app=myapp --tail=100`
3. Check database connectivity: `kubectl exec -n production deploy/myapp -- python manage.py dbshell -c "SELECT 1"`
4. If deployment caused it: `kubectl rollout undo deployment/myapp -n production`

**Escalate if:** Error rate above 20% or not resolved within 15 minutes

---

### PodCrashLooping
**Severity:** Critical
**Meaning:** A pod has restarted more than 5 times in the last hour

**Immediate actions:**
1. Check pod events: `kubectl describe pod POD_NAME -n production`
2. Check crash logs: `kubectl logs POD_NAME -n production --previous`
3. Check resource limits (OOMKilled): `kubectl describe pod POD_NAME | grep -i oom`
4. Check image: `kubectl get pod POD_NAME -o jsonpath='{.spec.containers[0].image}'`

**Escalate if:** All replicas are crash-looping

EOF

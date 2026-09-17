#!/usr/bin/env bash
set -euo pipefail

# Setup (do this first on exam day too)
alias k=kubectl
source <(kubectl completion bash)
complete -o default -F __start_kubectl k

export do="--dry-run=client -o yaml"

# --- DRILL 1 (Target: 2 min) ---
# Create a Pod named 'web' using nginx:1.25
# Labels: app=web, env=prod
# Port: 80
k run web --image=nginx:1.25 --port=80 --labels=app=web,env=prod

# Verify
k get pod web --show-labels

# --- DRILL 2 (Target: 2 min) ---
# Create a Deployment 'api' with 3 replicas of python:3.12-slim
# Namespace: staging
k create deployment api --image=python:3.12-slim --replicas=3 -n staging

# --- DRILL 3 (Target: 3 min) ---
# Create a ConfigMap 'app-config' in namespace 'production'
# Keys: LOG_LEVEL=info, MAX_CONNECTIONS=100
k create configmap app-config \
  --from-literal=LOG_LEVEL=info \
  --from-literal=MAX_CONNECTIONS=100 \
  -n production

# Verify
k get configmap app-config -n production -o yaml

# --- DRILL 4 (Target: 3 min) ---
# Create a Secret 'db-credentials' in namespace 'production'
# Keys: username=admin, password=s3cr3t
k create secret generic db-credentials \
  --from-literal=username=admin \
  --from-literal=password=s3cr3t \
  -n production

# --- DRILL 5 (Target: 4 min) ---
# Create a ServiceAccount 'app-sa' in namespace 'production'
# Create a Role 'pod-reader' that can get, list, watch pods
# Bind the role to the service account
k create serviceaccount app-sa -n production
k create role pod-reader --verb=get,list,watch --resource=pods -n production
k create rolebinding app-sa-pod-reader \
  --role=pod-reader \
  --serviceaccount=production:app-sa \
  -n production

# Verify
k auth can-i get pods \
  --as=system:serviceaccount:production:app-sa \
  -n production

# --- DRILL 6 (Target: 4 min) ---
# Drain node worker-1 safely (ignore daemonsets)
k drain worker-1 --ignore-daemonsets --delete-emptydir-data

# Uncordon after maintenance
k uncordon worker-1

# --- DRILL 7 (Target: 5 min) ---
# Back up etcd to /tmp/etcd-backup.db
ETCDCTL_API=3 etcdctl snapshot save /tmp/etcd-backup.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

# Verify the backup
ETCDCTL_API=3 etcdctl snapshot status /tmp/etcd-backup.db --write-out=table

# --- DRILL 8 (Target: 5 min) ---
# Upgrade node worker-1 from 1.28 to 1.29
# (kubeadm must already be at 1.29)
k drain worker-1 --ignore-daemonsets
ssh worker-1 "sudo apt-get install -y kubeadm=1.29.0-00 && \
              sudo kubeadm upgrade node && \
              sudo apt-get install -y kubelet=1.29.0-00 kubectl=1.29.0-00 && \
              sudo systemctl daemon-reload && \
              sudo systemctl restart kubelet"
k uncordon worker-1
k get nodes  # Verify version updated

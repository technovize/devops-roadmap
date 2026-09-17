#!/usr/bin/env bash
set -euo pipefail

# -- Exam day speed commands -------------------------------------------------

# Set up kubectl alias and autocompletion (do this first in the exam)
alias k=kubectl
source <(kubectl completion bash)
complete -o default -F __start_kubectl k

# Context switching (the exam uses multiple clusters)
kubectl config get-contexts
kubectl config use-context cluster1

# Generate resource YAML without applying (faster than writing from scratch)
kubectl run nginx --image=nginx --dry-run=client -o yaml > pod.yaml
kubectl create deployment my-dep --image=nginx --replicas=3 --dry-run=client -o yaml
kubectl create service clusterip my-svc --tcp=80:8080 --dry-run=client -o yaml

# Quickly find and edit resources
kubectl get all -n kube-system
kubectl edit deployment my-app -n production

# Troubleshooting workflow
kubectl describe pod <pod-name> -n <namespace>     # Events section first
kubectl logs <pod-name> -n <namespace> --previous  # Previous container logs
kubectl exec -it <pod-name> -- bash                # Shell into container

# etcd backup (common exam task)
ETCDCTL_API=3 etcdctl snapshot save /tmp/etcd-backup.db \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key

# Cluster upgrade with kubeadm
kubectl drain <node> --ignore-daemonsets --delete-emptydir-data
apt-get install -y kubeadm=1.30.0-00
kubeadm upgrade node
apt-get install -y kubelet=1.30.0-00 kubectl=1.30.0-00
systemctl daemon-reload && systemctl restart kubelet
kubectl uncordon <node>

# RBAC — create a role and bind it
kubectl create role pod-reader \
  --verb=get,list,watch \
  --resource=pods \
  -n production

kubectl create rolebinding read-pods \
  --role=pod-reader \
  --serviceaccount=production:my-sa \
  -n production

# Verify RBAC permissions
kubectl auth can-i get pods --as=system:serviceaccount:production:my-sa -n production

# NetworkPolicy — test with a temporary pod
kubectl run test-pod --image=busybox --rm -it --restart=Never -- wget -qO- http://my-service:80

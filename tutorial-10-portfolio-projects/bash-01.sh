#!/usr/bin/env bash
set -euo pipefail

# Cloud Infrastructure Platform

[![Terraform](https://img.shields.io/badge/terraform-1.7.x-purple)](https://terraform.io)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![CI/CD](https://github.com/myorg/cloud-infra-platform/actions/workflows/terraform.yml/badge.svg)](...)

> Production-ready AWS infrastructure for a containerized Django application,
> provisioned with Terraform, orchestrated with EKS, observed with Prometheus
> and Grafana, and deployed via GitOps with ArgoCD.

## Architecture

[INSERT ARCHITECTURE DIAGRAM HERE]

The platform provisions:
- **VPC** with public/private subnets across 3 Availability Zones
- **EKS cluster** with managed node groups and Cluster Autoscaler
- **RDS PostgreSQL 16** (Multi-AZ in production) with automated backups
- **ElastiCache Redis** for session and task queue caching
- **Application Load Balancer** with ACM-managed TLS certificates
- **S3 + CloudFront** for static asset delivery

## Why These Choices?

**Terraform over CloudFormation:** Multi-cloud portability and the richer
module ecosystem (terraform-aws-modules/eks) significantly reduced
implementation time compared to raw CloudFormation. See
[ADR-001](docs/adr/001-use-terraform.md) for the full rationale.

**EKS over ECS:** Kubernetes provides a portable, provider-agnostic
orchestration layer. The team's existing Kubernetes expertise and the
availability of Helm charts for all required components made EKS the
clear choice. See [ADR-002](docs/adr/002-eks-vs-ecs.md).

## Quick Start

### Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform >= 1.7.0
- kubectl >= 1.29
- helm >= 3.14

### Deploy to Staging

```bash
# Clone the repository
git clone https://github.com/myorg/cloud-infra-platform.git
cd cloud-infra-platform

# Configure AWS credentials
export AWS_PROFILE=myapp-staging

# Initialize Terraform
cd terraform/environments/staging
terraform init

# Review the plan
terraform plan -var-file=staging.tfvars

# Apply (creates all infrastructure — takes ~15 minutes)
terraform apply -var-file=staging.tfvars

# Configure kubectl
aws eks update-kubeconfig --name myapp-staging --region us-east-1

# Verify nodes are ready
kubectl get nodes

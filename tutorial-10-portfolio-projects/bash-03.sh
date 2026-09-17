#!/usr/bin/env bash
set -euo pipefail

# Create the special repository that becomes your GitHub profile README
# Repository must be named exactly: YOUR_GITHUB_USERNAME

# 1. Create on GitHub: github.com/new
#    Repository name: your-exact-username
#    Visibility: Public
#    Initialize with README

# 2. Clone and edit locally
git clone https://github.com/YOUR_USERNAME/YOUR_USERNAME.git
cd YOUR_USERNAME

# 3. Create your profile README using this template:
cat > README.md << 'PROFILE_EOF'
# :wave: Hi, I'm [Your Name]

> DevOps Engineer | Cloud Infrastructure | Container Orchestration | CI/CD Automation

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Connect-blue)](https://linkedin.com/in/yourprofile)
[![Blog](https://img.shields.io/badge/Blog-Read-orange)](https://yourblog.com)

---

## :hammer_and_wrench: Tech Stack

**Cloud:** AWS · Azure · GCP
**IaC:** Terraform · CloudFormation
**Containers:** Docker · Kubernetes · Helm
**CI/CD:** GitHub Actions · GitLab CI · Jenkins · ArgoCD
**Observability:** Prometheus · Grafana · Loki · OpenTelemetry
**Security:** Trivy · Checkov · Falco · OPA/Gatekeeper
**Languages:** Python · Bash · Go (learning)

---

## :rocket: Portfolio Projects

| Project | Stack | Status |
|---------|-------|--------|
| [Production AWS Infrastructure](https://github.com/you/cloud-infra) | Terraform · EKS · RDS · ALB | (yes) Live |
| [CI/CD Pipeline Template](https://github.com/you/cicd-template) | GitHub Actions · Docker · Trivy | (yes) Live |
| [Observability Stack](https://github.com/you/observability-stack) | Prometheus · Grafana · Loki · Tempo | (yes) Live |
| [Django GitOps App](https://github.com/you/django-gitops) | Django · ArgoCD · Kubernetes | (yes) Live |

---

## :chart_with_upwards_trend: GitHub Stats

![Stats](https://github-readme-stats.vercel.app/api?username=YOUR_USERNAME&show_icons=true&theme=dark)

---

## :memo: Latest Blog Posts
<!-- BLOG-POST-LIST:START -->
<!-- BLOG-POST-LIST:END -->

PROFILE_EOF

git add README.md
git commit -m "feat: add portfolio profile README"
git push origin main

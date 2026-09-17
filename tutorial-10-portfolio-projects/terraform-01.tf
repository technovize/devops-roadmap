### 3.2 Core Implementation

```hcl
# terraform/modules/eks/main.tf

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "${var.project_name}-${var.environment}"
  cluster_version = "1.29"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # Allow kubectl from within the VPC only
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access_cidrs = var.allowed_cidr_blocks

  # Enable IRSA — pods can assume IAM roles without node-level credentials
  enable_irsa = true

  # Managed node groups — AWS handles node OS patching
  eks_managed_node_groups = {
    general = {
      name           = "general"
      instance_types = [var.node_instance_type]
      min_size       = 2
      max_size       = 10
      desired_size   = var.node_desired_count

      # Use bottlerocket for improved security (immutable OS, minimal attack surface)
      ami_type = "BOTTLEROCKET_x86_64"

      labels = {
        Environment = var.environment
        NodeGroup   = "general"
      }

      taints = []

      block_device_mappings = {
        xvda = {
          device_name = "/dev/xvda"
          ebs = {
            volume_size           = 50
            volume_type           = "gp3"
            encrypted             = true
            delete_on_termination = true
          }
        }
      }
    }
  }

  # Cluster addons — managed by AWS
  cluster_addons = {
    coredns = {
      most_recent = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      most_recent    = true
      before_compute = true   # Must be installed before nodes join
      configuration_values = jsonencode({
        env = {
          ENABLE_PREFIX_DELEGATION = "true"   # More IPs per node
          WARM_PREFIX_TARGET       = "1"
        }
      })
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
  }

  tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# IRSA role for the EBS CSI driver
module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "${var.project_name}-${var.environment}-ebs-csi"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}

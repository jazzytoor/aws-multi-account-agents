module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  count = var.stack == "eks" ? 1 : 0

  name               = var.service
  kubernetes_version = "1.34"

  endpoint_public_access                   = true
  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  access_entries = {
    root = {
      principal_arn = "arn:aws:iam::${data.aws_caller_identity.this.account_id}:root"
      policy_associations = {
        default = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            type = "cluster"
          }
        }
      }
    }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.subnets

  eks_managed_node_groups = {
    default = {
      min_size     = 1
      max_size     = 3
      desired_size = 1

      attach_cluster_primary_security_group = true
      instance_types                        = ["t3.small"]
      capacity_type                         = "ON_DEMAND"

      subnet_ids = var.subnets

      iam_role_additional_policies = {
        ecr = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
        ssm = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
      }
    }
  }

  addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    eks-pod-identity-agent = {
      before_compute = true
    }
  }

  tags = local.default_tags
}

resource "helm_release" "keda" {
  count = var.stack == "eks" ? 1 : 0

  name       = "keda"
  repository = "https://kedacore.github.io/charts"
  chart      = "keda"
  namespace  = "keda"

  create_namespace = true

  depends_on = [module.eks]
}

resource "helm_release" "ado" {
  count = var.stack == "eks" ? 1 : 0

  name      = "ado"
  chart     = "${path.module}/workloads/ado-agent/chart"
  namespace = "ado"

  create_namespace = true

  set = [
    {
      name  = "image.repository"
      value = split(":", docker_registry_image.ado.name)[0]
    },
    {
      name  = "image.tag"
      value = split(":", docker_registry_image.ado.name)[1]
    },
    {
      name  = "global.pool"
      value = var.ado["AZP_POOL"]
    },
    {
      name  = "global.url"
      value = var.ado["AZP_URL"]
    },
    {
      name  = "global.token"
      value = var.ado["AZP_TOKEN"]
    },
    {
      name  = "global.stack"
      value = var.ado["AZP_STACK"]
    }
  ]

  depends_on = [module.eks, helm_release.keda]
}

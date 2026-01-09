include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = var.region

  assume_role {
    role_arn = format("arn:aws:iam::%v:role/OrganizationAccountAccessRole", var.spoke_account_id)
  }
}

provider "docker" {
  registry_auth {
    address  = format("%v.dkr.ecr.%v.amazonaws.com", data.aws_caller_identity.this.account_id, var.region)
    username = data.aws_ecr_authorization_token.token.user_name
    password = data.aws_ecr_authorization_token.token.password
  }
}

%{ if include.root.locals.variables.stack == "eks" }
provider "helm" {
  kubernetes = {
    host                   = module.eks[0].cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks[0].cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks[0].token
  }
}
%{ endif }
EOF
}

dependency "hub" {
  config_path = "../hub"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
    subnets = ["subnet-00000000000000000"]
    vpc_id  = "vpc-00000000000000000"
  }
}

terraform {
  source = "./"
}

inputs = {
  subnets          = dependency.hub.outputs.subnets
  spoke_account_id = include.root.locals.variables.spoke_account_id
  ado              = include.root.locals.variables.ado
  vpc_id           = dependency.hub.outputs.vpc_id
  stack            = include.root.locals.variables.stack
}

include "root" {
  path = find_in_parent_folders("root.hcl")
  expose = true
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOF
provider "aws" {
  region = "${include.root.locals.region}"

  assume_role {
    role_arn = "arn:aws:iam::${include.root.locals.spoke_account_id}:role/OrganizationAccountAccessRole"
  }
}
EOF
}

dependency "hub" {
  config_path = "../hub"
  mock_outputs_allowed_terraform_commands = ["init", "validate", "plan"]
  mock_outputs = {
    ram_shared_resources = {
      subnets        = ["subnet-00000000000000000"]
      security_group = "sg-00000000000000000"
    }
  }
}

terraform {
  source = "./"
}

inputs = {
  private_subnets = dependency.hub.outputs.ram_shared_resources.subnets
  security_group = [dependency.hub.outputs.ram_shared_resources.security_group]
  create_security_group = dependency.hub.outputs.ram_shared_resources.security_group == "sg-00000000000000000" ? false : true
}

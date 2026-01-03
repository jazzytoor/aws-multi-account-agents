locals {
  variables = jsondecode(read_tfvars_file("${get_parent_terragrunt_dir()}/variables.auto.tfvars"))
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  backend "s3" {
    bucket         = "${local.variables.bucket}"
    key            = "terraform/${local.variables.service}/${path_relative_to_include()}/terraform.tfstate"
    region         = "${local.variables.region}"
    encrypt        = true
  }
}
EOF
}

inputs = {
  service = local.variables.service,
  region  = local.variables.region
}

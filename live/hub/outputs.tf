output "ram_shared_resources" {
  value = {
    subnets = [
      for arn in module.vpc.private_subnet_arns :
      element(split("/", arn), length(split("/", arn)) - 1)
    ]

    security_group = element(
      split("/", module.sg.security_group_arn),
      length(split("/", module.sg.security_group_arn)) - 1
    )
  }
}

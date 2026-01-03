data "aws_ssm_parameter" "ecs_optimized_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended"
}

data "aws_caller_identity" "this" {}

data "aws_ecr_authorization_token" "token" {}

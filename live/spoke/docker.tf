resource "docker_image" "ado" {
  name = "${module.ecr.repository_url}:latest"
  build {
    context    = var.build_context
    dockerfile = "Dockerfile"
  }
  platform = "linux/arm64"
}

resource "docker_registry_image" "ado" {
  name = docker_image.ado.name
}

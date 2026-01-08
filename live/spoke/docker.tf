resource "docker_image" "ado" {
  name = "${module.ecr.repository_url}:latest"
  build {
    context    = "${path.module}/workloads/ado-agent/docker"
    dockerfile = "${path.module}/workloads/ado-agent/docker/Dockerfile"
  }
  platform = "linux/arm64"
}

resource "docker_registry_image" "ado" {
  name = docker_image.ado.name
}

resource "docker_image" "ado" {
  name = "${module.ecr.repository_url}:latest"
  build {
    context    = "workloads/ado-agent"
    dockerfile = "workloads/ado-agent/Dockerfile"
  }
  platform = "linux/arm64"
}

resource "docker_registry_image" "ado" {
  name = docker_image.ado.name
}

data "docker_registry_image" "node-14-slim" {
  name = "node:14-slim"
}

resource "docker_image" "helloworld" {
  name = "helloworld"
  force_remove = true
  keep_locally = false
  pull_triggers = [data.docker_registry_image.node-14-slim.sha256_digest]
  build {
    path = "./service"
    tag = "helloworld:latest"
  }
}

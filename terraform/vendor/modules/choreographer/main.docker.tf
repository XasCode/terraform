// data "docker_registry_image" "node-14-slim" {
//   name = "node:14-slim"
// }

resource "null_resource" "docker" {
    provisioner "local-exec" {
    command = <<EOH
curl https://get.docker.com/rootless --output rootless.sh
chmod +x rootless.sh
sh ./rootless.sh
EOH
  }
}


resource "docker_image" "helloworld" {
  name = "helloworld"
  force_remove = true
  keep_locally = false
  // pull_triggers = [data.docker_registry_image.node-14-slim.sha256_digest]
  build {
    path = "./service"
    tag = ["helloworld:latest"]
  }

  depends_on = [null_resource.docker]
}

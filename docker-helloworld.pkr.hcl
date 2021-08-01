packer {
  required_plugins {
    docker = {
      version = ">= 0.0.7"
      source  = "github.com/hashicorp/docker"
    }
  }
}

source "docker" "helloworld" {
  image  = "node:14-slim"
  commit = true
  changes = [
    "WORKDIR /usr/src/app",
    "CMD [\"node\", \"index.js;\"]"
  ]
}

build {
  name = "helloworld"
  sources = [
    "source.docker.helloworld"
  ]

  provisioner "file" {
    source      = "./service"
    destination = "/usr/src/app"
  }

  provisioner "shell" {
    inline = [
      "cd /usr/src/app",
      "npm install --only=production"
    ]
  }

  post-processors {
    post-processor "docker-import" {
        repository =  "myrepo/myimage"
        tag = ["latest"]
      }
    post-processor "docker-push" {}
  }
}

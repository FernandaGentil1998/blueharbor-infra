terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {}
variable "env" {
  description = "Deployment environment"
  type        = string
  default     = "dev"

  validation {
    condition     = contains(["dev", "test", "prod"], var.env)
    error_message = "Environment must be dev, test, or prod."
  }
}

variable "web_count" {
  description = "Number of web containers"
  type        = number
  default     = 2
}

variable "owner" {
  description = "Resource owner"
  type        = string
}
resource "docker_network" "app_network" {
  name = "bh-${var.env}-net"
}

resource "docker_image" "nginx" {
  name         = "nginx:1.27-alpine"
  keep_locally = true
}
resource "docker_container" "web" {
  count = var.web_count

  name  = "bh-web-${var.env}-${count.index + 1}"
  image = docker_image.nginx.image_id

  networks_advanced {
    name = docker_network.app_network.name
  }

  ports {
    internal = 80
    external = 8080 + count.index
  }

  labels {
    label = "owner"
    value = var.owner
  }
}
output "web_urls" {
  description = "URLs of the deployed web containers"
  value = [
    for i in range(var.web_count) :
    "http://localhost:${8080 + i}"
  ]
}
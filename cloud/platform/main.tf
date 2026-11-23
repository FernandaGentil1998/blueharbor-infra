terraform {
  required_providers {
    vercel = {
      source = "vercel/vercel"
    }
  }
}

provider "vercel" {}

variable "github_repo" {
  type        = string
  description = "owner/name of the GitHub repository"
}

variable "initials" {
  type = string

  validation {
    condition     = can(regex("^[a-z]{2,3}$", var.initials))
    error_message = "initials: 2 or 3 lower-case letters."
  }
}

variable "region" {
  type    = string
  default = "eu-west-3"

  validation {
    condition     = contains(["eu-west-3", "eu-central-1"], var.region)
    error_message = "Only EU regions are allowed for BlueHarbor data."
  }
}

resource "vercel_project" "trackit" {
  name           = "bh-trackit-${lower(var.initials)}"
  root_directory = "trackit"

  git_repository = {
    type              = "github"
    repo              = var.github_repo
    production_branch = "main"
  }
}

resource "vercel_project_environment_variable" "version" {
  project_id = vercel_project.trackit.id
  key        = "APP_VERSION"
  value      = "1.1.0"
  sensitive  = false
  target     = ["production", "preview"]
}

output "project_id" {
  value = vercel_project.trackit.id
}
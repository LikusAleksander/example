terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
  }
}

provider "github" {
  token = var.github_token
}

variable "github_token" {}

resource "github_repository" "example" {
  name        = "example"
  description = "My awesome codebase"
  visibility  = "public"
}

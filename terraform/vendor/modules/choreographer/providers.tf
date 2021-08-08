terraform {
  required_providers {
    github = {
      source  = "integrations/github"
    }
    archive = {
      source = "hashicorp/archive"
    }
    tfe = {
      source = "hashicorp/tfe"
    }
    google-beta = {
      source = "hashicorp/google-beta"
    }
  }
}

provider "github" {
  token = var.gh_token
  owner = var.gh_org
}

provider "tfe" {
  token    = var.tf_token
}

provider "google-beta" {
  project = module.project.id
}
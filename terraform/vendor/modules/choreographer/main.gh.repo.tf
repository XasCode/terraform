resource "github_repository" "repository" {
  count = var.environment == "devl" ? length(var.managed) : 0

  name             = var.managed[count.index].name
  description      = "Automated"

  visibility       = "public"
  has_issues       = false
  has_projects     = false
  has_wiki         = false
  is_template      = false
  has_downloads    = false
  auto_init        = true
  license_template = "mit"
}

data "github_repository" "repository" {
  count      = contains(var.envs, var.environment) ? length(var.managed) : 0

  full_name  = "${var.gh_org}/${var.managed[count.index].name}"

  depends_on = [github_repository.repository]
}

resource "github_repository_file" "gh_repo_file_keep" {
  count               = contains(var.envs, var.environment) ? length(var.managed) : 0

  repository          = data.github_repository.repository[count.index].name
  branch              = local.branch
  file                = "src/.keep"
  content             = <<-EOT

    EOT
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@xascode.dev"
  overwrite_on_create = true
}

resource "github_repository_file" "gh_repo_file_variables" {
  count               = contains(var.envs, var.environment) ? length(var.managed) : 0

  repository          = data.github_repository.repository[count.index].name
  branch              = local.branch
  file                = "terraform/variables.tf"
  content             = <<-EOT
    variable "project" {
      type = object({
        path   = string
        name   = string
        id     = string
        number = string
      })
    }

    variable "environment" {
      type = string
    }
    EOT
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@xascode.dev"
  overwrite_on_create = true
}

resource "github_repository_file" "gh_repo_file_locals" {
  count               = contains(var.envs, var.environment) ? length(var.managed) : 0

  repository          = data.github_repository.repository[count.index].name
  branch              = local.branch
  file                = "terraform/locals.tf"
  content             = <<-EOT
    locals {
      project = var.project.id
      branch  = var.environment == "devl" ? "main" : var.environment
    }
    EOT
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@xascode.dev"
  overwrite_on_create = true
}

resource "github_repository_file" "gh_repo_file_archive" {
  count               = contains(var.envs, var.environment) ? length(var.managed) : 0

  repository          = data.github_repository.repository[count.index].name
  branch              = local.branch
  file                = "terraform/main.archive.tf"
  content             = <<-EOT
    data "archive_file" "srcfiles" {
      type        = "zip"
      output_path = "src.zip"
      source_dir  = "../src"
    }

    resource "google_storage_bucket_object" "archive" {
      name   = "src-$${filemd5(data.archive_file.srcfiles.output_path)}.zip"
      bucket = "${google_storage_bucket.bucket[count.index].name}"
      source = data.archive_file.srcfiles.output_path
    }
    EOT
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@xascode.dev"
  overwrite_on_create = true

  depends_on = [ github_repository_file.gh_repo_file_keep, github_repository_file.gh_repo_file_archive ]
}

resource "github_branch" "branch" {
  count      = contains(var.envs, var.environment) ? var.environment == "devl" ? 0 : length(var.managed) : 0
  repository = data.github_repository.repository[count.index].name
  branch     = local.branch
}

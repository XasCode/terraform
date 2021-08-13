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
  count = length(var.managed)

  full_name = "${var.gh_org}/${var.managed[count.index].name}"

  depends_on = [github_repository.repository]
}

resource "github_repository_file" "gh_repo_file_keep" {
  count = length(var.managed)

  repository          = data.github_repository.repository.name
  branch              = local.branch
  file                = "src/.keep"
  content             = <<-EOT

    EOT
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@xascode.dev"
  overwrite_on_create = true
}

resource "github_repository_file" "gh_repo_file_locals" {
  count = length(var.managed)

  repository          = data.github_repository.repository.name
  branch              = local.branch
  file                = "terraform/locals.tf"
  content             = <<-EOT
    locals {
      project = ${var.managed[count.index].id}
    }
    EOT
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@xascode.dev"
  overwrite_on_create = true
}

resource "github_repository_file" "gh_repo_file_archive" {
  count = length(var.managed)

  repository          = data.github_repository.repository.name
  branch              = local.branch
  file                = "terraform/main.archive.tf"
  content             = <<-EOT
    data "archive_file" "srcfiles" {
      type        = "zip"
      output_path = "src.zip"
      source_dir  = "./src"
    }

    resource "google_storage_bucket_object" "archive" {
      name   = "src-$${filemd5(data.archive_file.srcfiles.output_path)}.zip"
      bucket = ${google_storage_bucket.bucket.name}
      source = data.archive_file.srcfiles.output_path
    }
    EOT
  commit_message      = "Managed by Terraform"
  commit_author       = "Terraform User"
  commit_email        = "terraform@xascode.dev"
  overwrite_on_create = true

  depends_on = [ github_repository_file.gh_repo_file_keep, github_repository_file.gh_repo_file_archive ]
}

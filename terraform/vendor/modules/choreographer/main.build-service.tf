resource "google_cloudbuild_trigger" "choreographer-trigger" {
  count        = contains(var.envs, var.environment) ? 1 : 0

  project = module.project.id

  trigger_template {
    branch_name = local.branch
    repo_name   = "${var.gh_org}/infrastructure"
    project_id = module.project.id
  }

  build {
    step {
      id = "0"
      name = "gcr.io/cloud-builders/gcloud"
      args = [
        "build", 
        "-t", 
        "gcr.io/${module.project.id}/choreographer-run-${var.environment}", 
        "./service"
      ]
      images = [
        "gcr.io/${module.project.id}/choreographer-run-${var.environment}",
      ]
      timeout = "120s"
    }
  }

  depends_on = [ google_project_service.cloud_build[0] ]
}

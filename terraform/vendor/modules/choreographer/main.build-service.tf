resource "google_cloudbuild_trigger" "build-trigger" {
  count        = contains(var.envs, var.environment) ? 1 : 0

  project = module.project.id

  trigger_template {
    branch_name = local.branch
    repo_name   = google_sourcerepo_repository.choreographer-repo[count.index].name
    project_id = module.project.id
  }

  build {
    step {
      id = "0"
      name = "gcr.io/cloud-builders/gcloud"
      entrypoint = "bash"
      args = [
        "-c",
        "cd terraform/vendor/modules/choreographer/service && gcloud builds submit --tag gcr.io/${module.project.id}/helloworld"
      ]
      timeout = "30s"
    }
    step {
      id = "1"
      name = "gcr.io/cloud-builders/gcloud"
      entrypoint = "bash"
      args = [
        "-c",
        "cd terraform/vendor/modules/choreographer/service && gcloud run deploy helloworld --region=us-central1 --allow-unauthenticated --image gcr.io/${module.project.id}/helloworld"
      ]
      timeout = "30s"
      wait_for = ["0"]
    }
  }

  depends_on = [ google_project_service.cloud_build[0], null_resource.init_empty_repo[0] ]
}

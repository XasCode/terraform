resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv"
  location = "us-central1"
  project  = module.project.id

  template {
    spec {
      containers {
        image = "gcr.io/${module.project.id}/choreographer-run-${var.environment}"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

    depends_on = [ google_project_service.run[0] ]
}

resource "google_cloud_run_service_iam_binding" "binding" {
  location = google_cloud_run_service.default.location
  project = google_cloud_run_service.default.project
  service = google_cloud_run_service.default.name
  role = "roles/run.invoker"
  members = [
    "allUsers",
  ]
}
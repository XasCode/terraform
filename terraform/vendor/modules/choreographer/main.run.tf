resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv"
  location = "us-central1"
  project  = var.project.id

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
}

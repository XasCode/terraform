resource "google_secret_manager_secret" "secret-basic" {
  count       = contains(var.envs, var.environment) ? 1 : 0

  secret_id = "BUILD_API_KEY"
  project = module.project.id
  replication {
    automatic = true
  }

  depends_on = [google_project_service.secretmanager[0]]
}


resource "google_secret_manager_secret_version" "secret-version-basic" {
  count       = contains(var.envs, var.environment) ? 1 : 0

  secret = google_secret_manager_secret.secret-basic[count.index].id
  secret_data = var.build

  depends_on = [google_project_service.secretmanager[0]]
}

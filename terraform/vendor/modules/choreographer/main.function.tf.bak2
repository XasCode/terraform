/*
resource "google_cloudfunctions_function" "function-choreographer" {
  count        = contains(var.envs, var.environment) ? 1 : 0

  name        = "function-${module.project.name}-${random_id.random.hex}"
  description = "function-${module.project.name}-${random_id.random.hex}"
  runtime     = "nodejs14"
  project     = module.project.id
  region      = "us-east1"
  available_memory_mb   = 256
  timeout               = 60
  source_archive_bucket = google_storage_bucket.bucket[count.index].name
  source_archive_object = google_storage_bucket_object.archive[count.index].name
  service_account_email = google_service_account.svc-choreographer[count.index].email
  trigger_http          = true
  entry_point           = "helloGET"

  depends_on = [google_project_service.cloud_functions[0]] #, google_project_service.cloud_build]
}
*/
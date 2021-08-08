resource "google_container_registry" "registry" {
  project  = module.project.id
  location = "US"

  depends_on = [google_project_service.containerregistry[0]]
}

// resource "google_storage_bucket_iam_member" "viewer" {
//   bucket = google_container_registry.registry.id
//   role = "roles/storage.objectViewer"
//  member = "user:jane@example.com"
//}

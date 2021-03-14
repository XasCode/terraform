output "shared_infrastructure" {
  value = google_folder.shared_infrastructure.folder_id
}

resource "google_folder" "shared_infrastructure" {
  display_name = "shared_infrastructure"
  parent       = "organizations/${var.organization_id}"
}

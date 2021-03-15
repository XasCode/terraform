resource "google_folder" "shared" {
  display_name = "Shared"
  parent       = "organizations/${var.organization_id}"
}

output "shared" {
  value = google_folder.shared.folder_id
}

output "shared-backups" {
  value = google_folder.shared-backups.folder_id
}

output "shared-backups-test" {
  value = google_folder.shared-backups-test.folder_id
}

resource "google_folder" "shared-backups-prod" {
  display_name = "Prod"
  parent       = "folders/${google_folder.shared-backups.folder_id}"
}

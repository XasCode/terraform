variable "organization_name" {
  type = string
}

variable "organization_id" {
  type = string
}

variable "billing_account" {
  type = string
}

resource "google_folder" "shared_infrastructure" {
  display_name = "Shared"
  parent       = "organizations/${var.organization_id}"
}

  resource "google_folder" "shared-backups" {
    display_name = "Backups"
    parent       = "folders/${google_folder.shared_infrastructure.folder_id}"
  }

    resource "google_folder" "shared-backups-test" {
      display_name = "Test"
      parent       = "folders/${google_folder.shared-backups.folder_id}"
    }

output "shared_infrastructure" {
  value = google_folder.shared_infrastructure.folder_id
}

variable "organization_name" {
  type = string
}

variable "organization_id" {
  type = string
}

variable "billing_account" {
  type = string
}

resource "google_folder" "shared" {
  display_name = "Shared"
  parent       = "organizations/${var.organization_id}"
}

  resource "google_folder" "shared-backups" {
    display_name = "Backups"
    parent       = "folders/${google_folder.shared.folder_id}"
  }

    resource "google_folder" "shared-backups-test" {
      display_name = "Test"
      parent       = "folders/${google_folder.shared-backups.folder_id}"
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

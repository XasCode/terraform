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
  display_name = "shared_infrastructure"
  parent       = "organizations/${var.organization_id}"
}

output "shared_infrastructure" {
  value = google_folder.shared_infrastructure.folder_id
}

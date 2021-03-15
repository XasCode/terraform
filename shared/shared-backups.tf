resource "google_folder" "shared-backups" {
  display_name = "Backups"
  parent       = "folders/${google_folder.shared.folder_id}"
}

resource "random_id" "project" {
  byte_length = 3
}

module "validator" {
  source = "./modules/"

  args = {
    project_name      = "backups-test2"
    organization_name = var.organization_name
  }
}

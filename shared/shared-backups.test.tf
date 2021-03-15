resource "google_folder" "shared-backups-test" {
  display_name = "Test"
  parent       = "folders/${google_folder.shared-backups.folder_id}"
}

resource "google_project" "backups-test" {
    auto_create_network = false
    billing_account     = var.billing_account
    folder_id           = google_folder.shared-backups-test.folder_id
    labels              = {}
    name                = "${var.organization_name}-backups-test"
    project_id          = "${var.organization_name}-backups-test-${random_id.project.hex}"
    timeouts {}
}

resource "google_project" "test1-test" {
    auto_create_network = false
    billing_account     = var.billing_account
    folder_id           = google_folder.shared-backups-test.folder_id
    labels              = {}
    name                = "${var.organization_name}-backups-test1"
    project_id          = "${var.organization_name}-backups-test1-${random_id.project.hex}"
    timeouts {}
}

resource "google_project" "test2-test" {
    auto_create_network = false
    billing_account     = var.billing_account
    folder_id           = google_folder.shared-backups-test.folder_id
    labels              = {}
    name                = "${var.organization_name}-backups-test2"
    project_id          = "${var.organization_name}-backups-test2-${random_id.project.hex}"
    timeouts {}
}

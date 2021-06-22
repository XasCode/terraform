resource "random_id" "project" {
  byte_length = 3
}

module "prj_container" {
  source = "./vendor/modules/folder"
  
  name   = var.name
  parent = var.parent
}

resource "google_project" "project" {
    auto_create_network = false
    billing_account     = var.billing_account
    folder_id           = module.prj_container.name
    labels              = {}
    name                = var.name
    project_id          = "${var.name}-${random_id.project.hex}"
    timeouts {}
}

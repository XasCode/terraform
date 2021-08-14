resource "google_service_account" "terraform_account" {
  count        = contains(var.envs, var.environment) ? length(var.managed) : 0
  project      = var.managed[count.index].id
  account_id   = "terraform-sa-${var.managed[count.index].name}"
  display_name = "terraform-sa-${var.managed[count.index].name}"
}

resource "google_service_account_key" "mykey" {
  count              = contains(var.envs, var.environment) ? length(var.managed) : 0
  project            = var.managed[count.index].id
  service_account_id = google_service_account.terraform_account[count.index].name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

resource "google_project_iam_binding" "project" {
  count              = contains(var.envs, var.environment) ? length(var.managed) : 0
  project            = var.managed[count.index].id
  
  role    = "roles/editor"
  members = [
    "serviceAccount:${google_service_account.terraform_account[count.index].email}",
  ]
}
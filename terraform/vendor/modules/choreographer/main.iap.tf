resource "google_iap_web_backend_service_iam_binding" "binding" {
  project = module.project.id
  web_backend_service = google_compute_backend_service.default.name
  role = "roles/iap.httpsResourceAccessor"
  members = [
    "user:justin@xascode.dev",
  ]

  depends_on = [ google_project_service.iap[0] ]
}

resource "google_iap_brand" "project_brand" {
  support_email     = "orgadmins@xascode.dev"
  application_title = "XasCode"
  project           = module.project.id

  depends_on = [ google_project_service.iap[0] ]
}

resource "google_iap_client" "project_client" {
  display_name = "Test Client"
  brand        = google_iap_brand.project_brand.name

  depends_on = [ google_project_service.iap[0] ]
}
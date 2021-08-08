resource "google_dns_managed_zone" "xascode" {
  name        = "xascode"
  project     = module.project.id
  dns_name    = "xascode.dev."
  description = "Example DNS zone"
}

resource "google_dns_record_set" "api" {
  provider = google-beta
  project  = module.project.id
  managed_zone = google_dns_managed_zone.xascode.name
  name         = "api.xascode.dev."
  type         = "A"
  rrdatas      = [google_compute_global_address.default.address]
  ttl          = 86400
}

resource "google_compute_managed_ssl_certificate" "default" {
  provider = google-beta
  project  = module.project.id

  name = "cert"
  managed {
    domains = ["api.xascode.dev"]
  }
}

resource "google_compute_global_address" "default" {
  name = "lb-address"
  project = module.project.id
}

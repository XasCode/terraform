resource "google_compute_region_network_endpoint_group" "cloudrun_neg" {
  name                  = "cloudrun-neg"
  project               = module.project.id
  network_endpoint_type = "SERVERLESS"
  region                = "us-central1"
  cloud_run {
    service = google_cloud_run_service.default.name
  }
}

resource "google_compute_backend_service" "default" {
  provider = google-beta
  project                         = module.project.id
  name                            = "backend-service"
  enable_cdn                      = false
  protocol                        = "HTTP"
  port_name                       = "http"
  timeout_sec                     = 30
  // connection_draining_timeout_sec = 10

  // custom_request_headers          = ["host: ${google_compute_global_network_endpoint.proxy.fqdn}"]
  // custom_response_headers         = ["X-Cache-Hit: {cdn_cache_status}"]

  backend {
    group = google_compute_region_network_endpoint_group.cloudrun_neg.id
  }
}

resource "google_compute_url_map" "default" {
  name            = "urlmap"
  project         = module.project.id

  default_service = google_compute_backend_service.default.id
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

resource "google_compute_target_https_proxy" "default" {
  name    = "https-proxy"
  project = module.project.id

  url_map          = google_compute_url_map.default.id
  ssl_certificates = [
    google_compute_managed_ssl_certificate.default.id
  ]
}

resource "google_compute_global_forwarding_rule" "default" {
  name    = "lb"
  project = module.project.id

  target = google_compute_target_https_proxy.default.id
  port_range = "443"
  ip_address = google_compute_global_address.default.address
}

resource "google_dns_managed_zone" "xascode" {
  name        = "xascode"
  project     = module.project.id
  dns_name    = "xascode.dev."
  description = "Example DNS zone"
}

resource "google_dns_record_set" "api" {
  provider = "google-beta"
  project  = module.project.id
  managed_zone = google_dns_managed_zone.xascode.name
  name         = "api.xascode.dev."
  type         = "A"
  rrdatas      = [google_compute_global_address.default.address]
  ttl          = 86400
}
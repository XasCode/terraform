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
  // timeout_sec                     = 10
  connection_draining_timeout_sec = 10

  // custom_request_headers          = ["host: ${google_compute_global_network_endpoint.proxy.fqdn}"]
  // custom_response_headers         = ["X-Cache-Hit: {cdn_cache_status}"]

  backend {
    group = google_compute_region_network_endpoint_group.cloudrun_neg.id
  }
}

resource "google_project_service" "cloud_functions" {
  count        = contains(var.envs, var.environment) ? 1 : 0

  project = module.project.id
  service = "cloudfunctions.googleapis.com"
  timeouts {
    create = "3m"
    update = "6m"
  }
  disable_dependent_services = true
}

resource "google_project_service" "cloud_build" {
  count        = contains(var.envs, var.environment) ? 1 : 0

  project = module.project.id
  service = "cloudbuild.googleapis.com"
  timeouts {
    create = "3m"
    update = "6m"
  }
  disable_dependent_services = true
}

resource "google_project_service" "secretmanager" {
  count        = contains(var.envs, var.environment) ? 1 : 0

  project = module.project.id
  service = "secretmanager.googleapis.com"
  timeouts {
    create = "3m"
    update = "6m"
  }
  disable_dependent_services = true
}

resource "google_project_service" "sourcerepo" {
  count        = contains(var.envs, var.environment) ? 1 : 0

  project = module.project.id
  service = "sourcerepo.googleapis.com"
  timeouts {
    create = "3m"
    update = "6m"
  }
  disable_dependent_services = true
}

resource "google_project_service" "containerregistry" {
  count        = contains(var.envs, var.environment) ? 1 : 0

  project = module.project.id
  service = "containerregistry.googleapis.com"
  timeouts {
    create = "3m"
    update = "6m"
  }
  disable_dependent_services = true
}

resource "google_organization_iam_custom_role" "role-svc-choreographer" {
  count        = contains(var.envs, var.environment) ? 1 : 0

  role_id     = "role_svc_choreographer_${random_id.random.hex}"
  org_id      = var.organization_id
  title       = "role_svc_choreographer_${random_id.random.hex}"
  permissions = [
    "compute.projects.get",
    "secretmanager.versions.access",
    "secretmanager.locations.get",
    "secretmanager.locations.list",
    "secretmanager.secrets.get",
    "secretmanager.secrets.getIamPolicy",
    "secretmanager.secrets.list",
    "secretmanager.versions.get",
    "secretmanager.versions.list",
    "cloudbuild.builds.get",
    "cloudbuild.builds.list",
    "cloudbuild.builds.create",
  ]
}

resource "google_service_account" "svc-choreographer" {
  count        = contains(var.envs, var.environment) ? 1 : 0

  account_id   = "svc-choreographer-${random_id.random.hex}"
  display_name = "Service account for creating apis"
  project      = module.project.id
}

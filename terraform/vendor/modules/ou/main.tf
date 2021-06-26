module "ou" {
  source = "./vendor/modules/folder"
  
  name   = var.name
  parent = var.parent

  envs   = var.envs
  environment    = var.environment
}

module "terraform" {
  source = "./vendor/modules/project"
  
  name   = "terraform"
  parent = {
    name = module.ou.name
    path = module.ou.path
  }  

  billing_account = var.billing_account

  envs   = var.envs
  environment    = var.environment

  depends_on = [module.ou]
}

module "security" {
  source = "./vendor/modules/project"
  
  name   = "security"
  parent = {
    name = module.ou.name
    path = module.ou.path
  }

  billing_account = var.billing_account

  envs   = var.envs
  environment    = var.environment

  depends_on = [module.ou]
}

module "snapshots" {
 source = "./vendor/modules/project"
  
  name   = "snapshots"
  parent = {
    name = module.ou.name
    path = module.ou.path
  }

  billing_account = var.billing_account

  envs   = var.envs
  environment    = var.environment

  depends_on = [module.ou]
}

resource "random_id" "random" {
  byte_length = 3
}

resource "google_organization_iam_custom_role" "role-svc-check-snapshots" {
  role_id     = "role_svc_check_snapshots_${random_id.random.hex}"
  #project     = module.security.id
  org_id      = var.organization_id
  title       = "role_svc_check_snapshots_${random_id.random.hex}"
  description = "Role / permissions to assign to service account for automatically setting up disk snapshots."
  permissions = [
    "compute.disks.list",
    "compute.snapshots.list",
    "compute.instances.list",
    "compute.regions.list",
    "compute.zones.list",
    "compute.disks.addResourcePolicies",
    "compute.resourcePolicies.create",
    "compute.resourcePolicies.get",
    "compute.resourcePolicies.list",
    "compute.resourcePolicies.use",
    "resourcemanager.organizations.get",
    "resourcemanager.folders.get",
    "resourcemanager.folders.list",
    "resourcemanager.projects.get",
    "resourcemanager.projects.list",
    "storage.objects.create"
  ]

  depends_on = [module.security]
}

resource "google_service_account" "svc-check-snapshots" {
  account_id   = "svc-check-snapshots-${random_id.random.hex}"
  display_name = "Service account for automatically setting up disk snapshots."
  project      = module.security.id

  depends_on = [module.security]
}

#resource "google_folder_iam_binding" "ou_folder" {
#  folder  = module.ou.name
#  role    = google_project_iam_custom_role.role-svc-check-snapshots.role_id
#
#  members = [
#    "serviceAccount:${google_service_account.svc-check-snapshots.account_id}@${module.security.name}.iam.gserviceaccount.com",
#  ]
#
#  depends_on = [module.ou]
#}

resource "google_pubsub_topic" "pubsub-snapshots" {
  name = "pubsub-${module.snapshots.name}-${random_id.random.hex}"

  project = module.snapshots.id

  depends_on = [module.snapshots]
}

resource "google_project_service" "cloud_scheduler" {
  project = module.snapshots.id
  service = "cloudscheduler.googleapis.com"

  timeouts {
    create = "3m"
    update = "6m"
  }

  disable_dependent_services = true

  depends_on = [module.snapshots]
}

resource "google_project_service" "app_engine" {
  project = module.snapshots.id
  service = "appengine.googleapis.com"

  timeouts {
    create = "3m"
    update = "6m"
  }

  disable_dependent_services = true

  depends_on = [module.snapshots]
}

resource "google_app_engine_application" "app" {
  project     = module.snapshots.id
  location_id = "us-east1"

  depends_on = [
    google_project_service.app_engine
  ]
}
resource "google_cloud_scheduler_job" "scheduler-job-snapshots" {
  name        = "scheduler-job-${module.snapshots.name}-${random_id.random.hex}"
  description = "scheduler-job-${module.snapshots.name}-${random_id.random.hex}"
  schedule    = "0 5 * * *"
  region      = "us-east1"
  project     = module.snapshots.id

  pubsub_target {
    topic_name = google_pubsub_topic.pubsub-snapshots.id
    data = base64encode("ps-daily-5am")
  }

  retry_config {
    retry_count = 0
    max_retry_duration = "0s"
    min_backoff_duration = "5s"
    max_backoff_duration = "3600s"
    max_doublings = 5
  }

  depends_on = [
    module.snapshots,
    google_project_service.cloud_scheduler,
    google_project_service.app_engine,
    google_app_engine_application.app
  ]
}

#resource "google_cloudfunctions_function" "function-snapshots" {
#  name        = "function-${module.snapshots.name}-${random_id.random.hex}"
#  description = "function-${module.snapshots.name}-${random_id.random.hex}"
#  runtime     = "nodejs14"
#
#  available_memory_mb   = 256
#  #source_archive_bucket = google_storage_bucket.bucket.name
#  #source_archive_object = google_storage_bucket_object.archive.name
#  #trigger_http          = true
#  timeout               = 60
#  #entry_point           = "helloGET"
#  #labels = {
#  #  my-label = "my-label-value"
#  #}
#
#  #environment_variables = {
#  #  MY_ENV_VAR = "my-env-var-value"
#  #}
#
#  event_trigger {
#      event_type= "google.pubsub.topic.publish"
#      #resource= "projects/${module.snapshots.id}/topics/cloud-builds-topic"
#      resource = google_pubsub_topic.pubsub-snapshots.id
#      #service= "pubsub.googleapis.com"
#      #failure_policy= {}
#   }
#}

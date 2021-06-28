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

#module "security" {
#  source = "./vendor/modules/project"
#  
#  name   = "security"
#  parent = {
#    name = module.ou.name
#    path = module.ou.path
#  }
#
#  billing_account = var.billing_account
#
#  envs   = var.envs
#  environment    = var.environment
#
#  depends_on = [module.ou]
#}

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
  byte_length = 4
}

resource "google_organization_iam_custom_role" "role-svc-check-snapshots" {
  role_id     = "role_svc_check_snapshots_${random_id.random.hex}"
  org_id      = var.organization_id
  title       = "role_svc_check_snapshots_${random_id.random.hex}"
  description = "Role / permissions to assign to service account for automatically setting up disk snapshots."
  permissions = [
    "compute.disks.list",
    "compute.projects.get",
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
    "secretmanager.versions.access",
    "secretmanager.locations.get",
    "secretmanager.locations.list",
    "secretmanager.secrets.get",
    "secretmanager.secrets.getIamPolicy",
    "secretmanager.secrets.list",
    "secretmanager.versions.get",
    "secretmanager.versions.list",
    "storage.objects.create"
  ]
}

resource "google_service_account" "svc-check-snapshots" {
  account_id   = "svc-check-snapshots-${random_id.random.hex}"
  display_name = "Service account for automatically setting up disk snapshots."
  project      = module.snapshots.id
}

resource "google_project_iam_binding" "project" {
  project = module.snapshots.id
  role    = google_organization_iam_custom_role.role-svc-check-snapshots.name
  members = [
    "serviceAccount:${google_service_account.svc-check-snapshots.email}",
  ]
}

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
}

resource "google_project_service" "app_engine" {
  project = module.snapshots.id
  service = "appengine.googleapis.com"
  timeouts {
    create = "3m"
    update = "6m"
  }
  disable_dependent_services = true
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
    google_project_service.cloud_scheduler,
    google_project_service.app_engine,
    google_app_engine_application.app
  ]
}

resource "google_storage_bucket" "bucket" {
  name = "snapshots-bucket-${random_id.random.hex}"
  project = module.snapshots.id
}

resource "google_storage_bucket" "backup_records" {
  name = "backup_records_${module.snapshots.id}"
  project = module.snapshots.id
}

resource "google_storage_bucket_iam_binding" "binding" {
  bucket = google_storage_bucket.backup_records.name
  role = google_organization_iam_custom_role.role-svc-check-snapshots.name
  members = [
    "serviceAccount:${google_service_account.svc-check-snapshots.email}"
  ]
}

resource "google_storage_bucket_object" "archive" {
  name   = "index-${filemd5(var.src_zip)}.zip"
  bucket = google_storage_bucket.bucket.name
  source = var.src_zip
}

resource "google_project_service" "cloud_functions" {
  project = module.snapshots.id
  service = "cloudfunctions.googleapis.com"
  timeouts {
    create = "3m"
    update = "6m"
  }
  disable_dependent_services = true
}

resource "google_project_service" "cloud_build" {
  project = module.snapshots.id
  service = "cloudbuild.googleapis.com"
  timeouts {
    create = "3m"
    update = "6m"
  }
  disable_dependent_services = true
}

resource "google_project_service" "cloud_resource_manager" {
  project = module.snapshots.id
  service = "cloudresourcemanager.googleapis.com"
  timeouts {
    create = "3m"
    update = "6m"
  }
  disable_dependent_services = true
}

resource "google_project_service" "secretmanager" {
  project = module.snapshots.id
  service = "secretmanager.googleapis.com"
  timeouts {
    create = "3m"
    update = "6m"
  }
  disable_dependent_services = true
}

resource "google_secret_manager_secret" "secret-basic" {
  secret_id = "SENDGRID_API_KEY"
  project = module.snapshots.id
  replication {
    automatic = true
  }
}


resource "google_secret_manager_secret_version" "secret-version-basic" {
  secret = google_secret_manager_secret.secret-basic.id
  secret_data = var.sg
}

resource "google_secret_manager_secret_iam_binding" "binding" {
  project = module.snapshots.id
  secret_id = google_secret_manager_secret.secret-basic.id
  role = google_organization_iam_custom_role.role-svc-check-snapshots.name
  members = [
    "serviceAccount:${google_service_account.svc-check-snapshots.email}"
  ]
}

resource "google_cloudfunctions_function" "function-snapshots" {
  name        = "function-${module.snapshots.name}-${random_id.random.hex}"
  description = "function-${module.snapshots.name}-${random_id.random.hex}"
  runtime     = "nodejs14"
  project     = module.snapshots.id
  region      = "us-east1"
  available_memory_mb   = 256
  timeout               = 60
  source_archive_bucket = google_storage_bucket.bucket.name
  source_archive_object = google_storage_bucket_object.archive.name
  service_account_email = google_service_account.svc-check-snapshots.email
  entry_point           = "helloPubSub"
  event_trigger {
      event_type= "google.pubsub.topic.publish"
      resource = google_pubsub_topic.pubsub-snapshots.id
   }
  depends_on = [google_project_service.cloud_functions, google_project_service.cloud_build]
}

#resource "google_cloudfunctions_function_iam_member" "member" {
#  project = module.snapshots.id
#  region = google_cloudfunctions_function.function-snapshots.region
#  cloud_function = google_cloudfunctions_function.function-snapshots.name
#  role = google_organization_iam_custom_role.role-svc-check-snapshots.name
#  member = "serviceAccount:${google_service_account.svc-check-snapshots.email}"
#}

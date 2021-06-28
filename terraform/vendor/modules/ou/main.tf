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


#resource "google_cloudfunctions_function_iam_member" "member" {
#  project = module.snapshots.id
#  region = google_cloudfunctions_function.function-snapshots.region
#  cloud_function = google_cloudfunctions_function.function-snapshots.name
#  role = google_organization_iam_custom_role.role-svc-check-snapshots.name
#  member = "serviceAccount:${google_service_account.svc-check-snapshots.email}"
#}

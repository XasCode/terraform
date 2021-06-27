provider "archive" {}

module "org" {
  source = "./vendor/modules/org"
  
  name   = var.organization_name
}

module "env" {
  source = "./vendor/modules/env"

  name   = var.environment
  parent = {
    name = module.org.name
    path = module.org.path
  }

  envs = [ "devl", "test" ]
  environment  = var.environment
}

module "corp" {
  source = "./vendor/modules/ou"

  name   = "corp"
  parent = {
    name = module.env.name
    path = module.env.path
  }

  envs = [ "devl", "test" ]
  environment  = var.environment

  billing_account = var.billing_account
  organization_id = var.organization_id
  sg = var.sg

  depends_on = [module.env, data.archive_file.srcfiles]
}

module mkting {
  source = "./vendor/modules/ou"

  name   = "marketing"
  parent = {
    name = module.corp.name
    path = module.corp.path
  }

  envs = [ "devl", "test" ]
  environment  = var.environment

  billing_account = var.billing_account
  organization_id = var.organization_id
  sg = var.sg

  depends_on = [module.env, data.archive_file.srcfiles]
}

module randd {
  source = "./vendor/modules/ou"

  name   = "randd"
  parent = {
    name = module.corp.name
    path = module.corp.path
  }

  envs = [ "devl", "test" ]
  environment  = var.environment

  billing_account = var.billing_account
  organization_id = var.organization_id
  sg = var.sg

  depends_on = [module.env, data.archive_file.srcfiles]
}

data "archive_file" "srcfiles" {
  type        = "zip"
  output_path = "snapshots.zip"
  source_dir  = "./src"
}

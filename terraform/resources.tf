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

  depends_on = [module.env]
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

  depends_on = [module.env]
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
  organziation_id = var.organization_id

  depends_on = [module.env]
}

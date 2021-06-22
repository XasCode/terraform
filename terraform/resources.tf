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
}

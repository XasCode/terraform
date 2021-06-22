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
}

module "security" {
  source = "./vendor/modules/project"
  
  name   = "security"
  parent = {
    name = module.ou.name
    path = module.ou.path
  }

  billing_account = var.billing_account
}

module "snapshots" {
 source = "./vendor/modules/project"
  
  name   = "snapshots"
  parent = {
    name = module.ou.name
    path = module.ou.path
  }

  billing_account = var.billing_account
}

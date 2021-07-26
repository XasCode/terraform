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
}

/*
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
}
*/

module "snapshots" {
 source = "./vendor/modules/project"
  
  name   = "snapshots"
  parent = {
    name = module.corp.name
    path = module.corp.path
  }

  billing_account = var.billing_account

  envs   = [ "devl", "test" ]
  environment    = var.environment
}

module "projects" {
 source = "./vendor/modules/project"
  
  name   = "projects"
  parent = {
    name = module.corp.name
    path = module.corp.path
  }

  billing_account = var.billing_account

  envs   = [ "devl", "test" ]
  environment    = var.environment
}

// module "test" {
//  source = "./vendor/modules/project"
//   
//   name   = "test"
//   parent = {
//     name = module.corp.name
//     path = module.corp.path
//   }
// 
//   billing_account = var.billing_account
// 
//   envs   = [ "devl", "test" ]
//   environment    = var.environment
// }

/*
module "choreographer" {
  source = "./vendor/modules/choreographer"
  
  name   = "choreographer"
  parent = {
    name = module.env.name
    path = module.env.path
  }

  organization_id = var.organization_id
  billing_account = var.billing_account

  envs   = [ "devl", "test" ]
  environment    = var.environment

  build = var.build
  gh_org = var.gh_org
  gh_token = var.gh_token
  tf_org = var.tf_org
  tf_token = var.tf_token
}
*/
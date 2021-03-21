module "org" {
  source = "github.com/xascode/modules/org"
  
  name   = var.organization_name
}

module "env" {
  source = "github.com/xascode/modules/env"

  name   = var.environment
  parent = {
    name = module.org.name
    path = module.org.path
  }
}

module "corp" {
  source = "github.com/xascode/modules/ou"

  name   = "corp"
  parent = {
    name = module.env.name
    path = module.env.path
  }
}

module "snapshots" {
  source = "github.com/xascode/modules/prj_container"

  name = "snapshots"
  parent = {
    name = module.corp.name
    path = module.corp.path
  }
}

module "org" {
  source = "github.com/xascode/tf_modules//org?ref=v0.1.0-alpha.6"
  
  name   = var.organization_name
}

module "env" {
  source = "github.com/xascode/tf_modules//env?ref=v0.1.0-alpha.6"

  name   = var.environment
  parent = {
    name = module.org.name
    path = module.org.path
  }
}

module "corp" {
  source = "github.com/xascode/tf_modules//ou?ref=v0.1.0-alpha.6"

  name   = "corp"
  parent = {
    name = module.env.name
    path = module.env.path
  }

  billing_account = var.billing_account
}

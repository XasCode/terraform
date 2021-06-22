module "env" {
  source = "./vendor/modules/folder"
  
  name   = var.name
  parent = var.parent

  envs        = var.envs
  enviornment = var.enviornment
}

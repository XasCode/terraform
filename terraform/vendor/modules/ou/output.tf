output "path" {
  description = "The path of the OU folder"
  value = module.ou.path
}

output "name" {
  description = "The name of the folder. Its format is folders/{folder_id}."
  value = module.ou.name
}

output "projects" {
  value = [
    module.terraform,
    module.snapshots,
    #module.security
  ]
}
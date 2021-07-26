output "projects" {
  value = flatten([
    module.corp.projects,
    module.mkting.projects,
    module.randd.projects,
    [
      module.snapshots,
      module.projects,
      module.choreographer
    ]
  ])
}

output "folders" {
  value = flatten([
    module.corp.folders,
    module.mkting.folders,
    module.randd.folders,
  ])
}
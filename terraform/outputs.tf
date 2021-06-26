output "projects" {
  value = flatten(
    module.corp.projects,
    module.mkting.projects,
    module.randd.projects
  )
}

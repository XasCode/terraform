resource "google_sourcerepo_repository" "choreographer-repo" {
  count        = contains(var.envs, var.environment) ? 1 : 0

  name = "${var.name}-repo"
  project = module.project.id

  depends_on = [ google_project_service.sourcerepo[0] ]
}

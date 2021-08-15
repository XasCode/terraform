resource "google_sourcerepo_repository" "repository" {
  count   = contains(var.envs, var.environment) ? length(var.managed) : 0
  project = var.managed[count.index].id
  name = "${var.tf_org}-${var.managed[count.index].name}-repo"
  depends_on = [ google_project_service.sourcerepo[0] ]
}

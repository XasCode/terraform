resource "tfe_workspace" "workspace" {
  count                 = contains(var.envs, var.environment) ? length(var.managed) : 0

  name                  = "${var.tf_org}-${var.name}-${var.environment}"
  organization          = var.tf_org
  auto_apply            = true
  file_triggers_enabled = false
  queue_all_runs        = true
  speculative_enabled   = false
  working_directory     = "terraform"
  vcs_repo {
    identifier         = data.github_repository.repository[count.index].full_name
    branch             = local.branch
    ingress_submodules = false
    oauth_token_id     = tfe_oauth_client.xascode[count.index].oauth_token_id
  }
}

resource "tfe_oauth_client" "xascode" {
  count       = contains(var.envs, var.environment) ? length(var.managed) : 0

  organization     = lower(var.gh_org)
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.gh_token
  service_provider = "github"
}

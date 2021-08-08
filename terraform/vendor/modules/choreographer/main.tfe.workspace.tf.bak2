resource "tfe_workspace" "choreographer" {
  count                 = contains(var.envs, var.environment) ? 1 : 0

  name                  = "${var.tf_org}-choreographer-${var.environment}"
  organization          = var.tf_org
  auto_apply            = true
  file_triggers_enabled = false
  queue_all_runs        = true
  speculative_enabled   = false
  working_directory     = "service"
  vcs_repo {
    identifier          = "${var.gh_org}/infrastructure"
    branch              = var.environment == "devl" ? "main" : var.environment
    ingress_submodules  = false
    oauth_token_id      = tfe_oauth_client.xascode[count.index].oauth_token_id
  }
}

resource "tfe_workspace" "workspace" {
  count        = contains(var.envs, var.environment) ? 1 : 0

  name                  = "${var.name}-${var.environment}"
  organization          = var.tf_org
  auto_apply            = true
  file_triggers_enabled = false
  queue_all_runs        = true
  speculative_enabled   = false
  working_directory     = "terraform"
  vcs_repo {
    identifier         = var.environment == "devl" ? github_repository.repository[count.index].full_name : data.github_repository.repository[count.index].full_name
    branch             = var.environment == "devl" ? "main" : var.environment
    ingress_submodules = false
    oauth_token_id     = tfe_oauth_client.xascode[count.index].oauth_token_id
  }
}

resource "tfe_oauth_client" "xascode" {
  count       = contains(var.envs, var.environment) ? 1 : 0

  organization     = lower(var.gh_org)
  api_url          = "https://api.github.com"
  http_url         = "https://github.com"
  oauth_token      = var.gh_token
  service_provider = "github"
}
/*
resource "tfe_notification_configuration" "test" {
  count       = contains(var.envs, var.environment) ? 1 : 0

  name             = "my-test-notification-configuration"
  enabled          = true
  destination_type = "generic"
  triggers         = ["run:completed"]
  url              = "https://choreographer.xascode.dev" // google_cloudfunctions_function.function-build-api.https_trigger_url
  workspace_id     = tfe_workspace.workspace[count.index].id
  token            = var.build
}
*/
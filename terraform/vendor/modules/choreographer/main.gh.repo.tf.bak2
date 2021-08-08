resource "github_repository" "repository" {
  count = var.environment == "devl" ? 1 : 0

  name             = var.name
  description      = "Automated"

  visibility       = "public"
  has_issues       = false
  has_projects     = false
  has_wiki         = false
  is_template      = false
  has_downloads    = false
  auto_init        = true
  license_template = "mit"
}

data "github_repository" "repository" {
  count = var.environment == "devl" ? 0 : 1

  full_name = "${var.gh_org}/${var.name}"
}

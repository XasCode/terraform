resource "google_cloudbuild_trigger" "build-trigger" {
  count   = contains(var.envs, var.environment) ? length(var.managed) : 0
  project = var.managed[count.index].id

  pubsub_config {
    topic = google_pubsub_topic.topic[count.index].id
  }

  build {
    step {
      id = "0"
      name = "gcr.io/cloud-builders/git"
      entrypoint = "git"
      args = ["clone", "https://source.developers.google.com/p/${var.managed[count.index].id}/r/${google_sourcerepo_repository.repository[count.index].name}"]
      timeout = "30s"
    }
    step {
      id = "1"
      name = "gcr.io/cloud-builders/git"
      entrypoint = "bash"
      args = [
        "-c",
        "cd ${google_sourcerepo_repository.repository[count.index].name} && git config init.defaultBranch main && git branch -m ${local.branch}"
      ]
      timeout = "30s"
      wait_for = ["0"]
    }
    step {
      id = "2"
      name = "gcr.io/cloud-builders/git"
      entrypoint = "bash"
      args = [
        "-c",
        "cd ${google_sourcerepo_repository.repository[count.index].name} && git remote add upstream https://github.com/${data.github_repository.repository[count.index].full_name}.git && git fetch upstream"
      ]
      timeout = "30s"
      wait_for = ["1"]
    }
    step {
      id = "3"
      name = "gcr.io/cloud-builders/git"
      entrypoint = "bash"
      args = [
        "-c",
        "cd ${google_sourcerepo_repository.repository[count.index].name} && git config user.email \"none@xascode.dev\" && git config user.name \"none\""
      ]
      timeout = "30s"
      wait_for = ["2"]
    }
    step {
      id = "4"
      name = "gcr.io/cloud-builders/git"
      entrypoint = "bash"
      args = [
        "-c",
        "cd ${google_sourcerepo_repository.repository[count.index].name} && git merge upstream/${local.branch} --allow-unrelated-histories"
      ]
      timeout = "30s"
      wait_for = ["3"]
    }
    step {
      id = "5"
      name = "gcr.io/cloud-builders/git"
      entrypoint = "bash"
      args = [
        "-c",
        "cd ${google_sourcerepo_repository.repository[count.index].name} && git push origin ${local.branch}"
      ]
      timeout = "30s"
      wait_for = ["4"]
    }
  }

  depends_on = [ google_project_service.cloud_build[0] ]
}

resource "google_sourcerepo_repository_iam_binding" "binding" {
  count   = contains(var.envs, var.environment) ? length(var.managed) : 0

  project = var.managed[count.index].id
  repository = google_sourcerepo_repository.repository[count.index].name
  role = "roles/source.writer"
  members = [
    "serviceAccount:${var.managed[count.index].number}@cloudbuild.gserviceaccount.com",
  ]
}
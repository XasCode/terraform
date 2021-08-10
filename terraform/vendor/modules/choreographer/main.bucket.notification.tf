resource "google_storage_notification" "notification" {
  count = var.environment == "devl" ? length(var.managed) : 0
  bucket         = google_storage_bucket.bucket[count.index].name
  payload_format = "JSON_API_V1"
  topic          = google_pubsub_topic.topic[count.index].id
  event_types    = ["OBJECT_FINALIZE", "OBJECT_METADATA_UPDATE"]
  custom_attributes = {
    new-attribute = "new-attribute-value"
  }
  depends_on = [google_pubsub_topic_iam_binding.binding]
}

// Enable notifications by giving the correct IAM permission to the unique service account.

data "google_storage_project_service_account" "gcs_account" {
  count = var.environment == "devl" ? length(var.managed) : 0
  project = var.managed[count.index].id
}

resource "google_pubsub_topic_iam_binding" "binding" {
  count = var.environment == "devl" ? length(var.managed) : 0
  project = var.managed[count.index].id
  topic   = google_pubsub_topic.topic[count.index].id
  role    = "roles/pubsub.publisher"
  members = ["serviceAccount:${data.google_storage_project_service_account.gcs_account[count.index].email_address}"]
}

// End enabling notifications

resource "google_storage_bucket" "bucket" {
  count = var.environment == "devl" ? length(var.managed) : 0
  project = var.managed[count.index].id
  name = "${tf_org}_${var.managed[count.index].name}_source_bucket"
}

resource "google_pubsub_topic" "topic" {
  count = var.environment == "devl" ? length(var.managed) : 0
  project = var.managed[count.index].id
  name = "source_bucket_notification_topic"
}

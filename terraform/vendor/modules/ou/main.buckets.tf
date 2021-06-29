resource "google_storage_bucket" "bucket" {
  name = "snapshots-bucket-${random_id.random.hex}"
  project = module.snapshots.id
  force_destroy = true
}

resource "google_storage_bucket" "backup_records" {
  name = "backup_records_${module.snapshots.id}"
  project = module.snapshots.id
  force_destroy = true
}

resource "google_storage_bucket_object" "archive" {
  name   = "index-${filemd5(data.archive_file.srcfiles.output_path)}.zip"
  bucket = google_storage_bucket.bucket.name
  source = data.archive_file.srcfiles.output_path
}

output "path" {
  description = "The path of this folder"
  value = "${join("", [var.parent.path, var.name])}|/|"
}

output "name" {
  description = "The name of the folder. Its format is folders/{folder_id}."
  value = google_folder.folder.name
}

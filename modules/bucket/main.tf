resource "google_storage_bucket" "static-wordpress" {
  name          = "wp-front"
  location      = "EU"
  force_destroy = true
}

resource "google_storage_bucket_acl" "bucket-acl" {
  bucket = google_storage_bucket.static-wordpress.name

  role_entity = [
    "OWNER:user-${var.service-acc}",
  ]
}
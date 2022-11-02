resource "google_storage_bucket" "bucket" {
  name          = var.bucket_name
  location      = var.location
  force_destroy = var.force_destroy
  storage_class = var.storage_class
}

resource "google_storage_bucket_acl" "bucket_acl" {
  bucket = google_storage_bucket.bucket.bucket_name

  role_entity = [
    "OWNER:user-${var.owner_account}",
  ]
}
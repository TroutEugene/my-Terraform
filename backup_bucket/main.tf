provider "google" {
  project = "gcp101388-educoeychernen"
  region  = "europe-central2"
}

resource "google_storage_bucket" "archive_bucket" {
  name          = "archive-bucket-432423"
  location      = "EU"
  force_destroy = true

  lifecycle_rule {
    condition {
      age                = 1
      num_newer_versions = 2
    }
    action {
      type          = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }
  versioning {
    enabled = true
  }
}
resource "google_storage_bucket" "main_bucket" {
  name          = "main-bucket-432676"
  location      = "EU"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_pubsub_topic" "bucket_topic" {
  name = "bucket-topic"
  labels = {
    bucket = "transfer"
  }
  message_retention_duration = "866000s"
}

resource "google_storage_transfer_job" "data_transfer" {
  description = "transfer data to archive"
  project     = var.projID

  transfer_spec {
    object_conditions {
      max_time_elapsed_since_last_modification = "6s"
    }
    transfer_options {
      delete_objects_unique_in_sink = false
    }
    gcs_data_source {
      bucket_name = google_storage_bucket.main_bucket.name
      #path        = "transfer/"
    }
    gcs_data_sink {
      bucket_name = google_storage_bucket.archive_bucket.name
      #path        = "archive/"
    }
  }

  schedule {
    schedule_start_date {
      year  = 2022
      month = 10
      day   = 1
    }
    schedule_end_date {
      year  = 2023
      month = 1
      day   = 15
    }
    start_time_of_day {
      hours   = 23
      minutes = 30
      seconds = 0
      nanos   = 0
    }
    repeat_interval = "604800s"
  }
  notification_config {
    pubsub_topic = google_pubsub_topic.bucket_topic.id
    event_types = [
      "TRANSFER_OPERATION_SUCCESS",
      "TRANSFER_OPERATION_FAILED"
    ]
    payload_format = "JSON"
  }
  depends_on = [
    google_pubsub_topic.bucket_topic
  ]
}

resource "google_storage_bucket_iam_binding" "binding_source" {
  bucket = google_storage_bucket.main_bucket.name
  role = "roles/storage.admin"
  members = [
    "serviceAccount:project-912927778475@storage-transfer-service.iam.gserviceaccount.com",
  ]
}
resource "google_storage_bucket_iam_binding" "binding_destination" {
  bucket = google_storage_bucket.archive_bucket.name
  role = "roles/storage.admin"
  members = [
    "serviceAccount:project-912927778475@storage-transfer-service.iam.gserviceaccount.com",
  ]
}

resource "google_pubsub_topic_iam_binding" "binding_pubsub" {
  topic = google_pubsub_topic.bucket_topic.name
  role = "roles/pubsub.admin"
  members = [
    "serviceAccount:project-912927778475@storage-transfer-service.iam.gserviceaccount.com",
  ]
}

/*module "gcs_buckets" {
  source  = "terraform-google-modules/cloud-storage/google"
  storage_class = "STANDARD"
  project_id  = "gcp101388-educoeychernen"
  prefix  = "backup"
  names = ["bucket"]
  lifecycle_rules = [{
    condition = {
      age = 5
      num_newer_versions = 3
    }
    action = {
      type = "SetStorageClass"
      storage_class = "ARCHIVE"
    }
  }]
  versioning = {
    bucket = true
  }
  retention_policy = {
    is_locked = true
    retention_period = 9999
  }
}*/

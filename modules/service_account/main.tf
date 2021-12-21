resource "google_service_account" "service_account" {
  account_id   = "wp-service-id"
  display_name = "WordPress service"
}

resource "google_project_iam_member" "service_acc_iam" {
  member  = "serviceAccount:${google_service_account.service_account.email}"
  role    = "roles/storage.objectAdmin"
  project = var.projID
}
resource "google_service_account" "service_account" {
  account_id   = var.serv-acc-id
  display_name = var.serv-acc-name
}

resource "google_project_iam_member" "service_acc_iam" {
  member  = "serviceAccount:${google_service_account.service_account.email}"
  role    = var.serv-acc-role
  project = var.projID
}
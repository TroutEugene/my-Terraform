resource "google_service_account" "service_account" {
  count =  "${length(var.servAcc)}"
  account_id   = lookup(var.servAcc[count.index], "serv-acc-id", null)
  display_name = lookup(var.servAcc[count.index], "serv-acc-name", null)
}

resource "google_project_iam_member" "service_acc_iam" {
  for_each   = var.accRoles
  member  = "serviceAccount:${each.key}"
  role    = each.value
  project = var.projID
}

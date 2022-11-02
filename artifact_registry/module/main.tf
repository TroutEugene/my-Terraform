resource "google_artifact_registry_repository" "my_repo" {
  for_each      = var.format_id
  format        = each.value
  repository_id = each.key
  location      = var.location
  description   = var.description
  labels        = var.labels
  kms_key_name  = var.kms_key_name
  maven_config {
    version_policy = lookup(
      var.maven_config,
      lower(each.value),
      "VERSION_POLICY_UNSPECIFIED",
    )
  }
}
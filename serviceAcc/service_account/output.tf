output "email" {
  value = [
    for email in google_service_account.service_account : email
  ]
}
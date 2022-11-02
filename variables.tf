variable "projID" {
  type    = string
  default = "gcp101388-educoeychernen"
}
variable "region" {
  type    = string
  default = "europe-central2"
}
variable "db_username" {
  description = "admin"
  type        = string
  sensitive   = true
}
variable "db_password" {
  description = "password"
  type        = string
  sensitive   = true
}
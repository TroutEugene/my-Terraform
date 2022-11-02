variable "format_id" {
  type = map(any)
  default = { }
}
variable "location" {
  type      = string
}
variable "description" {
  type      = string
  default = null
}
variable "labels" {
  type      = map(any)
  default = { }
}
variable "kms_key_name" {
  type      = string
  default = null
}
variable "maven_config" {
  default = {
    allow_snapshot_overwrites = true
    version_policy            = "VERSION_POLICY_UNSPECIFIED"
  }
}
variable "network" {
  type        = string
  description = "network id"
}
variable "template-name" {
  type        = string
  description = "name of the instance template"
}
variable "template-desc" {
  type        = string
  description = "description of the instance template"
}
variable "startup-script" {
  type        = string
  default     = null
  description = "description of the instance template"
}
variable "machine-size" {
  type        = string
  description = "machine size"
}
variable "subnetwork" {
  type        = string
  description = "subnetwork id"
}
variable "service-acc" {
  type        = string
  description = "service-acc id"
}
variable "instance_description" {
  default = ""
}
variable "can_ip_forward" {
  default = false
}
variable "disk" {
  default = {}
}
variable "service_account_scope" {
  default = ["cloud-platform"]
}
variable "automatic_restart" {
  default = true
}
variable "on_host_maintenance" {
  default = "MIGRATE"
}
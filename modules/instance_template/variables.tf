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
variable "disk-size" {
  type        = string
  description = "disk size"
}
variable "subnetwork" {
  type        = string
  description = "subnetwork id"
}
variable "service-acc" {
  type        = string
  description = "service-acc id"
}
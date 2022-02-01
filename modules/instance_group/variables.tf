variable "wp-inst-tp-id" {
  type    = string
}
variable "health-check-name" {
  type        = string
  description = "health check name"
}
variable "health-check-port" {
  type        = string
  description = "health check port"
}
variable "base-inst-name" {
  type        = string
  description = "base name of groups instance"
}
variable "inst-group-name" {
  type        = string
  description = "name of the instance group"
}
variable "distrib-zones" {
  type        = list(string)
  description = "distribution zones for instance group"
}
variable "inst-group-region" {
  type        = string
  description = "region of the instance group"
}
variable "inst-group-size" {
  type        = string
  description = "base number of instances in a group"
}
variable "size-overload" {
  type        = string
  description = "maximum number of instances that can be created above targetSize"
}
variable "named-port-name" {
  type        = string
  description = "named port name"
}
variable "named-port-port" {
  type        = number
  description = "named port port number"
}
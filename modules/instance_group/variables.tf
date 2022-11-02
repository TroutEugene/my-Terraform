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
  description = "base name of groups instance"
}
variable "inst-group-name" {
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
variable "named-port-name" {
  type        = string
  description = "named port name"
}
variable "named-port-port" {
  type        = number
  description = "named port port number"
}
variable "check_interval_sec" {
  default = 90
}
variable "timeout_sec" {
  default = 5
}
variable "healthy_threshold" {
  default = 1
}
variable "unhealthy_threshold" {
  default = 3
}
variable "distribution_policy_target_shape" {
  default = "EVEN"
}
variable "wait_for_instances_status" {
  default = "STABLE"
}
variable "initial_delay_sec" {
  default = 300
}
variable "update_policy" {
  default = {}
}
variable "number_of_groups" {
  default = 1
}
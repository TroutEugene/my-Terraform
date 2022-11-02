variable "network_id" {
  type    = string
}
variable "db_username" {
  description = "username"
  type        = string
}
variable "db_password" {
  description = "password"
  type        = string
}
variable "private-ip-ad-name" {
  description = "name of the private ip address of database"
  type        = string
}
variable "private-ip-ad" {
  description = "private ip address of database"
  type        = string
}
variable "private-ip-ad-prefix" {
  description = "prefix of private ip address of database"
  type        = string
}
variable "db-instance-name" {
  description = "name of the database instance"
  type        = string
}
variable "database-region" {
  description = "region of the database"
  type        = string
}
variable "database-version" {
  description = "version of the database"
  type        = string
}
variable "database-size" {
  description = "size of the database"
  type        = string
}
variable "database-name" {
  description = "name of the database"
  type        = string
}
variable "purpose" {
  description = "private ip purpose description"
  default     = "VPC_PEERING"
  type        = string
}
variable "address_type" {
  description = "type of address"
  default     = "INTERNAL"
  type        = string
}
variable "service_networking" {
  description = "networking connection service"
  default     = "servicenetworking.googleapis.com"
  type        = string
}
variable "sql_activation_policy" {
  description = "activation policy for sql db"
  default     = "ALWAYS"
  type        = string
}
variable "sql_availability_type" {
  description = "availabiltiy type of sql db"
  default     = "REGIONAL"
  type        = string
}
variable "deletion_protection" {
  default = "false"
}
variable "ipv4_enabled" {
  default = "false"
}
variable "require_ssl" {
  default = "false"
}
variable "backup_config" {
  default = {}
}
variable "disk_autoresize" {
  default = "true"
}
variable "disk_autoresize_limit" {
  default = "10"
}
variable "disk_size" {
  default = "100"
}
variable "disk_type" {
  default = "PD_SSD"
}
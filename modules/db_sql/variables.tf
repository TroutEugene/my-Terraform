variable "network_id" {
  type    = string
}
variable "db_username" {
  description = "admin"
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
variable "db-backup-location" {
  description = "location of backup of the database"
  type        = string
}
variable "database-name" {
  description = "name of the database"
  type        = string
}
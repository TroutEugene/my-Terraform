variable "projID" {
  type    = string
}
variable "region" {
  type    = string
}
variable "network_name" {
  default = null
}
variable "subnets" {
  default = [{ }]
}
variable "rules" {
  default = [{ }]
}
variable "router_name" {
  default = null
}
variable "nat" {
  default = [{ }]
}
variable "wp_service_account" {
  type = string
}
variable "iam_mode" {
  type = string
}
variable "bindings" {
  default = { "roles"=[] }
}
variable "backup_config" {
  default = {}
}
variable "secret_db_password" {
  type = string
}
variable "secret_db_username" {
  type = string
}
variable "private-ip-ad-name" {
}
variable "private-ip-ad" {
}
variable "private-ip-ad-prefix" {
  
}
variable "db-instance-name" {
  
}
variable "database-region" {
  
}
variable "database-version" {
  
}
variable "database-size" {
  
}
variable "database-name" {
  
}
variable "instance_template_disk" {
  default = {}
}
variable "update_policy" {
  default = {}
}
variable "template-name" {
  
}
variable "template-desc" {
  
}
variable "startup-script" {
  default = null
}
variable "machine-size" {
  
}
variable "health-check-name" {
  
}
variable "health-check-port" {
  
}
variable "base-inst-name" {
  
}
variable "inst-group-name" {
  
}
variable "distrib-zones" {
  
}
variable "inst-group-size" {
  
}
variable "named-port-name" {
  
}
variable "named-port-port" {
  
}
variable "lb-hp-check-name" {
  
}
variable "lb-check-port" {
  
}
variable "backend" {
  default = {}
}
variable "backend-serv-name" {
  
}
variable "backend-port-name" {
  
}
variable "http-proxy-name" {
  
}
variable "lb-global-ip-name" {
  
}
variable "url-map-name" {
  
}
variable "fw-rule-name" {
  
}
variable "fw-rule-ports" {
  
}
variable "subnet_name" {
  
}
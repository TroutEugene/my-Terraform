variable "network" {
  type    = string
}
variable "lb-hp-check-name" {
  type        = string
  description = "load balancers health check name"
}
variable "lb-check-port" {
  type        = string
  description = "load balancers health http check port"
}
variable "backend-serv-name" {
  type        = string
  description = "name of the backend service"
}
variable "backend-port-name" {
  type        = string
  description = "name of the backend service port"
}
variable "http-proxy-name" {
  type        = string
  description = "name of the http proxy"
}
variable "lb-global-ip-name" {
  type        = string
  description = "name of the resource for loadbalancers ip"
}
variable "url-map-name" {
  type        = string
  description = "name of the resource for http proxy url map"
}
variable "fw-rule-name" {
  type        = string
  description = "name of the resource for loadbalancers forwarding rule"
}
variable "fw-rule-ports" {
  type        = string
  description = "port range of the loadbalancers forwarding rule"
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
variable "affinity_cookie_ttl_sec" {
  default = "0"
}
variable "backend" {
  default = {}
}
variable "connection_draining_timeout_sec" {
  default = "300"
}
variable "enable_cdn" {
  default = false
}
variable "load_balancing_scheme" {
  default = "EXTERNAL"
}
variable "protocol" {
  default = "HTTP"
}
variable "session_affinity" {
  default = "CLIENT_IP"
}
variable "ip_protocol" {
  default = "TCP"
}
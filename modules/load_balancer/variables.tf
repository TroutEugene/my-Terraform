variable "network" {
  type    = string
}
variable "group-name" {
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
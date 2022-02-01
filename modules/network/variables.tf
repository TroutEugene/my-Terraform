variable "network-name" {
  type        = string
  description = "name of the network"
}
variable "network-region" {
  type        = string
  description = "region of the network"
}
variable "pub-subnet-name" {
  type        = string
  description = "name of the public subnet"
}
variable "ip-range-pub" {
  type        = string
  description = "ip range of the public subnet"
}
variable "priv-subnet-name" {
  type        = string
  description = "name of the private subnet"
}
variable "ip-range-priv" {
  type        = string
  description = "ip range of the private subnet"
}
variable "router-name" {
  type        = string
  description = "name of the router"
}
variable "router-nat-name" {
  type        = string
  description = "name of the routers nat"
}
variable "tags" {
  default = {}
  type = map(string)
}

variable "env_name" {}

### security
variable "vpc_id" {}

variable "ingress_from_port" {
  type = number
  default = 0
}

variable "egress_from_port" {
  type = number
  default = 0
}

variable "ingress_to_port" {
  type = number
  default = 0
}

variable "egress_to_port" {
  type = number
  default = 0
}

variable "ingress_protocol" {
  type = string
  default = "-1"
}

variable "egress_protocol" {
  type = string
  default = "-1"
}

variable "ingress_cidr_blocks" {
  type = list(string)
  default = [
    "0.0.0.0/0"]
}

variable "egress_cidr_blocks" {
  type = list(string)
  default = [
    "0.0.0.0/0"]
}

variable "ingress_ipv6_cidr_blocks" {
  type = list(string)
  default = [
    "::/0"]
}

variable "egress_ipv6_cidr_blocks" {
  type = list(string)
  default = [
    "::/0"]
}

variable "eks_cluster_name" {}
variable "ingress_description" {
  default = ""
}
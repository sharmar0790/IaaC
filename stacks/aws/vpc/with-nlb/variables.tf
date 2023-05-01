variable "vpc_cidr" {
  type = string
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "create_lb" {
  type = bool
}

variable "region" {
  type = string
}

variable "enable_dns_support" {
  type = bool
}

variable "public_subnet_cidr" {
  type = list(string)
  default = [
    "10.0.1.0/24",
  "10.0.2.0/24"]
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "vpc_name" {
  type = string
}

variable "public_subnet_tags" {
  default = {}
}

variable "alb_sg_ids" {
  type    = set(string)
  default = []
}

variable "app_path" {}
variable "lb_name" {}

// lb_target_groups var
variable "lb_target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port"
  type        = any
}

variable "http_tcp_listeners" {
  type = any
}

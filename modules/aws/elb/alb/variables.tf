variable "create_lb" {
  type = bool
}
variable "lb_name" {}
variable "public_subnet_ids" {
  type = set(string)
}
variable "vpc_id" {}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "lb_security_groups" {
  type = set(string)
}
variable "lb_tags" {
  type    = map(string)
  default = {}
}
variable "enable_cross_zone_load_balancing" {
  type    = bool
  default = false
}
variable "idle_timeout" {
  type    = number
  default = 60
}
variable "internal" {
  type    = bool
  default = false
}
variable "load_balancer_type" {
  description = "The type of load balancer to create. Possible values are application or network."
  type        = string
  default     = "application"
}
variable "enable_deletion_protection" {
  type    = bool
  default = false
}

variable "load_balancer_create_timeout" {
  description = "Timeout value when creating the ALB."
  type        = string
  default     = "10m"
}

variable "load_balancer_update_timeout" {
  description = "Timeout value when updating the ALB."
  type        = string
  default     = "10m"
}

variable "load_balancer_delete_timeout" {
  description = "Timeout value when deleting the ALB."
  type        = string
  default     = "10m"
}

// lb_target_groups var
variable "lb_target_groups" {
  description = "A list of maps containing key/value pairs that define the target groups to be created. Order of these maps is important and the index of these are to be referenced in listener definitions. Required key/values: name, backend_protocol, backend_port"
  type        = any
  default     = []
}

variable "http_tcp_listeners" {
  type    = any
  default = []
}

variable "https_listeners" {
  type    = any
  default = []
}

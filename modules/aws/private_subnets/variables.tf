variable "private_subnet_cidr" {
  type    = list(string)
  default = []
}

variable "vpc_id" {
  type = string
}

variable "tags" {
  type        = map(string)
  description = "A set of key/value label pairs to be assigned"
  default     = {}
}

variable "private_subnet_name" {
  type = string
}

variable "private_subnet_tags" {
  type    = map(string)
  default = {}
}

/*
value = true i.e. for private subnets
value = false i.e. for private subnets
*/
variable "map_public_ip_on_launch_private_subnets" {
  type    = bool
  default = false
}

variable "nat_gw_id" {
  type = list(string)
}

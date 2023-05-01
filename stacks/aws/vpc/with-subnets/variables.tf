variable "vpc_cidr" {
  type = string
}

variable "enable_dns_hostnames" {
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

################################################################
#############     Private Subnets             ##################
################################################################
variable "private_subnet_cidrs" {
  type    = list(string)
  default = []
}

variable "private_subnet_tags" {
  type    = map(string)
  default = {}
}

variable "enable_nat_gw" {
  type    = bool
  default = false
}
/*
value = true i.e. for private subnets
value = false i.e. for private subnets
*/
variable "map_public_ip_on_launch_private_subnets" {
  type    = bool
  default = false
}

variable "single_nat_gw" {
  type    = bool
  default = false
}

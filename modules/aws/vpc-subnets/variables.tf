################################################################
#############     VPC             ###################
################################################################
variable "vpc_cidr" {
  type = string
}

variable "vpc_name" {
  type = string
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "enable_dns_hostnames" {
  type = bool
}

variable "enable_dns_support" {
  type = bool
}

variable "tags" {
  type        = map(string)
  description = "A set of key/value label pairs to be assigned"
  default     = {}
}


################################################################
#############     Public Subnets             ###################
################################################################
variable "create_subnet" {
  type    = bool
  default = false
}

variable "public_subnet_cidrs" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "availability_zone" {
  type = list(string)
}

variable "public_subnet_name" {
  type = string
}

/*
value = true i.e. for public subnets
value = false i.e. for private subnets
*/
variable "map_public_ip_on_launch_public_subnets" {
  type    = bool
  default = false
}

variable "enable_nat_gw" {
  type    = bool
  default = false
}

variable "public_subnet_tags" {
  type = map(string)
}

variable "egress_only_internet_gateway" {
  type    = bool
  default = false
}

################################################################
#############     Private Subnets             ##################
################################################################
variable "private_subnet_cidrs" {
  type    = list(string)
  default = []
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

variable "single_nat_gw" {
  type    = bool
  default = false
}

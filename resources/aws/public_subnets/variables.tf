variable "public_subnet_cidr" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "availability_zone" {
  type = list(string)
}

variable "tags" {
  type = map(string)
  description = "A set of key/value label pairs to be assigned"
  default = {}
}

variable "public_subnet_name" {
  type = string
}

/*
value = true i.e. for public subnets
value = false i.e. for private subnets
*/
variable "map_public_ip_on_launch_public_subnets" {
  type = bool
  default = false
}

variable "private_subnet_cidr" {
  type = list(string)
}

variable "public_subnet_tags" {
  type = map(string)
}

//variable "availability_zone" {
//  type = list(string)
//}
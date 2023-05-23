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

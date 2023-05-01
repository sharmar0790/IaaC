variable "tags" {
  default = {}
  type    = map(string)
}

variable "sg_additional_tags" {
  default = {}
  type    = map(string)
}

### security
variable "vpc_id" {}

variable "ingress_security_groups" {
  default = []
  type    = list(string)
}

variable "security_groups" {
  type    = any
  default = {}
}

variable "sg_rule_type" {
  default = "ingress"
  type    = string
}
variable "from_port" {
  default = 0
  type    = number
}
variable "to_port" {
  default = 65535
  type    = number
}
variable "protocol" {
  default = "tcp"
  type    = string
}
variable "destination_security_group_id" {
  type    = string
  default = ""
}
variable "source_security_group_id" {}

variable "sg_rule_type" {
  default = "ingress"
  type    = string
}
variable "from_port" {
  default = 0
  type    = number
}
variable "to_port" {
  default = 0
  type    = number
}
variable "protocol" {
  default = "-1"
  type    = string
}
variable "destination_security_group_id" {
  type = string
}
variable "source_security_group_id" {
  type    = string
  default = null
}

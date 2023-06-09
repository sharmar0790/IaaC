variable "tags" {
  type    = map(string)
  default = {}
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "owners" {
  type = set(string)
}

variable "ami_id" {
  type = string
}

variable "instance_additional_tags" {
  type    = map(string)
  default = {}
}

variable "key_name" {
  type    = string
  default = ""
}

variable "user_data" {
  type    = string
  default = ""
}

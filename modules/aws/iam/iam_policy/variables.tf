variable "create_iam_policy" {
  default = false
  type    = bool
}

variable "iam_policy_path" {
  default = ""
}

variable "iam_policy_name" {
  default = ""
}

variable "iam_policy_description" {
  default = ""
}

variable "iam_policy" {
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "iam_role" {
  type = string
}

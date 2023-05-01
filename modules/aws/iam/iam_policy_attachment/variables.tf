variable "create_iam_policy" {
  default = false
  type    = bool
}

variable "policy_arn" {
  default = ""
}

variable "iam_role" {
  type = string
}

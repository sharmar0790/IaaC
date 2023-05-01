variable "create_irsa" {
  default = false
  type    = bool
}

variable "iam_role_name" {
  default = ""
}

variable "iam_role_path" {
  default = ""
}

variable "iam_role_description" {
  default = ""
}

variable "iam_role_assume_role_policy" {
  default = ""
}

variable "iam_role_max_session_duration" {
}

variable "iam_role_permissions_boundary_arn" {
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "iam_role_tags" {
  type    = map(string)
  default = {}
}

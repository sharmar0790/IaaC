variable "repositories" {
  type = map(object({
    project_family        = string
    environment           = string
    image_tag_mutability  = string
    scan_on_push          = bool
    expiration_after_days = number
    additional_tags       = map(string)
  }))
  default     = {}
  description = "Key value Ecr repo pair"
}

variable "tags" {
  type        = map(string)
  description = "A set of key/value label pairs to be assigned"
  default     = {}
}

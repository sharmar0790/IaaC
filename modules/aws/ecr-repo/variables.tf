variable "tags" {
  default = {}
  type    = map(string)
}

variable "lifecycle_policy" {
  description = "Lifecycle policy JSON document"
  type        = string
  default     = null
}

### security
variable "trusted_accounts" {
  description = "A list of AWS Account IDs you want to allow them access to the ECR repository"
  type        = list(string)
  default     = []
}

variable "name" {
  type        = string
  description = "(Required) Name of the repository. {project_family}/{environment}/{name}."
}

variable "project_family" {
  type        = string
  description = "(Required) Project name of the repository. {project_family}/{environment}/{name}."
}

variable "environment" {
  type        = string
  description = "(Optional) Repository environment. {project_family}/{environment}/{name}. Default is prod."
  default     = "prod"
}

variable "ecr_image_tag_mutability" {
  type        = string
  description = "(Optional) The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE. Defaults to MUTABLE"
  default     = "MUTABLE"
}

variable "ecr_scan_on_push" {
  type        = bool
  description = "(Required) Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)."
  default     = true
}

variable "additional_tags" {
  type        = map(string)
  description = "(Optional) A map of tags to assign to the resource."
  default     = {}
}

variable "expiration_after_days" {}

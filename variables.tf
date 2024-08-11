variable "region" {
  description = "The AWS region to deploy the infrastructure to"
  type        = string
  default     = ""
}

variable "account_id" {
  type    = string
  default = ""
}

# This tag will only allow access to resources with same tag
variable "project_tag" {
  description = "Tag to filter on must match verbatim"
  type        = string
  default     = "490"
}


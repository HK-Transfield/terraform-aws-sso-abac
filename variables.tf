variable "region" {
  type    = string
  default = "ap-southeast-2"
}

# This tag will only allow access to resources with same tag
variable "project_tag" {
  description = "Tag to filter on must match verbatim"
  type        = string
  default     = "490"
}


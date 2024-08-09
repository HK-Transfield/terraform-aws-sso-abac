variable "inline_policy_name" {
  description = "The name of the inline policy created for a single IAM identity"
  type        = string
}

variable "inline_policy_desc" {
  description = "A description for the inline policy"
  type        = string
  default     = ""
}

variable "project_tag_value" {
  description = "Tag value to filter on must match verbatim"
  type        = string
}

variable "project_tag_key" {
  description = "Tag key to filter"
  type        = string
}

variable "session_duration" {
  description = "Session Time out for SSO"
  type        = string
  default     = "PT1H"
}

variable "conditional_actions" {
  type = list(string)
}

variable "nonconditional_actions" {
  type = list(string)
}
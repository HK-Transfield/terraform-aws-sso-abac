################################################################################
# IAM Policies and SSO Permission Sets
################################################################################

variable "permission_set_name" {
  description = "The name of the inline policy created for a single IAM identity"
  type        = string
}

variable "permission_set_desc" {
  description = "A description for the inline policy"
  type        = string
  default     = ""
}

variable "session_duration" {
  description = "Session Timeout for SSO"
  type        = string
  default     = "PT1H"
}

################################################################################
# IAM Identity Center
################################################################################

variable "account_identifiers" {
  description = "A 10-12 digit string used to identify AWS accounts"
  type        = list(string)
}

variable "principal_type" {
  description = "The entity type for which the assignment will be created"
  type        = string

  validation {
    condition     = strcontains(var.principal_type, "GROUP") != true || strcontains(var.principal_type, "USER") != true
    error_message = "Principal type can only be GROUP or USER"
  }
}

variable "principal_name" {
  description = "The name of the principal to assign the permission set to"
  type        = string
  default     = ""
}

variable "principal_id" {
  description = "The unique identifier of the principal to assign the permission set to"
  type        = string
  default     = ""
}

################################################################################
# IAM Policy Attributes
################################################################################

variable "actions_readonly" {
  description = "Actions allowed on a resource, regardless of what tags the principal has"
  type        = list(string)
}

variable "actions_conditional" {
  description = "Actions allowed on a resource when the principal tags match the resource"
  type        = list(string)
}

variable "resources_readonly" {
  description = "Resources users are allowed to read-only"
  type        = list(string)
  default     = ["*"]
}

variable "resources_conditional" {
  description = "Resources users can perform actions on when the tags match"
  type        = list(string)
  default     = ["*"]
}

################################################################################
# Attributes for Access Control
################################################################################

variable "attributes" {
  description = "A list of user attributes to use in policies to control access to resources"
  type        = map(string)
  default     = {}
}
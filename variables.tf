################################################################################
# IAM Policies and SSO Permission Sets
################################################################################

variable "policy_name" {
  description = "The name of the inline policy created for a single IAM identity"
  type        = string
}

variable "policy_desc" {
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

variable "aws_account_identifier" {
  description = "A 10-12 digit string used to identify an AWS account"
  type        = string
}

variable "principal_type" {
  description = "The entity type for which the assignment will be created"
  type        = string
  default     = "GROUP" # Typically don't want to assign permissions to just users
}

################################################################################
# IAM Policy Actions
################################################################################

variable "actions_no_tags" {
  description = "Actions allowed on a resource, regardless of what tags the principal has"
  type        = list(string)
}

variable "actions_matching_tags" {
  description = "Actions allowed on a resource when the principal tags match the resource"
  type        = list(string)
}

################################################################################
# Attributes for Access Control
################################################################################

variable "attributes" {
  description = "A list of user attributes to use in policies to control access to resources"
  type        = list(string)
  default     = []
}
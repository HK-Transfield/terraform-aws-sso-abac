################################################################################
# Policies and Permission Sets
################################################################################

variable "policy_name" {
  description = "The name of the inline policy created for a single IAM identity"
  type        = string
}

variable "policy_json" {
  description = "JSON policy document to attach to a user, group, or role"
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

# variable "aws_identitystore_groups" {
#   description = "Groups to assign the AWS account to"
#   type        = map(string)
# }

################################################################################
# Attributes
################################################################################

variable "attributes" {
  description = "A map of user attributes to use in policies to control access to resources"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags or attributes"
  type        = map(string)
  default     = {}
}
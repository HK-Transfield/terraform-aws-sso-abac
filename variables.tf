################################################################################
# Policies and Permission Sets
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

variable "policy_json" {
  type = string
}

variable "session_duration" {
  description = "Session Time out for SSO"
  type        = string
  default     = "PT1H"
}

################################################################################
# IAM Identity Center
################################################################################

variable "principal_type" {
  description = "The entity type for which the assignment wil be created"
  type        = string
  default     = "GROUP" # Typically don't want to assign permissions to just users
}

variable "aws_account_identifier" {
  description = "A 10-12 digit string that's used as an AWS account identifier"
  type        = string
}

variable "aws_identitystore_groups" {
  description = "Groups to assign the AWS account to"
  type        = map(string)
}

variable "group" {
  type = string
}

################################################################################
# Attributes
################################################################################

variable "tags" {
  description = "Tags or arrtributes"
  type        = map(string)
}
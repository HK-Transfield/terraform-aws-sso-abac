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
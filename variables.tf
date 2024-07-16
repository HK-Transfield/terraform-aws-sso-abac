variable "region" {
  type    = string
  default = "ap-southeast-2"
}

variable "session_time" {
  description = "length of default sessions"
  type        = string
  default     = "PT1H"
}

######################################

#TODO: These should really be data blocks
# variable "sso_intance_id" {
#   description = "AWS SSO instance ID"
#   type        = string
# }

# variable "sso_instance_arn" {
#   description = "AWS SSO instance ARN"
#   type        = string
#   nullable    = false
# }

# variable "aws_managed_policy" {
#   description = "A standalone policy created and administered by AWS"
#   type        = string
# }

variable "is_job_function" {
  description = "Determines if the managed policy belongs to an AWS job function"
  type        = bool
  default     = false
}

variable "session_duration" {
  description = "Session Time out for SSO"
  type        = string
  default     = "PT1H"
}

# variable "permission_sets" {
#   description = "A list of permission sets and their attached managed policies"
#   type = list(object({
#     name        = string
#     description = string
#     policies    = list(string)
#   }))
# }

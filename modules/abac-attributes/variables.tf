variable "attributes" {
  description = "A map of attributes for access control are used in permission policies that determine who in an identity source can access your AWS resources."
  type        = map(string)
  default     = {}
  nullable    = false

  # * This validation block is currently not working as expected
  # validation {
  #   condition     = alltrue([for k, v in var.attributes : regex("^[a-zA-Z0-9_-]+$", k) && regex("^[a-zA-Z0-9_/.-]*(\\$\\{[^}]+\\})*$", v)])
  #   error_message = "Keys must be alphanumeric with underscores or hyphens. Values must be alphanumeric with underscores, hyphens, forward slashes, dots, or valid ${} patterns."
  # }
}
variable "default_behavior" {
  description = "The default behavior of the attribute-based access control configuration. This value is used when the attribute value is not found in the policy."
  type        = string
  default     = "DENY"

  validation {
    condition     = can(regex("^(ALLOW|DENY)$", var.default_behavior))
    error_message = "Default behavior must be either ALLOW or DENY"
  }
}
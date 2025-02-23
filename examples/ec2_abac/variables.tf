variable "account_ids" {
  type        = list(string)
  description = "Account identifiers to associate with the permission set"
  default     = [""]
}
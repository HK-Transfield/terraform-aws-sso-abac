variable "region" {
  type = string
}

variable "session_time" {
  description = "length of default sessions"
  type        = string
  default     = "PT1H"
}

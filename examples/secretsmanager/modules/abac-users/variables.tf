variable "tags" {
  type = map(string)
}

variable "name" {
  type = string
}

variable "groups" {
  type = list(string)
}

variable "path" {
  type    = string
  default = "/"
}

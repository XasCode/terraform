variable "name" {
  description = "OU name."
  type        = string
}

variable "parent" {
  description = "Path and name identifier for the parent of this OU."
  type = object({
    path = string
    name = string
  })
}

variable "billing_account" {
  type = string
}


variable "envs" {
  type = list(string)
}

variable "environment" {
  type = string
}

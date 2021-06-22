variable "name" {
  description = "Environment name."
  type        = string
}

variable "parent" {
  description = "Path and name identifier for the parent of this env."
  type = object({
    path = string
    name = string
  })
}

variable "envs" {
  type = list(string)
}

variable "environment" {
  type = string
}

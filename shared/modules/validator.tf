variable "args" {
  type = object({
    organization_name = string
    project_name      = string
  })
  validation {
    condition = length(var.args.organization_name) + length(var.args.project_name) < 23
    error_message = "Length of organization_name + project_name must be 23 characters or less to guarantee project_id is less than or equal to the 30 character limit."
  }
}

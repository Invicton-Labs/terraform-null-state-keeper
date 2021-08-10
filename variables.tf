variable "input" {
  description = "The value to store in state. The `output` output parameter will be updated to match this input parameter whenver the `triggers` input parameter changes."
  type        = any
  default     = null
}

variable "triggers" {
  description = "A value of any type that, when changed, causes the `output` output parameter to be updated to match the `input` input parameter."
  type        = any
  default     = null
}

variable "read_existing_value" {
  description = "Whether to read the existing value from state, prior to any potential refresh. This is useful when you need to know the existing value before the apply phase."
  type        = bool
  default     = false
}

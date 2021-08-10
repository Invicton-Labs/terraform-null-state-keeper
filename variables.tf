variable "input" {
  description = "The value to store in state. The `output` output parameter will be updated to match this input parameter whenver the `triggers` input parameter changes."
  type = any
  default = null
}

variable "triggers" {
  description = "A value of any type that, when changed, causes the `output` output parameter to be updated to match the `input` input parameter."
  type = any
  default = null
}

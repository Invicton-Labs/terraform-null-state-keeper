output "output" {
  description = "The value that is stored in state post-apply."
  value       = local.output
}

output "existing_value" {
  description = "The value that was stored in state pre-apply. Only provided if the `read_existing_value` input parameter was `true`."
  value       = local.existing_value
}

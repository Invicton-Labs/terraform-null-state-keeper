// Get the existing state
module "state" {
  source  = "Invicton-Labs/get-state/null"
  version = "~> 0.2.3"
  count   = var.read_existing_value ? 1 : 0
}

// A unique ID for this module
resource "random_uuid" "module_id" {}

locals {
  // If we want to read the existing value, try to find it in the existing state
  existing_resources = var.read_existing_value ? [
    for address, resource in module.state[0].resources :
    resource
    // We're looking for the resource that has the module ID in its prefix
    if resource.type == "random_id" && resource.name == "outputs" ? length(regexall(random_uuid.module_id.id, resource.instances[0].attributes.prefix)) > 0 : false
  ] : []
  existing_value = length(local.existing_resources) > 0 ? jsondecode(split(local.output_separator, local.existing_resources[0].instances[0].attributes.prefix)[0]) : null
}

locals {
  // Use a newline for the separator because neither jsonencode() nor base64-encoding will ever return a value with newlines
  output_separator = "\n"
}

// Use this as a resourced-based method to take an input that might change,
// but the triggers haven't changed, and maintain the same output.
resource "random_id" "outputs" {
  // Reload the data when the trigger changes
  // We mark this as sensitive just so it doesn't have a massive output in the Terraform plan
  keepers = sensitive({
    trigger = jsonencode(var.triggers)
  })
  byte_length = 1
  // Feed the output values in as prefix. Then we can extract them from the output of this resource,
  // which will only change when the input triggers change.
  // Mark it as sensitive to try to prevent Terraform from outputting massive text blocks into the plan
  prefix = sensitive("${jsonencode(var.input)}${local.output_separator}${random_uuid.module_id.id}")
  // Changes to the prefix shouldn't trigger a recreate; only the triggers should
  lifecycle {
    ignore_changes = [
      prefix
    ]
    // Don't delete the old state until the new one is successfully created
    create_before_destroy = true
  }
}

locals {
  // Remove the random ID off the random ID and extract only the prefix
  output_segments = split(local.output_separator, random_id.outputs.b64_std)
  output          = nonsensitive(jsondecode(local.output_segments[0]))
}

module "assertion" {
  source        = "Invicton-Labs/assertion/null"
  version       = "~> 0.2.8"
  condition     = length(local.output_segments) == 2
  error_message = "The state keeper output contains the special separator string: ${random_id.outputs.b64_std}"
}

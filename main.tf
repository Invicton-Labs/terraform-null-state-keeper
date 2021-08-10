locals {
    // Use newlines because neither jsonencode() nor base64-encoding will ever return a value with newlines
    output_separator = "\n"
}

// Use this as a resourced-based method to take an input that might change,
// but the triggers haven't changed, and maintain the same output.
resource "random_id" "outputs" {
  // Reload the data when the trigger changes
  keepers     = {
      trigger = jsonencode(var.triggers)
  }
  byte_length = 1
  // Feed the output values in as prefix. Then we can extract them from the output of this resource,
  // which will only change when the input triggers change
  prefix = "${jsonencode(var.input)}${local.output_separator}"
  // Changes to the prefix shouldn't trigger a recreate; only the triggers should
  lifecycle {
    ignore_changes = [
      prefix
    ]
  }
}

locals {
  // Remove the random ID off the random ID and extract only the prefix
  output_segments = split(local.output_separator, random_id.outputs.b64_std)
  output = jsondecode(local.output_segments[0])
}

module "assertion" {
  source  = "Invicton-Labs/assertion/null"
  version = "0.2.1"
  condition = length(local.output_segments) == 2
  error_message = "The state keeper output contains the special separator string: ${random_id.outputs.b64_std}"
}
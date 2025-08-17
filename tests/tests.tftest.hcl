run "test" {
  command = apply
  module {
    source = "./"
  }
  variables {
    input = "hello world"
    triggers = {
      foo = "bar"
    }
  }
  assert {
    // We have to compare with jsonencode, because the result has "dynamic" type
    // fields, while the expected value has fixed type fields.
    condition     = output.output == "hello world"
    error_message = "Unexpected output: ${jsonencode(output.output)}"
  }
}

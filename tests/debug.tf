module "state_keeper" {
  source = "../"
  input  = "hello world"
  triggers = {
    foo = plantimestamp()
  }
}

output "value" {
  value = module.state_keeper.output
}

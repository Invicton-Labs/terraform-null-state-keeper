# Terraform State Keeper

This module allows you to keep an arbitrary value stored in state, and retain the same value until a trigger is changed.

## Usage

```
module "state-keeper" {
  source = "Invicton-Labs/state-keeper/null"

  // The value that should be stored in state (refreshed only when the triggers change)
  // Note that even though this input value changes each run, the output only changes when the triggers change
  input = uuid()

  // When this value changes, update the output to match the current input
  triggers = {
    anything = 1
    you = "string"
    want = [1, 4, 8]
  }
}

output "state-keeper" {
  value = module.state-keeper.output
}
```

### Run 1
```
Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

Outputs:

state-keeper = "0ce83443-e39b-bba6-dcdb-e26446c3b549"
```

### Run 2 (no code change)
The output has not changed:
```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

state-keeper = "0ce83443-e39b-bba6-dcdb-e26446c3b549"
```

### Run 3 (change triggers)
```
module "state-keeper" {
  source = "Invicton-Labs/state-keeper/null"

  // The value that should be stored in state (refreshed only when the triggers change)
  // Note that even though this input value changes each run, the output only changes when the triggers change
  input = uuid()

  // When this value changes, update the output to match the current input
  triggers = {
    anything = "new"
    you = "values"
    want = [2, 2, 2]
  }
}

output "state-keeper" {
  value = module.state-keeper.output
}
```

The output now shows a new value:
```
Apply complete! Resources: 1 added, 0 changed, 1 destroyed.

Outputs:

state-keeper = "50b71b15-e2a9-fc09-2ed1-1a63525aa025"
```

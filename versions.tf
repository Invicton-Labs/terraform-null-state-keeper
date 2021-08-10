terraform {
  required_version = ">= 0.13.0"
  required_providers {
    external = {
      source  = "hashicorp/random"
      version = ">= 3.1.0"
    }
  }
}

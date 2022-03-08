locals {
  region = {
    "qa"   = "us-east-2"
    "prod" = "us-east-1"
  }
}

locals {
  environment = terraform.workspace
}
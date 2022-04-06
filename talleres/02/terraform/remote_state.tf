terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.8.0"
    }
  }
}
terraform {
   backend "s3" {
     bucket               = "bi-sre-terraform-state"
     key                  = "terraform.tfstate"
     region               = "us-east-1"
     dynamodb_table       = "bi-sre-terraform-state"
     workspace_key_prefix = "bi/env:"
     encrypt              = true
   }
}

 data "terraform_remote_state" "state" {
   backend = "s3"
   config = {
     bucket = "bi-sre-terraform-state"
     key    = "bi/env:/${local.environment}/terraform.tfstate"
     region = "us-east-1"
   }
 }

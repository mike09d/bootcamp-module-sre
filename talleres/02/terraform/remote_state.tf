terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.3.0"
    }
  }
}

terraform {
   backend "s3" {
     bucket               = "bs-sre"
     key                  = "terraform.tfstate"
     region               = "us-east-1"
     dynamodb_table       = "bi-sre-terraform-state"
     workspace_key_prefix = "bi/env:"
     encrypt              = true
   }
}
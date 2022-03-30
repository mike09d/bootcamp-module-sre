# TERRAFORM STATE REMOTE S3

1. Creamos un bucket s3 en la cuenta llamado `bi-sre-terraform-state` con las configuraciones por defecto
2. Creamos una tabla en dynamodb
    2.1 DynamoDB > Tables > Create table
    - *Table name*: `bi-sre-terraform-state`
    - *Partition key*: `LockID`
    Clic en `Create table`

3. Adicionar el siguiente código al archivo `talleres/02/terraform/remote_state.tf`

```
terraform {
   backend "s3" {
     bucket               = "<<REEMPLAZAR_NOMBRE_BUCKET>>"
     key                  = "terraform.tfstate"
     region               = "us-east-1"
     dynamodb_table       = "bi-sre-terraform-state"
     workspace_key_prefix = "bi/env:"
     encrypt              = true
   }
}
```

```
data "terraform_remote_state" "state" {
   backend = "s3"
   config = {
     bucket = "<<REEMPLAZAR_NOMBRE_BUCKET>>"
     key    = "bi/env:/${local.environment}/terraform.tfstate"
     region = "us-east-1"
   }
 }
 ```
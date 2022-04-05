variable "project_name" {
    default = "mythicalmysfits"
}

variable "cluster_name" {
    default = "bi_mf_backend"
}



variable "name" {
          type        = string
          description = "nombre de la aplicación"
          default = "mf"
        }
        
        variable "environment" {
          description = "Environment name"
          default = "dev"
        }
        
        variable "private_subnet_ids" {
          type        = list(string)
          description = "ids de las redes privadas"
          default = []
        }
        
        
        variable "public_subnet_ids" {
          type        = list(string)
          description = "ids de las redes publicas"
          default = []
        }
        
        variable "vpc_id" {
          type        = string
          description = "El id de la vpc donde el ECS container seria desplegado"
          default = 0
        }
        
        variable "app_port" {
          type = number
          default = 9000
        }
        
        # variable "cluster_id" {
        #   type = string
        # }
        
        
        variable "fargate_cpu" {
          type = number
          default = 2048
        }
        
        variable "fargate_memory" {
          type = number
          default = 4096
        }
        
        variable "app_image" {
          type = string
          description = "Imagen que utilizara la aplacion en la task definition"
          default = "878223269625.dkr.ecr.us-east-1.amazonaws.com/mf"
        }
        
        
        # variable "replicas" {
        #   type = string
        #   description = "El número de instancias de la task definition"
        # }
        
        # variable "aws_security_group_ecs_tasks_id" {
        #   type = string 
        #   description = "The ID of the security group for the ECS tasks"
        # }
        
        # variable "region" {
        #   type = string 
        #   description = "The AWS region where resources have been deployed"
        # }
        
        # variable "auto_scaling_max_replicas" {
        #   type = number
        # }
        
        # variable "auto_scaling_max_cpu_util" {
        #   type = number
        # }
        
        # variable "auto_scaling_max_memory_util" {
        #   type = number
        # }
        
        variable "environment_variables"{
        default = []
        }
        
        variable "nlb_tg_arn" {
          default = ""
        }
        
        variable "nlb_tg_arn_suffix" {
          default = ""
        }
        
        variable "nlb_arn_suffix" {
          default = ""
        }
        
        
        variable "app_port_lb" {
          default = 80
        }
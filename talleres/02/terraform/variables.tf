variable "project_name" {
    default = "mythicalmysfits"
}

variable "cluster_name" {
    default = "bi_mf_backend"
}

variable "access_key" {
  sensitive = true
  type = string
}

variable "secret_key" {
  sensitive = true
  type = string
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
          default = 8080
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
        
        
        variable "replicas" {
          type = string
          description = "El número de instancias de la task definition"
          default = 2
        }
        
        # variable "aws_security_group_ecs_tasks_id" {
        #   type = string 
        #   description = "The ID of the security group for the ECS tasks"
        # }
        
        variable "region" {
          type = string 
          description = "The AWS region where resources have been deployed"
          default = "us-east-1"
        }
        
        variable "auto_scaling_max_replicas" {
          type = number
          default = 10
        }
        
        variable "auto_scaling_max_cpu_util" {
          type = number
          default = 60
        }
        
        variable "auto_scaling_max_memory_util" {
          type = number
          default = 80
        }
        
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
        
        
        
  # EKS
  
  
  variable "cluster_name_eks" {
  description = "the name of your stack, e.g. \"demo\""
  default = "mf"
}


variable "eks_node_group_instance_types" {
  description  = "Instance type of node group"
  default = "t2.micro"
}

variable "disk_size" {
  type = number
  default = "20"
}
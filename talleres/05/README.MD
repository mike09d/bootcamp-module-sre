# Amazon Container Service
Servicio de orquestación de contenedores completamente administrado.

## Pasos
En el proyecto de modularizacion creamos el directorio llamado *ECS*, al interior creamos los siguientes dos modulos:

1. Creamos un modulo llamado *cluster*

```
    resource "aws_ecs_cluster" "main" {
      name = var.cluster_name
    }
```

2. A continuación crearemos un modulo llamado *fargate* con los siguientes recursos

Se relacionan los siguientes archivos los cuales se deben complementar y modularizar:

Crear las políticas en un directorio llamado *policies*:

Nombre del archivo *appautoscaling-role-policy.json*
    ```
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Action": [
                        "ecs:DescribeServices",
                        "ecs:UpdateService",
                        "cloudwatch:PutMetricAlarm",
                        "cloudwatch:DescribeAlarms",
                        "cloudwatch:DeleteAlarms"
                    ],
                    "Resource": [
                        "*"
                    ]
                }
            ]
      }
    ```
Nombre del archivo *appautoscaling-role.json*
    ```
        {
            "Version": "2012-10-17",
            "Statement": [
              {
                "Effect": "Allow",
                "Principal": {
                  "Service": "ecs.application-autoscaling.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
              }
            ]
        }
    ```

- variables.tf

    ```
          variable "name" {
          type        = string
          description = "nombre de la aplicación"
        }
        
        variable "environment" {
          description = "Environment name"
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
        }
        
        variable "app_port" {
          type = number
        }
        
        variable "cluster_id" {
          type = string
        }
        
        
        variable "fargate_cpu" {
          type = number
        }
        
        variable "fargate_memory" {
          type = number
        }
        
        variable "app_image" {
          type = string
          description = "Imagen que utilizara la aplacion en la task definition"
        }
        
        
        variable "replicas" {
          type = string
          description = "El número de instancias de la task definition"
        }
        
        variable "aws_security_group_ecs_tasks_id" {
          type = string 
          description = "The ID of the security group for the ECS tasks"
        }
        
        variable "region" {
          type = string 
          description = "The AWS region where resources have been deployed"
        }
        
        variable "cluster_name" {
          type = string
        }
        
        variable "auto_scaling_max_replicas" {
          type = number
        }
        
        variable "auto_scaling_max_cpu_util" {
          type = number
        }
        
        variable "auto_scaling_max_memory_util" {
          type = number
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
    ```
- service.tf
        ```
        resource "aws_ecs_service" "main" {
                  name            = "${var.name}-service"
                  cluster         = var.cluster_id
                  task_definition = aws_ecs_task_definition.main.family
                  desired_count   = var.replicas
                  launch_type = "FARGATE"
                
                  network_configuration {
                    security_groups = ["${var.aws_security_group_ecs_tasks_id}"]
                    subnets = var.private_subnet_ids
                  }
                
                  load_balancer {
                    target_group_arn = var.nlb_tg_arn
                    container_name   = var.name
                    container_port   = var.app_port
                  }
                
                  depends_on = [
                    aws_ecs_task_definition.main
                  ]
                }
        ```

        ```
            resource "aws_iam_role" "autoscaling" {
                  name               = "${var.name}-${terraform.workspace}-appautoscaling-role"
                  assume_role_policy = file("${path.module}/policies/appautoscaling-role.json")
                }
        ```
        
        ```
            resource "aws_iam_role_policy" "autoscaling" {
              name   = "${var.name}-${terraform.workspace}-appautoscaling-policy"
              policy = file("${path.module}/policies/appautoscaling-role-policy.json")
              role   = aws_iam_role.autoscaling.id
            }
        ```
        
        ```
            resource "aws_appautoscaling_target" "this" {
                  max_capacity       = var.auto_scaling_max_replicas
                  min_capacity       = var.replicas
                  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
                  role_arn           = aws_iam_role.autoscaling.arn
                  scalable_dimension = "ecs:service:DesiredCount"
                  service_namespace  = "ecs"
                
                  depends_on = [aws_ecs_service.main]
                }
        ```
        
        ```
            resource "aws_appautoscaling_policy" "memory" {
              name               = "${aws_ecs_service.main.name}-autoscaling-memory-policy"
              policy_type        = "TargetTrackingScaling"
              resource_id        = aws_appautoscaling_target.this.resource_id
              scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
              service_namespace  = aws_appautoscaling_target.this.service_namespace
            
              target_tracking_scaling_policy_configuration {
                target_value = var.auto_scaling_max_memory_util
            
                scale_in_cooldown  = 300
                scale_out_cooldown = 300
            
                predefined_metric_specification {
                  predefined_metric_type = "ECSServiceAverageMemoryUtilization"
                }
              }
            
              depends_on = [aws_appautoscaling_target.this]
            }

        ```
        
        ```
        resource "aws_appautoscaling_policy" "this" {
              name               = "${aws_ecs_service.main.name}-autoscaling-cpu-policy"
              policy_type        = "TargetTrackingScaling"
              resource_id        = aws_appautoscaling_target.this.resource_id
              scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
              service_namespace  = aws_appautoscaling_target.this.service_namespace
            
              target_tracking_scaling_policy_configuration {
                target_value = var.auto_scaling_max_cpu_util
            
                scale_in_cooldown  = 300
                scale_out_cooldown = 300
            
                predefined_metric_specification {
                  predefined_metric_type = "ECSServiceAverageCPUUtilization"
                }
              }
            
              depends_on = [aws_appautoscaling_target.this]
            }

        ```
- task_definition.tf

    ```
        resource "aws_ecs_task_definition" "main" {
                  family                   = var.name
                  task_role_arn = aws_iam_role.task_role.arn
                  execution_role_arn = aws_iam_role.main_ecs_tasks.arn
                  network_mode             = "awsvpc"
                  requires_compatibilities = ["FARGATE"]
                  cpu                      = var.fargate_cpu
                  memory                   = var.fargate_memory
                  container_definitions = jsonencode([
                    {
                      name        = var.name
                      image       = var.app_image
                      cpu         = var.fargate_cpu
                      memory      = var.fargate_memory
                      networkMode = "awsvpc"
                      ulimits = [
                                {
                                  "name": "nofile",
                                  "softLimit": 65536,
                                  "hardLimit": 65536
                                }
                              ]
                      portMappings = [
                        {
                          containerPort = var.app_port
                          protocol      = "tcp"
                          hostPort      = var.app_port
                        }
                      ]
                      environment = var.environment_variables
                      logConfiguration : {
                        logDriver : "awslogs"
                        options : {
                          awslogs-group = "awslogs/${var.name}/fargate"
                          awslogs-region = "us-east-1"
                          awslogs-stream-prefix = "streaming"
                          awslogs-create-group = "true"
                        }
                      }
                    }
                  ])
                }

    ```

- role.tf

```
    resource "aws_iam_role" "task_role" {
      name = "ecs_tasks-${var.name}-role"
      assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
          },
          "Effect": "Allow"
        }
      ]
    }
    EOF
    }
    
    resource "aws_iam_role" "main_ecs_tasks" {
      name = "main_ecs_tasks-${var.name}-role"
      assume_role_policy = <<EOF
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Action": "sts:AssumeRole",
          "Principal": {
            "Service": "ecs-tasks.amazonaws.com"
          },
          "Effect": "Allow"
        }
      ]
    }
    EOF
    }
    
    resource "aws_iam_role_policy" "main_ecs_tasks" {
      name = "main_ecs_tasks-${var.name}-policy"
      role = aws_iam_role.main_ecs_tasks.id
    
      policy = <<EOF
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "s3:Get*",
                    "s3:List*"
                ],
                "Resource": ["*"]
            },
            {
                "Effect": "Allow",
                "Action": "*",
                "Resource": ["*"]
            },
            {
                "Effect": "Allow",
                "Resource": [
                  "*"
                ],
                "Action": [
                    "ecr:GetAuthorizationToken",
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:GetDownloadUrlForLayer",
                    "ecr:BatchGetImage",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                    "logs:CreateLogGroup",
                    "logs:DescribeLogStreams"
                ]
            }
        ]
    
    }
    EOF
    }
```


3. Relacionamos los modulos a referenciar para realizar el aprovisionamiento (se debe complementar):
```
module "ecs_sg" {
  source       = "<<REEMPLAZAR_RUTA_MODULO>>"
  environment = var.environment
  vpc_id = <<REEMPLAZAR_VPCID>>
  app_port = var.app_port
  vpc_cidr = var.vpc_cidr
  security_group_ecs_tasks_name = "mf"
}

module "ecs_cluster" {
  source       = "<<REEMPLAZAR_RUTA_MODULO>>"
  cluster_name = "${var.vpc_name}-cluster-${var.environment}"
}

module "fargate_mf" {
  source      = "<<REEMPLAZAR_RUTA_MODULO>>"
  name        = "mf-${var.environment}"
  environment = var.environment
  vpc_id      = <<REEMPLAZAR_VPCID>>

  # Service
  cluster_name                    = module.ecs_cluster.cluster_name
  cluster_id                      = module.ecs_cluster.id
  replicas                        = 1
  aws_security_group_ecs_tasks_id = module.ecs_sg.ecs_tasks_security_group_id
  private_subnet_ids              = module.vpc-operations-prod.aws_subnets_private
  region                          = local.region[local.environment]
  auto_scaling_max_replicas       = 10 # numero asigna el max de replicas qeu el servicio escala hacia arriba.
  auto_scaling_max_cpu_util       = 60 # el porcentage de utiizacion de CPU para disparar el auto scaling
  auto_scaling_max_memory_util    = 80

  # taskdefinition
  app_image      = module.mf_ecr_backend.repository_url
  app_port = var.app_port
  fargate_cpu    = 2048
  fargate_memory = 4096

  # LoadBalancer nlb
  nlb_tg_arn = module.mf_alb.lb_tgw_arn

  depends_on = [module.mf_alb]
}

module "mf_alb" 
  source      = "<<REEMPLAZAR_RUTA_MODULO>>"
  name        = "mf-alb-${var.environment}"
  environment = var.environment
  vpc_id      = <<REEMPLAZAR_VPCID>>
  private_subnet_ids  = <<REEMPLAR_SUBNETS_PRIVATES_IDS>>
  app_port = var.app_port
  health_check_path = "/"
}

```

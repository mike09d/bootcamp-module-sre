      resource "aws_ecs_service" "main" {
                  name            = "${var.name}-service"
                  # cluster         = var.cluster_id
                  cluster         = aws_ecs_cluster.main.id
                  task_definition = aws_ecs_task_definition.main.family
                  desired_count   = var.replicas
                  launch_type = "FARGATE"
                
                  network_configuration {
                    #security_groups = ["${var.aws_security_group_ecs_tasks_id}"]
                    
                    security_groups = ["${module.sgs.ids[0]}"]
                    
                    #subnets = var.private_subnet_ids
                    subnets = data.aws_subnet_ids.private.ids
                    assign_public_ip = true
                  }
                
                #   load_balancer {
                #     target_group_arn = var.nlb_tg_arn
                #     container_name   = var.name
                #     container_port   = var.app_port
                #   }
                
                  depends_on = [
                    aws_ecs_task_definition.main
                  ]
                  lifecycle {
                    create_before_destroy = true
                  }
                }
                
                
resource "aws_iam_role" "autoscaling" {
                  name               = "${var.name}-${terraform.workspace}-appautoscaling-role"
                  assume_role_policy = file("./policies/appautoscaling-role.json")
                }
                
resource "aws_iam_role_policy" "autoscaling" {
              name   = "${var.name}-${terraform.workspace}-appautoscaling-policy"
              policy = file("./policies/appautoscaling-role-policy.json")
              role   = aws_iam_role.autoscaling.id
            }
            
resource "aws_appautoscaling_target" "this" {
                  max_capacity       = var.auto_scaling_max_replicas
                  min_capacity       = var.replicas
                  resource_id        = "service/${var.cluster_name}/${aws_ecs_service.main.name}"
                  role_arn           = aws_iam_role.autoscaling.arn
                  scalable_dimension = "ecs:service:DesiredCount"
                  service_namespace  = "ecs"
                
                  depends_on = [aws_ecs_service.main]
                }
                
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
resource "aws_ecs_cluster" "main" {
      count = local.environment == "ecs" ? 1 : 0
      name = var.cluster_name
    }
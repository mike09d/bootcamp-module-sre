resource "aws_lb" "alb" {
count = local.environment == "ecs" ? 1 : 0
  name               = "${var.name}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.private.ids

  security_groups    = [aws_security_group.main[0].id]

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_lb_target_group" "main" {
count = local.environment == "ecs" ? 1 : 0
    name = "${var.name}-albtg-${var.environment}"
    port = var.app_port
    protocol = "HTTP"
    vpc_id   = data.aws_vpc.default.id
    target_type = "ip"
}

resource "aws_lb_listener" "alb_listener" {
count = local.environment == "ecs" ? 1 : 0
  load_balancer_arn = aws_lb.alb[0].arn
  port              = var.app_port_lb
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[0].arn
  }
}

resource "aws_security_group" "main" {
count = local.environment == "ecs" ? 1 : 0
  name        = "${var.name}-${var.environment}"
  description = "LoadBalancer"
  vpc_id      = data.aws_vpc.default.id
  tags = {
    Name = "${var.name}-${var.environment}"
  }

  ingress {
    protocol    = "TCP"
    from_port   = var.app_port_lb
    to_port     = var.app_port_lb
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}
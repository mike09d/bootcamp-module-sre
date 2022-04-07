# configuración de ALB

## Realizar la configuración de los siguientes recursos

- main.tf

```
resource "aws_lb" "alb" {
  name               = "${var.name}-alb-${var.environment}"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.private_subnet_ids

  security_groups    = [aws_security_group.main.id]

  enable_deletion_protection = false
  enable_cross_zone_load_balancing = true

  tags = {
    Environment = "${var.environment}"
  }
}
```

```

resource "aws_lb_target_group" "main" {
    name = "${var.name}-albtg-${var.environment}"
    port = var.app_port
    protocol = "HTTP"
    vpc_id   = var.vpc_id
    target_type = "ip"
}

```

```

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.app_port_lb
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

```

- variables.tf

```
variable "name" {
  
}

variable "environment" {
  
}

variable "private_subnet_ids" {
  
}

variable "vpc_id" {
  
}

variable "certificate_arn" {
  default = ""
  
}

variable "app_port" {
  
}

variable "internal" {
  default = true
}

variable "health_check_path" {
  default = "/"
}

variable "app_port_lb" {
  default = 80
}
```

- sg.tf

```
resource "aws_security_group" "main" {
  name        = "${var.name}-${var.environment}"
  description = "LoadBalancer"
  vpc_id      = var.vpc_id
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
```

- outputs.tf

```
output aws_lb_arn {
  value       =  aws_lb.nlb.arn
}

output lb_tgw_arn {
  value       =  aws_lb_target_group.main.arn
}
```
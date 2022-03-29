resource "aws_lb" "main" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = var.subnet_ids_private

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "main" {
  name        = "${var.project_name}-tg-main"
#   target_type = "instance"
  port        = 8000
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
}

resource "aws_autoscaling_attachment" "asg_attachment_elb" {
  autoscaling_group_name = var.ag_backend_id
  alb_target_group_arn = aws_lb_target_group.main.arn
}

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}
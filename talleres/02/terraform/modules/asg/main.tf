data "template_file" "user_data" {
template = "${file("${path.module}/scripts/init.sh")}"
}

resource "aws_launch_configuration" "main" {
  name_prefix   = "${var.project_name}-lc-main"
  image_id      = "ami-04505e74c0741db8d"
  instance_type = var.instance_type
  user_data = "${data.template_file.user_data.rendered}"
  iam_instance_profile = "ssm-role"
  security_groups = [var.sg_id]


  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "backend" {
  name                 = "${var.project_name}-asg-main"
  launch_configuration = aws_launch_configuration.main.name
  min_size             = 1
  max_size             = 4
  vpc_zone_identifier = var.subnet_ids_private
  force_delete              = true
    target_group_arns = [var.lb_target_arn] #  A list of aws_alb_target_group ARNs, for use with Application or Network Load Balancing.
  lifecycle {
    create_before_destroy = true
  }
  
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  metrics_granularity = "1Minute"

 tag {
    key                 = "Name"
    value               = "backend"
    propagate_at_launch = true
  }

  depends_on = [aws_launch_configuration.main]
}
resource "aws_autoscaling_group" "main" {
  name                      = "${var.project_name}-asg"
  max_size                  = 9
  min_size                  = 3
  health_check_type         = "ELB"
  vpc_zone_identifier       = var.private_subnet_ids
  target_group_arns  = [aws_lb_target_group.main.arn] 


  launch_template {
    id      = var.launch_template_id
    version = var.launch_template_version
  }


  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg-instance"
    propagate_at_launch = true
  }

}

resource "aws_autoscaling_policy" "scaleUp" {
  name                   = "${var.project_name}-asg-up"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.main.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 70.0
  }
}

resource "aws_autoscaling_policy" "scaleDown" {
  name                   = "${var.project_name}-asg-down"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300
  autoscaling_group_name = aws_autoscaling_group.main.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 20.0
  }
}
output "alb_security_groups_id" {
  value = aws_security_group.alb.id
}

output "ec2_security_groups_id" {
  value = aws_security_group.ec2.id
}

output "launch_template_version" {
  value = aws_launch_template.main.latest_version
}

output "launch_template_id" {
  value = aws_launch_template.main.id
}
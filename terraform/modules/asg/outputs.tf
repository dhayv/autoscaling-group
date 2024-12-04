output "autoscaling_group_id" {
  value = aws_autoscaling_group.main.id
}

output "autoscaling_group_name" {
  value = aws_autoscaling_group.main.name
}

output "autoscaling_group_arn" {
  value = aws_autoscaling_group.main.arn
}

output "autoscaling_policy_up_arn" {
  value = aws_autoscaling_policy.scaleUp.arn
}

output "autoscaling_policy_dwn_arn" {
  value = aws_autoscaling_policy.scaleDown.arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "alb_dns_id" {
  value = aws_lb.main.id
}

output "lb_target_group_arn" {
  value = aws_lb_target_group.main.arn
}
output "aws_alb_target_group_arn" {
  value = aws_alb_target_group.main.arn
}

output "alb_dns_name" {
  value = aws_lb.main.dns_name
}

output "alb_zone_id" {
  value = aws_lb.main.zone_id
}

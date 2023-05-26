
output "private_lb_dns_name" {
  value       = aws_lb.private_lb.dns_name
  description = "The domain name of the load balancer"
}


output "private_lb_arn" {
  value       = aws_lb.private_lb.arn
  description = "The ARN of the ELB"
}

output "private_lb_target_group_arn" {
  value = aws_lb_target_group.private_target_group_name.arn
}
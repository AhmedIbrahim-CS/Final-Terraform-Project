output "public_lb_dns_name" {
  value       = aws_lb.public_lb.dns_name
  description = "The domain name of the load balancer"
}


output "public_lb_arn" {
  value       = aws_lb.public_lb.arn
  description = "The ARN of the ELB"
}

output "public_lb_target_group_arn" {
  value = aws_lb_target_group.public_target_group_name.arn
}
output "public_lb_security_group_id" {
  value       = aws_security_group.public_lb.id
  description = "The ID of the public load balancer security group."
}
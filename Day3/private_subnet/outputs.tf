output "private_subnet_id_1" {
  description = "private_subnet ID"
  value       = aws_subnet.private[0].id
}

output "private_subnet_id_2" {
  description = "private_subnet ID"
  value       = aws_subnet.private[1].id
}
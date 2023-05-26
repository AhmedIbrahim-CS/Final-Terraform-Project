output "public_subnet_id_1" {
  description = "public_subnet ID"
  value       = aws_subnet.public[0].id
}

output "public_subnet_id_2" {
  description = "public_subnet ID"
  value       = aws_subnet.public[1].id
}
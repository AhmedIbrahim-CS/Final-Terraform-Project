output "public_route_table" {
  value       = aws_route_table.public_rt.id
  description = "The ID of the public route table."
}
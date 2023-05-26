output "public_ec2_ids" {
  value = [for instance in aws_instance.public_ec2 : instance.id]
}
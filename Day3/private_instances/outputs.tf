output "private_ec2_ids" {
  value = [for instance in aws_instance.private_ec2 : instance.id]
}
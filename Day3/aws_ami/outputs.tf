output "instance_id" {
  description = "ID of the EC2 instance"
  value       = data.aws_ami.ubuntu.id
}
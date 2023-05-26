variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}



variable "ami_id" {
  type = string
}

variable "public_ec2_security_group_id" {
  type = string
}

variable "public_subnet_id" {
  type = list(string)
}



variable "private_elb_dns_name" {
  type = string
}



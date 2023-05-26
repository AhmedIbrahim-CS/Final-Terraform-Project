variable "tags" {
  type = list(string)
}



variable "ami_id" {
  type = string
}



variable "private_ec2_security_group_id" {
}



variable "private_subnet_id" {
  type = list(string)
}


variable "vpc_id" {
  type = string
}

variable "name" {
  type = string
}
variable "security_grouplb" {
    type = list(string)

}

variable "load_balancer_type" {
  type = string
}
variable "port" {
  type = string
}
variable "subnets" {
  type = list(string)
}
variable "protocol" {
  type = string
}
variable "private_target_group_name" {
  type = string
}
variable "private_ec2" {
  type = list(string)
}

variable "name" {
  type = string
}

variable "load_balancer_type" {
  type = string
}

variable "subnets" {
  type = list(string)
}

variable "security_grouplb" {
    type = list(string)

}


variable "vpc_id" {
  type = string
}


variable "public_ec2" {
  type = list(string)

}


variable "port" {
  type = string
}

variable "protocol" {
  type = string
}


variable "public_target_group_name" {
  type = string
}



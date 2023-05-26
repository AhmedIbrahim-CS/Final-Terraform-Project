variable "tags" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "nat_id" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

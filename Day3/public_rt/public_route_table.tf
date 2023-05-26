resource "aws_route_table" "public_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = var.igw_id
  }

  tags = {
    Name = var.tags[0]
  }
}

resource "aws_route_table_association" "public_rt_association" {
  count          = length(var.subnet_id)
  subnet_id      = var.subnet_id[count.index]
  route_table_id = aws_route_table.public_rt.id
}
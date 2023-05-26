resource "aws_route_table" "private_rt" {
  vpc_id = var.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = var.nat_id
  }

  tags = {
    Name = var.tags[0]
  }
}

resource "aws_route_table_association" "private_rt_association" {
  count          = 2
  subnet_id      = var.subnet_ids[count.index]
  route_table_id = aws_route_table.private_rt.id

}
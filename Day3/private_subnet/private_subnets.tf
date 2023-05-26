resource "aws_subnet" "private" {
  count = 2

  vpc_id            = var.vpc_id
  cidr_block        = count.index == 0 ? "10.0.1.0/24" : "10.0.3.0/24"
  availability_zone = count.index == 0 ? "us-east-1a" : "us-east-1b"

  tags = {
    Name = var.tags[0]
  }
}

resource "aws_subnet" "public" {
  count = 2

  vpc_id            = var.vpc_id
  cidr_block        = count.index == 0 ? "10.0.0.0/24" : "10.0.2.0/24"
  availability_zone = count.index == 0 ? "us-east-1a" : "us-east-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = var.tags[0]
  }
}
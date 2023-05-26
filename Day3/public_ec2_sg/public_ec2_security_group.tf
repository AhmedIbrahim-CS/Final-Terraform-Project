resource "aws_security_group" "public_ec2" {
  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
    }
  }



  egress {
    from_port   = var.egress_rules[0].from_port
    to_port     = var.egress_rules[0].to_port
    protocol    = var.egress_rules[0].protocol
    cidr_blocks = var.egress_rules[0].cidr_blocks
  }
  tags = {
    Name = var.tags[0]
  }
}

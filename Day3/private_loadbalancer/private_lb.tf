resource "aws_lb" "private_lb" {
  name               = var.name
  internal           = true
  load_balancer_type = var.load_balancer_type
  subnets            = var.subnets
  security_groups    = var.security_grouplb



  #enable_deletion_protection = true
}

resource "aws_lb_listener" "private_listener" {
  load_balancer_arn = aws_lb.private_lb.arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.private_target_group_name.arn
  }
}


resource "aws_lb_target_group" "private_target_group_name" {
  name        = var.private_target_group_name
  vpc_id      = var.vpc_id
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
}

resource "aws_lb_target_group_attachment" "attachment" {
  count            = length(var.private_ec2)
  target_group_arn = aws_lb_target_group.private_target_group_name.arn
  target_id        = var.private_ec2[count.index]
  port             = var.port
}

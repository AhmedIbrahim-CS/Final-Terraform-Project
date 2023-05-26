resource "aws_lb" "public_lb" {
  name               = var.name
  internal           = false
  load_balancer_type = var.load_balancer_type
  subnets            = var.subnets
  security_groups    = var.security_grouplb


}

resource "aws_lb_listener" "public_listener" {
  load_balancer_arn = aws_lb.public_lb.arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.public_target_group_name.arn
  }

}


resource "aws_lb_target_group" "public_target_group_name" {

  name        = var.public_target_group_name
  vpc_id      = var.vpc_id
  target_type = "instance"
  port        = 80
  protocol    = "HTTP"
}

resource "aws_lb_target_group_attachment" "aws_public_lb_target_group_attachment" {
  count            = length(var.public_ec2)
  target_group_arn = aws_lb_target_group.public_target_group_name.arn
  target_id        = var.public_ec2[count.index]
  port             = var.port
}


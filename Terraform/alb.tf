resource "aws_lb" "ab_alb" {
  name               = "BlueGreenALB"
  load_balancer_type = "application"
  subnets            = [aws_subnet.subnet-a.id, aws_subnet.subnet-b.id]
}

resource "aws_lb_target_group" "a_target" {
  name     = "ATarget"
  port     = 5080
  protocol = "HTTP"
  vpc_id   = aws_vpc.projen-env.id

  health_check {
    protocol = "HTTP"
    path     = "/"
    port     = "traffic-port"
    matcher  = "200"
  }
}

resource "aws_lb_target_group" "b_target" {
  name     = "BTarget"
  port     = 5080
  protocol = "HTTP"
  vpc_id   = aws_vpc.projen-env.id

  health_check {
    protocol = "HTTP"
    path     = "/"
    port     = "traffic-port"
    matcher  = "200"
  }
}

resource "aws_lb_listener" "ab_alb" {
  load_balancer_arn = aws_lb.ab_alb.arn
  port              = 5080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.a_target.arn
  }

}

resource "aws_lb_target_group_attachment" "a_attachment" {
  target_group_arn = aws_lb_target_group.a_target.arn
  target_id        = aws_instance.app_server_1.id
  port             = 5080
}



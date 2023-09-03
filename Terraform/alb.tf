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

resource "aws_lb_target_group_attachment" "a_attachment" {
  target_group_arn = aws_lb_target_group.a_target.arn
  target_id        = aws_instance.app_server_1.id
  port             = 5080
}

resource "aws_lb_target_group_attachment" "b_attachment" {
  target_group_arn = aws_lb_target_group.b_target.arn
  target_id        = aws_instance.app_server_2.id
  port             = 5080
}


resource "aws_lb_listener" "ab_alb" {
  load_balancer_arn = aws_lb.ab_alb.arn
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [aws_lb_target_group.a_target, aws_lb_target_group.b_target]

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      status_code  = 200
      message_body = "OK"
    }
  }
}
      

resource "aws_lb_listener_rule" "ab_target_rule" {
  listener_arn = aws_lb_listener.ab_alb.arn
  priority     = 100

  action {
    type             = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.a_target.arn
        weight = 1
      }

      target_group {
        arn = aws_lb_target_group.b_target.arn
        weight = 1
      }
    }
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

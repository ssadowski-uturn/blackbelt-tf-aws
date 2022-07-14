resource "aws_lb" "capstone-ecs-lb" {
  name               = "capstone-ecs-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.capstone_ecs_sg.id]
  subnets = [data.aws_subnet.public_usw2a.id, data.aws_subnet.public_usw2b.id, data.aws_subnet.public_usw2c.id
  ]
}

# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener" "default_80" {
  load_balancer_arn = aws_lb.capstone-ecs-lb.arn
  port              = 80
  protocol          = "HTTP"
  # certificate_arn   = local.acm_certificate_arn.eu-west-2

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# Redirect all traffic from the ALB to the target group
resource "aws_lb_listener" "default_443" {
  load_balancer_arn = aws_lb.capstone-ecs-lb.arn
  port              = 443
  protocol          = "HTTPS"
  certificate_arn   = local.certificate_arns[0]

  default_action {
    type = "fixed-response"
    fixed_response {
      status_code  = "404"
      message_body = "Not Found"
      content_type = "text/plain"
    }
  }
}
# alb.tf

resource "aws_alb" "main" {
  name            = "django-load-balancer"
  subnets         = module.vpc.public_subnets
  security_groups = [aws_security_group.lb.id]
  depends_on = [module.vpc]
}

resource "aws_alb_target_group" "app" {
  name        = "django-target-group"
  port        = var.app_port
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = var.health_check_path
    unhealthy_threshold = "2"
  }
  depends_on = [module.vpc]
}

# Redirect all traffic from the ALB to the target group
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_alb.main.id
  port              = 80
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.app.id
    type             = "forward"
  }
  depends_on = [module.vpc]
}

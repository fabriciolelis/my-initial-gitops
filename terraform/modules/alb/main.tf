locals {
  prefix_name          = "${var.application}-${var.environment}"
  target_group_name    = "${local.prefix_name}-target-group"
  alb_name             = "${local.prefix_name}-alb"
  http_listeners_name  = "${local.prefix_name}-http-listerner"
  https_listeners_name = "${local.prefix_name}-https-listerner"
}

resource "aws_alb_target_group" "main" {
  name        = local.target_group_name
  port        = var.http_port
  protocol    = var.http_protocol
  vpc_id      = var.vpc_id
  target_type = "ip"

  health_check {
    healthy_threshold   = var.healthy_threshold
    interval            = var.interval
    protocol            = var.http_protocol
    matcher             = var.matcher
    path                = var.health_check_path
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.timeout
  }

  tags = merge(
    tomap({ "Service" = "Target Group" }),
    tomap({ "Name" = local.target_group_name })
  )
}

resource "aws_lb" "main" {
  name               = local.alb_name
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = var.alb_security_groups
  subnets            = var.subnets_ids

  enable_deletion_protection = false

  tags = merge(
    tomap({ "Service" = "Application Load Balancer" }),
    tomap({ "Name" = local.alb_name })
  )
}


resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = var.http_port
  protocol          = var.http_protocol

  default_action {
    type = "redirect"

    redirect {
      port        = var.https_port
      protocol    = var.https_protocol
      status_code = "HTTP_301"
    }
  }

  tags = merge(
    tomap({ "Service" = "Application Load Balancer HTTP Listeners" }),
    tomap({ "Name" = local.http_listeners_name })
  )
}

resource "aws_alb_listener" "https" {
  load_balancer_arn = aws_lb.main.id
  port              = var.https_port
  protocol          = var.https_protocol

  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.alb_tls_cert_arn

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }

  tags = merge(
    tomap({ "Service" = "Application Load Balancer HTTPS Listeners" }),
    tomap({ "Name" = local.https_listeners_name })
  )
}



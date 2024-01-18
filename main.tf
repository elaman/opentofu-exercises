terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# Data blocks reference exising resource.
data "aws_vpc" "default_vpc" {
  default = true
}
data "aws_subnet_ids" "default_subnet" {
  vpc_id = data.aws_vpc.default_vpc.id
}

resource "aws_instance" "drupal" {
  ami             = "ami-04075458d3b9f6a5b"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.instances.name]
  user_data       = <<-EOF
    #!/bin/bash
    echo "Hello world" > index.html
    python3 -m http.server 8080 &
    EOF
}

# Unlike variables you can define resources down the line from using it.
resource "aws_security_group" "instances" {
  name = "instance-security-group"
}
resource "aws_security_group_rule" "allow_http_inbound" {
  from_port         = 8080
  protocol          = "tcp"
  security_group_id = aws_security_group.instances.id
  to_port           = 8080
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group" "lb" {
  name = "load-balancer-security-group"
}
resource "aws_security_group_rule" "allow_lb_http_inbound" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.lb.id
  to_port           = 80
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
}
resource "aws_security_group_rule" "allow_lb_http_outbound" {
  from_port         = 0
  protocol          = "-1"
  security_group_id = aws_security_group.lb.id
  to_port           = 0
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.load_balancer.arn

  protocol = "HTTP"
  port = 80

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "page npt found"
      status_code = "404"
    }
  }
}
resource "aws_lb_target_group" "instances" {
  name = "drupal-target-group"
  port = 8080
  protocol = "HTTP"
  vpc_id = data.aws_vpc.default_vpc.id

  health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}
resource "aws_lb_target_group_attachment" "drupal" {
  target_group_arn = aws_lb_target_group.instances.arn
  target_id        = aws_instance.drupal.id
}
resource "aws_lb_listener_rule" "instances" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.instances.arn
  }
}
resource "aws_lb" "load_balancer" {
  name = "drupal-lb"
  load_balancer_type = "application"
  subnets = data.aws_subnet_ids.default_subnet.ids
  security_groups = [aws_security_group.lb.id]
}

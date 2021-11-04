module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "main-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  private_subnets = []
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = false
  enable_vpn_gateway = true

  tags = var.tags
}


resource "aws_security_group" "alb_security_group" {
  vpc_id = module.vpc.vpc_id
  name   = "alb-nsg"

  tags = merge(var.tags, { Name = "alb-nsg" })
}

resource "aws_security_group_rule" "alb_https_nsg_rule" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.alb_security_group.id
}

resource "aws_security_group_rule" "alb_http_nsg_rule" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = aws_security_group.alb_security_group.id
}

resource "aws_security_group_rule" "alb_allow_all_nsg_rule" {
  type              = "egress"
  to_port           = 0
  protocol          = "-1"
  prefix_list_ids   = []
  from_port         = 0
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.alb_security_group.id
}

## application load balancer
resource "aws_lb" "fe_alb" {
  name               = "fe-alb"
  internal           = false
  load_balancer_type = "application" # use Application Load Balancer
  security_groups    = [aws_security_group.alb_security_group.id]
  subnets            = module.vpc.public_subnets
}

## alb listener with redirect
resource "aws_alb_listener" "front_end" {
  load_balancer_arn = aws_lb.fe_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    order = 1
    type  = "redirect"
    redirect {
      host        = aws_cloudfront_distribution.static_bucket_distribution.domain_name
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# global accellerator
resource "aws_globalaccelerator_accelerator" "alb_ga" {
  name            = "alb-ga"
  ip_address_type = "IPV4"
  enabled         = true

}

resource "aws_globalaccelerator_listener" "alb_ga_listener" {
  accelerator_arn = aws_globalaccelerator_accelerator.alb_ga.id
  client_affinity = "SOURCE_IP"
  protocol        = "TCP"

  port_range {
    from_port = 443
    to_port   = 443
  }
}

resource "aws_globalaccelerator_endpoint_group" "alb_ga_endpoint" {
  listener_arn = aws_globalaccelerator_listener.alb_ga_listener.id

  endpoint_configuration {
    endpoint_id = aws_lb.fe_alb.arn
    weight      = 100
  }
}
locals {
  prefix_name = "${var.application}-${var.environment}"
}

resource "aws_security_group" "security_group" {
  name   = "${local.prefix_name}-${var.security_group_name}"
  vpc_id = var.vpc_id
  egress = [
    for eg in var.rules : merge({
      ipv6_cidr_blocks = null,
      prefix_list_ids  = null,
      security_groups  = null,
      self             = null,
      description      = null,
      cidr_blocks      = null
    }, eg) if eg.type == "egress"
  ]

  ingress = [
    for ig in var.rules : merge({
      ipv6_cidr_blocks = null,
      prefix_list_ids  = null,
      security_groups  = null,
      self             = null,
      description      = null,
      cidr_blocks      = null
    }, ig) if ig.type == "ingress"
  ]
  tags = merge(
    tomap({ "Service" = "VPC" }),
    tomap({ "Name" = "${local.prefix_name}-${var.security_group_name}" })
  )
}

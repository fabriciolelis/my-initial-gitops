locals {
  admin_cloud_alb_rules = [
    {
      type        = "ingress"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "HTTP application protocol"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      description = "HTTPS application protocol"
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      protocol    = "tcp"
      from_port   = 5443
      to_port     = 5443
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      protocol    = "tcp"
      from_port   = 5280
      to_port     = 5280
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      protocol    = "tcp"
      from_port   = 5269
      to_port     = 5269
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "ingress"
      protocol    = "tcp"
      from_port   = 5222
      to_port     = 5222
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      type        = "egress"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

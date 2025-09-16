locals {
  admin_cloud_ecs_rules = [
    {
      type        = "ingress"
      from_port   = var.container_port
      to_port     = var.container_port
      protocol    = "tcp"
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

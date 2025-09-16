locals {
  admin_cloud_rds_rules = [
    {
      type      = "ingress"
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      self      = true
    },
    {
      type            = "ingress"
      protocol        = "tcp"
      from_port       = 3306
      to_port         = 3306
      security_groups = [module.sec_groups_db_access.security_group_id]
    },
    {
      type        = "egress"
      cidr_blocks = ["0.0.0.0/0"]
      from_port   = 0
      protocol    = "-1"
      to_port     = 0
    }
  ]
}

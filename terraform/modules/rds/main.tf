resource "random_password" "passwordDB" {
  length           = var.database_password_size
  number           = true
  special          = true
  override_special = "!#$%&*()-=+[]{}?"
}

resource "aws_secretsmanager_secret" "secretmasterDB" {
  name                    = local.db_secret_name
  recovery_window_in_days = var.secrets_recovery_window
}

resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id = aws_secretsmanager_secret.secretmasterDB.id

  secret_string = jsonencode(
    {
      "DATABASE_USERNAME" : var.root_user,
      "DATABASE_PASSWORD" : "${random_password.passwordDB.result}"
    }
  )
}


data "aws_secretsmanager_secret" "secretmasterDB" {
  arn = aws_secretsmanager_secret.secretmasterDB.arn
}


data "aws_secretsmanager_secret_version" "creds" {
  secret_id = data.aws_secretsmanager_secret.secretmasterDB.arn
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )

  prefix_name             = "${var.application}-${var.environment}"
  db_subnet_group_name    = "${local.prefix_name}-rds-subnet-group"
  db_parameter_group_name = "${local.prefix_name}-parameter-group"
  db_identifier           = "${local.prefix_name}-database"
  db_secret_name          = "${local.prefix_name}-database-secrets"

  secret_map_db = [for secretKey in var.secrets_keys : {
    name      = secretKey
    valueFrom = "${data.aws_secretsmanager_secret.secretmasterDB.arn}:${secretKey}::"
    }
  ]
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = local.db_subnet_group_name
  subnet_ids = var.subnets_ids

  tags = merge(
    tomap({ "Service" = "RDS Subnet Group" }),
    tomap({ "Name" = local.db_subnet_group_name })
  )
}

resource "aws_db_parameter_group" "main" {
  name   = local.db_parameter_group_name
  family = "mysql8.0"

  parameter {
    name  = "character_set_server"
    value = "utf8"
  }

  parameter {
    name  = "character_set_client"
    value = "utf8"
  }

  tags = merge(
    tomap({ "Service" = "Paramater Group" }),
    tomap({ "Name" = local.db_parameter_group_name })
  )
}


resource "aws_db_instance" "main" {
  identifier             = local.db_identifier
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                   = var.application
  username               = local.db_creds.DATABASE_USERNAME
  password               = local.db_creds.DATABASE_PASSWORD
  parameter_group_name   = aws_db_parameter_group.main.name
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  port                   = var.port
  publicly_accessible    = false
  skip_final_snapshot    = true
  vpc_security_group_ids = var.rds_security_groups


  tags = merge(
    tomap({ "Service" = "RDS Database" }),
    tomap({ "Name" = local.db_identifier })
  )
}

locals {
  prefix_name  = "${var.application}-${var.environment}"
  secrets-name = "${local.prefix_name}-application-secrets"

  secret_map = [for secret_key in keys(var.application-secrets) : {
    name      = secret_key
    valueFrom = "${aws_secretsmanager_secret_version.application_secrets_values.arn}:${secret_key}::"
    }

  ]
}

resource "aws_secretsmanager_secret" "application_secrets" {
  recovery_window_in_days = var.secrets_recovery_window
  name                    = local.secrets-name

  tags = merge(
    tomap({ "Service" = "Secrets Manager" }),
    tomap({ "Name" = local.secrets-name })
  )
}

resource "aws_secretsmanager_secret_version" "application_secrets_values" {
  secret_id = aws_secretsmanager_secret.application_secrets.id

  secret_string = jsonencode(
    { for key, value in var.application-secrets :
      key => value
    }
  )
}


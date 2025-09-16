output "application_secrets_arn" {
  value = aws_secretsmanager_secret_version.application_secrets_values.*.arn
}

output "secrets_map" {
  value = local.secret_map
}

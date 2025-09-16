output "hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.main.address
  sensitive   = true
}

output "endpoint" {
  description = "RDS instance hostname"
  value       = aws_db_instance.main.endpoint
  sensitive   = true
}

output "database-name" {
  description = "RDS instance hostname"
  value       = aws_db_instance.main.db_name
  sensitive   = true
}

output "database-secrets-arn" {
  description = "Secrets database ARN"
  value       = aws_secretsmanager_secret.secretmasterDB.arn
}

output "database-secrets-values" {
  description = "Secrets database ARN"
  value       = local.secret_map_db
}

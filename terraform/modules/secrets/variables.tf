variable "application" {
  description = "the name of your application, e.g. \"mixedreality\""
  type        = string
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  type        = string
}

variable "application-secrets" {
  description = "A map of secrets that is passed into the application. Formatted like ENV_VAR = VALUE"
  type        = map(any)
}

variable "secrets_recovery_window" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret"
  type        = number
}

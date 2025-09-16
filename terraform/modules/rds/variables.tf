variable "application" {
  description = "the name of your application, e.g. \"mixedreality\""
  type        = string
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  type        = string
}

variable "subnets_ids" {
  description = "Comma separated list of subnet IDs"
  type        = list(string)
}

variable "rds_security_groups" {
  description = "Comma separated list of security groups"
  type        = list(string)
}

variable "allocated_storage" {
  description = "The amount of allocated storage in gigabytes"
  type        = number
}

variable "engine" {
  description = "The database engine."
  type        = string
}

variable "engine_version" {
  description = "The running version of the database."
  type        = string
}

variable "instance_class" {
  description = "The RDS instance class"
  type        = string
}

variable "port" {
  description = "The database port"
  type        = string
}

variable "database_password_size" {
  description = "The length of the string desired"
  type        = number
}

variable "secrets_recovery_window" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret"
  type        = number
}

variable "root_user" {
  description = "Username for the master DB user"
  type        = string
}

variable "secrets_keys" {
  description = "Keys for secrets to receive values during database creation"
  type        = list(string)
}


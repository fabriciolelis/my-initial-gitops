variable "application" {
  description = "the name of your application, e.g. \"mixedreality\""
  type        = string
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  type        = string
}

variable "vpc_id" {
  description = "The VPC ID"
  type        = string
}

variable "rules" {
  description = "Security group rule"
}

variable "security_group_name" {
  description = "Security group name"
  type        = string
}

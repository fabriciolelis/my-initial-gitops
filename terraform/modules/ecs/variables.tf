variable "application" {
  description = "the name of your application, e.g. \"epsoncloud\""
  type        = string
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  type        = string
}

variable "region" {
  description = "the AWS region in which resources are created"
  type        = string
}

variable "subnets_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

variable "ecs_service_security_groups" {
  description = "Comma separated list of security groups"
  type        = list(string)
}

variable "container_port" {
  description = "Port of container"
  type        = number
}

variable "container_cpu" {
  description = "The number of cpu units used by the task"
  type        = number
}

variable "container_memory" {
  description = "The amount (in MiB) of memory used by the task"
  type        = number
}

variable "aws_ecr_repository_url" {
  description = "Docker image to be launched"
  type        = string
}

variable "aws_alb_target_group_arn" {
  description = "ARN of the alb target group"
  type        = string
}

variable "service_desired_count" {
  description = "Number of services running in parallel"
  type        = number
}

variable "container_environment" {
  description = "The container environmnent variables"
  type        = list(object({ value = string, name = string }))
}

variable "container_secrets" {
  description = "The container secret environmnent variables"
  type        = list(object({ valueFrom = string, name = string }))
}

variable "container_secrets_arns" {
  description = "ARN for secrets"
  type        = list(string)
}

variable "app_bucket" {
  description = "Bucket used by application previously created"
  type        = string
}

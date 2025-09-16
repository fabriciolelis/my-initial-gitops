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

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "alb_security_groups" {
  description = "Comma separated list of security groups"
  type        = list(string)
}

variable "alb_tls_cert_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
  type        = string
}

variable "health_check_path" {
  description = "Path to check if the service is healthy, e.g. \"/status\""
  type        = string
}

variable "zone_id" {
  description = "Zone ID"
  type        = string
}

variable "healthy_threshold" {
  description = "Number of consecutive health checks successes required before considering an unhealthy target healthy."
  type        = string
}

variable "interval" {
  description = "Approximate amount of time, in seconds, between health checks of an individual target."
  type        = string
}

variable "timeout" {
  description = "Amount of time, in seconds, during which no response means a failed health check."
  type        = string
}

variable "http_protocol" {
  description = "Protocol to use for routing traffic to the targets."
  type        = string
}

variable "https_protocol" {
  description = "Protocol to use for routing traffic to the targets."
  type        = string
}

variable "matcher" {
  description = "Response codes to use when checking for a healthy responses from a target. "
  type        = string

}

variable "unhealthy_threshold" {
  description = "Number of consecutive health check failures required before considering the target unhealthy"
  type        = string
}

variable "http_port" {
  description = "Port number for http traffic"
  type        = string
}

variable "https_port" {
  description = "Port number for https traffic"
  type        = string
}

variable "load_balancer_type" {
  description = "The type of load balancer to create"
  type        = string
}

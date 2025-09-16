/*
variable "domain_name" {
  description = "Domain name"
  type        = string
}
*/
variable "bucket_name" {
  description = "Bucket name"
  type        = string
}

variable "tsl_certificate_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
  type        = string
}

variable "api_endpoint" {
  description = "The DNS to backend api endpoint"
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

variable "backend_api_path" {
  description = "Api path to redirect request to backend"
  type        = string
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  type        = string
}

variable "application" {
  description = "the name of your application, e.g. \"virtualpromoter\""
  type        = string
}

variable "domain_address" {
  description = "The domain that will be registered the URL address on Route 53"
  type        = string
}

variable "module_name" {
  description = "Module name"
  type        = string
}

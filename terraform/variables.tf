## COMMOM VARIABLES ###
variable "region" {
  description = "AWS region"
  type        = string
}

variable "application" {
  description = "the name of your application, e.g. \"admincloud\""
  type        = string

  validation {
    condition     = can(regex("[:alpha:]", var.application))
    error_message = "Application name must have only letters. Because database schema name."
  }
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  type        = string
}

variable "project" {
  description = "Project name that application belongs"
  type        = string
}

variable "availability_zones" {
  description = "a comma-separated list of availability zones, defaults to all AZ of the region, if set to something other than the defaults, both private_subnets and public_subnets have to be defined as well"
  type        = list(string)
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "private_subnets" {
  description = "a list of CIDRs for private subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "a list of CIDRs for public subnets in your VPC, must be set if the cidr variable is defined, needs to have as many elements as there are availability zones"
  type        = list(string)
}

variable "http_port" {
  description = "Port number for http traffic"
  type        = number
}

variable "https_port" {
  description = "Port number for https traffic"
  type        = number
}

variable "zone_id" {
  description = "ID from hosted zone"
  type        = string
}

variable "secrets_recovery_window" {
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret"
  type        = number
}

## SECRETS VALUES ###
variable "application-secrets" {
  description = "A map of secrets that is passed into the application. Formatted like ENV_VAR = VALUE"
  type        = map(string)
}

## ECS CONFIGURATIONS ###
variable "service_desired_count" {
  description = "Number of tasks running in parallel"
  type        = number
}

variable "container_port" {
  description = "The port where the Docker is exposed"
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

variable "token_validity_seconds" {
  description = "Token time validity"
  type        = number
}
variable "token_remeber_seconds" {
  description = "Token time remeber"
  type        = number
}

variable "xmpp_server_host" {
  description = "XMPP server host address"
  type        = string
}
variable "xmpp_port" {
  description = "XMPP server port"
  type        = string
}


### ALB CONFIGURATIONS ###

variable "load_balancer_type" {
  description = "The type of load balancer to create"
  type        = string
}

### Target Group on ALB CONFIGURATIONS ###
variable "tg_health_check_path" {
  description = "Http path for task health check"
  type        = string
}

variable "tg_healthy_threshold" {
  description = "Number of consecutive health checks successes required before considering an unhealthy target healthy."
  type        = string
}

variable "timeout" {
  description = "Amount of time, in seconds, during which no response means a failed health check."
  type        = string
}

variable "tg_interval" {
  description = "Approximate amount of time, in seconds, between health checks of an individual target."
  type        = string
}

variable "http_protocol" {
  description = "Protocol to use for routing HTTP traffic to the targets."
  type        = string
}

variable "https_protocol" {
  description = "Protocol to use for routing HTTPS traffic to the targets."
  type        = string
}

variable "tg_matcher" {
  description = "Response codes to use when checking for a healthy responses from a target. "
  type        = string
}

variable "tg_unhealthy_threshold" {
  description = "Number of consecutive health check failures required before considering the target unhealthy"
  type        = string
}

variable "tsl_certificate_arn" {
  description = "The ARN of the certificate that the ALB uses for https"
  type        = string
}

variable "domain_address" {
  description = "The domain that will be registered the URL address on Route 53"
  type        = string
}

### EC2 bastion Configurations ###
variable "bastion_key_name" {
  description = "The key name using to access the bastion instance"
  type        = string
}

variable "bastion_ami" {
  description = "AMI to use for the instance"
  type        = string
}

### S3 to host frontend apps Configurations ###

# Use the only one certificate if the region of application deployment is us-east-1. Because Cloudfront only accepts certificates 
# at us-east-1
variable "tsl_certificatecloudfront" {
  description = "The ARN of the certificate that the Cloudfront uses."
  type        = string
}

variable "app_bucket" {
  description = "Bucket used by application previously created"
  type        = string
}

variable "admin_front_bucket" {
  description = "Bucket name to host admin frontend"
  type        = string
}

variable "marketplace_front_bucket" {
  description = "Bucket name to host admin marketplace"
  type        = string
}

variable "cloud_watch_stream" {
  description = "Bucket to store cloudwatch logs"
  type        = string
}

variable "backend_api_path" {
  description = "Api path to redirect request to backend"
  type        = string
}

#### DATABASE CONFIGURATIONS ####

variable "db_allocated_storage" {
  description = "The amount of allocated storage in gigabytes"
  type        = number
}

variable "db_engine" {
  description = "The database engine"
  type        = string
}

variable "db_engine_version" {
  description = "The running version of the database"
  type        = string
}

variable "db_instance_class" {
  description = "The RDS instance class"
  type        = string
}

variable "db_port" {
  description = "The database port"
  type        = number
}

variable "db_password_size" {
  description = "The length of the string desired"
  type        = number
}

variable "db_root_user" {
  description = "Username for the master DB user"
  type        = string
}

variable "db_secrets_keys" {
  description = "Keys for secrets to receive values during database creation"
  type        = list(string)
}

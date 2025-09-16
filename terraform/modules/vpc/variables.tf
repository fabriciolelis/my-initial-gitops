variable "application" {
  description = "the name of your application, e.g. \"mixedreality\""
  type        = string
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  type        = string
}

variable "cidr" {
  description = "The CIDR block for the VPC."
  type        = string
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "List of private subnets"
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

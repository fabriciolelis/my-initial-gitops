variable "application" {
  description = "the name of your stack, e.g. \"mixedreality\""
  type        = string
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  type        = string
}

variable "subnets" {
  description = "List of subnet IDs"
}

variable "security_groups" {
  description = "Comma separated list of security groups"
}

variable "bastion_key" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
}

variable "bastion_ami" {
  description = "AMI to use for the instance. "
  type        = string
}

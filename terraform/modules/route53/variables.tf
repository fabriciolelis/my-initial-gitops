variable "application" {
  description = "the name of your application, e.g. \"mixedreality\""
  type        = string
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
  type        = string
}

variable "hosted_zone_id" {
  description = "The ID of the hosted zone to contain this record"
  type        = string
}

variable "service_zone_id" {
  description = "Hosted zone ID for a CloudFront distribution, S3 bucket, ELB, or Route 53 hosted zone."
  type        = string
}

variable "service_dns_name" {
  description = "DNS domain name for a CloudFront distribution, S3 bucket, ELB, or another resource record set in this hosted zone."
  type        = string
}

variable "domain_address" {
  description = "The domain that will be registered the URL address on Route 53"
  type        = string
}

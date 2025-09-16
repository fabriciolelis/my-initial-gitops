provider "aws" {
  region = var.region
  default_tags {
    tags = {
      Environment = var.environment
      Application = var.application
      Project     = var.project
    }
  }
}

terraform {
  required_version = ">= 0.13.5"
}

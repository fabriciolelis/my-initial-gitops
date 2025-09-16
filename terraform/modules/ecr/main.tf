locals {
  prefix_name = "${var.application}-${var.environment}"
}

resource "aws_ecr_repository" "main" {
  name                 = local.prefix_name
  image_tag_mutability = "MUTABLE"

  tags = merge(
    tomap({ "Service" = "ECR" }),
    tomap({ "Name" = local.prefix_name })
  )
}

resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = file("${path.module}/ecr-policy.json")
}

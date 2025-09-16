locals {
  prefix_name               = "${var.application}-${var.environment}"
  ecs_task_execution_role   = "${local.prefix_name}-ecsTaskExecutionRole"
  ecs_task_ecs_task_role    = "${local.prefix_name}-ecsTaskRole"
  task-policy-secrets       = "${local.prefix_name}-task-policy-secrets"
  cluster_name              = "${local.prefix_name}-cluster"
  cloudwatch_log_group_name = "${local.prefix_name}-cloudwatch-lg-gp"
  task_name                 = "${local.prefix_name}-task"
  container_name            = "${local.prefix_name}-container"
  task_definition_name      = "${local.prefix_name}-task-definition"
  service_name              = "${local.prefix_name}-service"
  bucket-task-policy        = "${local.prefix_name}-bucket"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = local.ecs_task_execution_role

  assume_role_policy = file("${path.module}/ecs-task-execution-policy.json")
}

resource "aws_iam_role" "ecs_task_role" {
  name = local.ecs_task_ecs_task_role

  assume_role_policy = file("${path.module}/ecs-task-role-policy.json")
}

resource "aws_iam_policy" "mixed-reality-policy" {
  name        = local.bucket-task-policy
  description = "Policy that allows access S3 bucket"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObjectAcl",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:PutObjectAcl"
            ],
            "Resource": [
                "arn:aws:s3:::${var.app_bucket}/*"
            ]
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = aws_iam_policy.mixed-reality-policy.arn
}

resource "aws_iam_policy" "secrets" {
  name        = local.task-policy-secrets
  description = "Policy that allows access to the secrets we created"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AccessSecrets",
            "Effect": "Allow",
            "Action": [
              "secretsmanager:GetSecretValue"
            ],
            "Resource": ${jsonencode(var.container_secrets_arns)}
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs-task-execution-role-policy-attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs-task-role-policy-attachment-for-secrets" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.secrets.arn
}

resource "aws_ecs_cluster" "main" {
  name = local.cluster_name

  tags = merge(
    tomap({ "Service" = "Cluster" }),
    tomap({ "Name" = local.cluster_name })
  )
}

resource "aws_cloudwatch_log_group" "main" {
  name = "/ecs/${local.task_name}"

  tags = merge(
    tomap({ "Service" = "Cloudwatch Log Group" }),
    tomap({ "Name" = local.cloudwatch_log_group_name })
  )
}

resource "aws_ecs_task_definition" "main" {
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  family                   = local.task_name
  cpu                      = var.container_cpu
  memory                   = var.container_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  container_definitions = jsonencode([{
    name        = local.container_name
    image       = var.aws_ecr_repository_url
    environment = var.container_environment
    essential   = true
    portMappings = [{
      protocol      = "tcp"
      containerPort = var.container_port
      hostPort      = var.container_port
    }]
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        awslogs-group         = aws_cloudwatch_log_group.main.name
        awslogs-stream-prefix = "ecs"
        awslogs-region        = var.region
      }
    }
    secrets = var.container_secrets
  }])

  tags = merge(
    tomap({ "Service" = "Task Definition" }),
    tomap({ "Name" = local.task_definition_name })
  )
}

resource "aws_ecs_service" "main" {
  name                               = local.service_name
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = var.service_desired_count
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = var.ecs_service_security_groups
    subnets          = var.subnets_ids
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.aws_alb_target_group_arn
    container_name   = local.container_name
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }

  tags = merge(
    tomap({ "Service" = "ECS Service" }),
    tomap({ "Name" = local.service_name })
  )

}

output "executionRoleArn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "taskRoleArn" {
  value = aws_iam_role.ecs_task_role.arn
}

output "cluster_name" {
  value = aws_ecs_cluster.main.name
}

output "service_name" {
  value = aws_ecs_service.main.name
}

output "task_name" {
  value = aws_ecs_task_definition.main.family
}

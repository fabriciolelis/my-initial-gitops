output "aws_ecr_repository_url" {
  value = module.ecr.aws_ecr_repository_url
}

output "ecs_cluster_name" {
  value = module.ecs.cluster_name
}

output "service_name" {
  value = module.ecs.service_name
}

output "task_name" {
  value = module.ecs.task_name
}

output "cloudfront_admin_id" {
  value = module.admin-front.cloudfront_id
}

output "cloudfront_marketplace_id" {
  value = module.marketplace-front.cloudfront_id
}

output "Bastion_public_IP" {
  value = module.bastion-host.bastion_ip
}

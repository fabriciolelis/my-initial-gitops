module "vpc" {
  source             = "./modules/vpc"
  application        = var.application
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

module "sec_groups_alb" {
  source              = "./modules/security-groups"
  application         = var.application
  vpc_id              = module.vpc.id
  rules               = local.admin_cloud_alb_rules
  environment         = var.environment
  security_group_name = "alb-sg"
}


module "sec_groups_db_access" {
  source              = "./modules/security-groups"
  application         = var.application
  vpc_id              = module.vpc.id
  rules               = local.admin_cloud_db_access_rules
  environment         = var.environment
  security_group_name = "db-access-sg"
}

module "sec_groups_ecs" {
  source              = "./modules/security-groups"
  application         = var.application
  vpc_id              = module.vpc.id
  rules               = local.admin_cloud_ecs_rules
  environment         = var.environment
  security_group_name = "ecs-task-sg"
}

module "sec_groups_rds" {
  source              = "./modules/security-groups"
  application         = var.application
  vpc_id              = module.vpc.id
  rules               = local.admin_cloud_rds_rules
  environment         = var.environment
  security_group_name = "rds-access-sg"
}

module "sec_groups_bastion" {
  source              = "./modules/security-groups"
  application         = var.application
  vpc_id              = module.vpc.id
  rules               = local.admin_cloud_bastion_rules
  environment         = var.environment
  security_group_name = "bastion-sg"
}

module "secrets" {
  source                  = "./modules/secrets"
  application             = var.application
  environment             = var.environment
  application-secrets     = var.application-secrets
  secrets_recovery_window = var.secrets_recovery_window
}

module "ecr" {
  source      = "./modules/ecr"
  application = var.application
  environment = var.environment
}


module "alb" {
  source              = "./modules/alb"
  application         = var.application
  load_balancer_type  = var.load_balancer_type
  vpc_id              = module.vpc.id
  subnets_ids         = module.vpc.public_subnets_ids
  zone_id             = var.zone_id
  environment         = var.environment
  alb_security_groups = [module.sec_groups_alb.security_group_id]
  alb_tls_cert_arn    = var.tsl_certificate_arn
  health_check_path   = var.tg_health_check_path
  healthy_threshold   = var.tg_healthy_threshold
  interval            = var.tg_interval
  timeout             = var.timeout
  http_protocol       = var.http_protocol
  https_protocol      = var.https_protocol
  matcher             = var.tg_matcher
  unhealthy_threshold = var.tg_unhealthy_threshold
  http_port           = var.http_port
  https_port          = var.https_port
}

module "bastion-host" {
  source          = "./modules/ec2"
  application     = var.application
  environment     = var.environment
  bastion_ami     = var.bastion_ami
  subnets         = module.vpc.public_subnets_ids
  security_groups = [module.sec_groups_bastion.security_group_id, module.sec_groups_db_access.security_group_id]
  bastion_key     = var.bastion_key_name
}

module "admin-front" {
  source              = "./modules/s3"
  bucket_name         = var.admin_front_bucket
  domain_address      = var.domain_address
  environment         = var.environment
  application         = var.application
  api_endpoint        = module.alb.alb_dns_name
  tsl_certificate_arn = var.tsl_certificatecloudfront
  http_port           = var.http_port
  https_port          = var.https_port
  backend_api_path    = var.backend_api_path
  module_name         = var.application
}


module "marketplace-front" {
  source              = "./modules/s3"
  bucket_name         = var.marketplace_front_bucket
  domain_address      = var.domain_address
  environment         = var.environment
  application         = var.application
  api_endpoint        = module.alb.alb_dns_name
  tsl_certificate_arn = var.tsl_certificatecloudfront
  http_port           = var.http_port
  https_port          = var.https_port
  backend_api_path    = var.backend_api_path
  module_name         = "marketplace"
}


module "route53-marketplace" {
  source           = "./modules/route53"
  application      = "marketplace"
  environment      = var.environment
  hosted_zone_id   = var.zone_id
  service_zone_id  = module.marketplace-front.cloudfront_zone_id
  service_dns_name = module.marketplace-front.cloudfront_domain
  domain_address   = var.domain_address
}

module "route53-admin" {
  source           = "./modules/route53"
  application      = var.application
  environment      = var.environment
  hosted_zone_id   = var.zone_id
  service_zone_id  = module.admin-front.cloudfront_zone_id
  service_dns_name = module.admin-front.cloudfront_domain
  domain_address   = var.domain_address
}

module "db_instance" {
  source                  = "./modules/rds"
  application             = var.application
  environment             = var.environment
  root_user               = var.db_root_user
  secrets_keys            = var.db_secrets_keys
  database_password_size  = var.db_password_size
  secrets_recovery_window = var.secrets_recovery_window
  subnets_ids             = module.vpc.private_subnets_ids
  rds_security_groups     = [module.sec_groups_rds.security_group_id]
  allocated_storage       = var.db_allocated_storage
  engine                  = var.db_engine
  engine_version          = var.db_engine_version
  instance_class          = var.db_instance_class
  port                    = var.db_port
}

module "ecs" {
  source                      = "./modules/ecs"
  application                 = var.application
  environment                 = var.environment
  region                      = var.region
  subnets_ids                 = module.vpc.private_subnets_ids
  aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  ecs_service_security_groups = [module.sec_groups_ecs.security_group_id, module.sec_groups_db_access.security_group_id]
  container_port              = var.container_port
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  service_desired_count       = var.service_desired_count
  app_bucket                  = var.app_bucket
  container_environment = [
    { name  = "AWS_BUCKET_NAME",
      value = var.app_bucket
    },
    { name  = "AWS_CLOUD_WATCH_STREAM",
      value = var.cloud_watch_stream
    },
    {
      name  = "AWS_REGION",
      value = var.region
    },
    {
      name  = "XMPP_HOST",
      value = var.xmpp_server_host
    },
    {
      name  = "XMPP_PORT",
      value = var.xmpp_port
    },
    {
      name  = "XMPP_DOMAIN",
      value = var.xmpp_server_host
    },
    {
      name  = "DATABASE_URL",
      value = module.db_instance.hostname
    },
    {
      name  = "DATABASE_NAME",
      value = module.db_instance.database-name
    },
    {
      name  = "TOKEN_VALIDITY_SECONDS",
      value = var.token_validity_seconds
    },
    {
      name  = "TOKEN_REMEBER_SECONDS",
      value = var.token_remeber_seconds
    },
    {
      name = "MARKETPLACE_URL",
      value = "https://${module.route53-marketplace.router_53_domain}"
    }
  ]

  container_secrets      = concat(module.secrets.secrets_map, module.db_instance.database-secrets-values)
  aws_ecr_repository_url = module.ecr.aws_ecr_repository_url
  container_secrets_arns = concat(module.secrets.application_secrets_arn, [module.db_instance.database-secrets-arn])
  depends_on = [
    module.db_instance
  ]
} 


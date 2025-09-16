locals {
  prefix_name = "${var.application}-${var.environment}"
  route       = "${local.prefix_name}-route53-record"
}

resource "aws_route53_record" "record" {
  zone_id = var.hosted_zone_id
  name    = "${local.prefix_name}.${var.domain_address}"
  type    = "A"

  alias {
    name                   = var.service_dns_name
    zone_id                = var.service_zone_id
    evaluate_target_health = true
  }
}

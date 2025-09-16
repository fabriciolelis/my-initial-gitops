
output "cloudfront_domain" {
  value = aws_cloudfront_distribution.root_s3_distribution.domain_name
}

output "cloudfront_zone_id" {
  value = aws_cloudfront_distribution.root_s3_distribution.hosted_zone_id
}

output "cloudfront_id" {
  value = aws_cloudfront_distribution.root_s3_distribution.id
}

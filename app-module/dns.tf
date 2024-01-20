resource "aws_route53_zone" "primary" {
  name  = var.dns_domain
  count = var.dns_create_zone ? 1 : 0
}

data "aws_route53_zone" "primary" {
  name  = var.dns_domain
  count = var.dns_create_zone ? 0 : 1
}

locals {
  # We want to reuse existing zones using this flag
  # so we don't have to update NS records all the time.
  zone_id   = var.dns_create_zone ? aws_route53_zone.primary[0].zone_id : data.aws_route53_zone.primary[0].zone_id
  subdomain = var.app_environment == "live" ? "" : "${var.app_environment}."
}

resource "aws_route53_record" "root" {
  name    = "${local.subdomain}${var.dns_domain}"
  type    = "A"
  zone_id = local.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_lb.load_balancer.dns_name
    zone_id                = aws_lb.load_balancer.zone_id
  }
}

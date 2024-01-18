resource "aws_route53_zone" "primary" {
  name = var.dns_domain
}
resource "aws_route53_record" "root" {
  name    = var.dns_domain
  type    = "A"
  zone_id = aws_route53_zone.primary.zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_lb.load_balancer.dns_name
    zone_id                = aws_lb.load_balancer.zone_id
  }
}

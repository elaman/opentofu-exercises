data "cloudflare_zone" "primary" {
  name = var.dns_domain
}

resource "cloudflare_record" "primary" {
  name    = var.app_environment == "live" ? "@" : var.app_environment
  type    = "CNAME"
  zone_id = data.cloudflare_zone.primary.id
  proxied = true
  value   = aws_lb.load_balancer.dns_name
}

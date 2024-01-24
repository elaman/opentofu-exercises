output "app_ip_addr" {
  description = "urls"
  value = var.app_environment == "live" ? var.dns_domain : "${var.app_environment}.${var.dns_domain}"
}

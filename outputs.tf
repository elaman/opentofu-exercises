output "instance_1_ip_addr" {
  value = aws_instance.drpler_1.private_ip
}
output "instance_2_ip_addr" {
  value = aws_instance.drpler_2.private_ip
}
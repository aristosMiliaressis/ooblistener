
output "vps_ip" {
  description = "The public ip of the VPS instance."
  value       = aws_instance.this.public_ip
}

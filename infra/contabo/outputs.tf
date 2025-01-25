output "vps_ip" {
  description = "The public ip of the VPS instance."
  value       = contabo_instance.this.ip_config[0].v4[0].ip
}

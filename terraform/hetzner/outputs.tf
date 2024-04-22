
output "vps_ip" {
  description = "The public ip of the VPS instance."
  value       = hcloud_server.this.ipv4_address
}

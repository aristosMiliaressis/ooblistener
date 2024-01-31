
output "ec2_ip" {
  description = "The public ip of the EC2 instance."
  value       = aws_instance.this.public_ip
}

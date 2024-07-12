output "aws_instance" {
  value       = aws_instance.example_instance.associate_public_ip_address
}

output "aws_security_group" {
  value       = aws_security_group.example_sg.name
}

output "region" {
  value       = var.region
}

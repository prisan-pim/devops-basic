provider "aws" {
  region = var.region
  profile = var.profile
}

# Create EC2 Instance
resource "aws_instance" "example_instance" {
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.example_sg.id]
  key_name               = var.key_name

  tags = {
    Name = "${var.name}"
  }
}

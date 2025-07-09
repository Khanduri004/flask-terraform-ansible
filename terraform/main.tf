provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "app_server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name

  tags = {
    Name = "FlaskAppServer"
  }
}

output "public_ip" {
  value = aws_instance.app_server.public_ip
}


provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/japsahni/.aws/credentials"
  profile                 = "terraform"
}

resource "aws_security_group" "allow_tls" {
  name        = "allow_eip_tls"
  description = "Allow TLS inbound traffic to eip"
  ingress {
    description = "TLS from EIP"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["${aws_eip.my_eip.public_ip}/32"]
  }
}

resource "aws_eip" "my_eip" {
  vpc      = true
}

output "eip" {
    value = aws_eip.my_eip.public_ip
}
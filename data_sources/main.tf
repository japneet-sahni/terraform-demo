provider "aws" {
  region                  = "us-east-2"
  shared_credentials_file = "/Users/japsahni/.aws/credentials"
  profile                 = "terraform"
}

data "aws_ami" "my_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}
resource "aws_instance" "my_ec2" {
  ami           = data.aws_ami.my_ami.id
  instance_type = "t2.nano"
  # Use terraform validate command to validate
  #  sky           = "blue"
}
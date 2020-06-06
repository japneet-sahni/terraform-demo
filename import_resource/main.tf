provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/japsahni/.aws/credentials"
  profile                 = "terraform"
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-09d95fab7fff3776c"
  instance_type = "t2.micro"
}
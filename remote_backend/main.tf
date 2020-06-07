terraform {
    backend "remote" {}
}

provider "aws" {
    region = "us-east-1"
    profile = "terraform"
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-09d95fab7fff3776c"
  instance_type = "t2.nano"
}
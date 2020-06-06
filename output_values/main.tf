provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "/Users/japsahni/.aws/credentials"
  profile                 = "terraform"
}

resource "aws_eip" "my_eip" {
  vpc      = true
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "japneet-test-bucket-30"
}


terraform {
  backend "s3" {
    bucket  = "terraform-state-2hoxf6iw"
    key     = "terraform.tfstate"
    region  = "us-east-1"
  }
}

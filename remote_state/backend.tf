terraform {
  backend "s3" {
    bucket                  = "japneet30-remote-backend"
    key                     = "remotedemo.tfstate"
    region                  = "us-east-1"
    #shared_credentials_file = "/Users/japsahni/.aws/credentials"
    profile                 = "terraform"
    dynamodb_table = "s3-state-lock"
    workspace_key_prefix = "workspace"
  }
}
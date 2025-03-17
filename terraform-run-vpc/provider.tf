terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.88.0"
    }
  }
  backend "s3" {
    bucket    = "sun78s-bucket"
    key       = "vpc-practice"
    region    = "us-east-1"
    dynamodb_table = "state-lock"
}
}

provider "aws" {
  region = "us-east-1"
}
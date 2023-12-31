terraform {
  required_version = "~> 1.5.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.14.0"
    }
  }
}

provider "aws" {
  region  = "us-east-2"
  profile = "default"
  default_tags {
    tags = {
      Name = "Teamspeak"
    }
  }
}
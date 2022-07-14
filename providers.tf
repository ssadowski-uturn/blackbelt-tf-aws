terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.1"
    }
  }

  backend "s3" {
    bucket = "d93592a-1faa-4ddb-801d-b0e1c16596af"
    key    = "blackbelt-infra"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"
}

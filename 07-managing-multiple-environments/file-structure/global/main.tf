terraform {
  required_version = ">= 1.10"

  # Assumes the s3 bucket is already set up
  # See /code/03-basics/aws-backend
  backend "s3" {
    bucket       = "devops-directive-tf-state-custom-aum-test"
    key          = "07-managing-multiple-environments/global/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Route53 zone is shared across staging and production
resource "aws_route53_zone" "primary" {
  name = "devopsdeployed.com"
}

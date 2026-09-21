terraform {
  required_version = ">= 1.10"

  # Assumes the s3 bucket is already set up
  # See /code/03-basics/aws-backend
  backend "s3" {
    bucket       = "devops-directive-tf-state-custom-aum-test"
    key          = "06-organization-and-modules/consul/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
    encrypt      = true
  }

  required_providers {
    aws = {
      source = "hashicorp/aws"
      # The consul module below is archived and still uses the aws_subnet_ids
      # data source, which was removed in provider 5.0. Stay on 4.x until
      # the module is replaced.
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

############################################################
##
## NOTE: if you are deploying this in your production setup
## follow the instructions in the github repo on how to modify
## deploying with the defaults here as an example of the power
## of modules.
##
## REPO: https://github.com/hashicorp/terraform-aws-consul
##
############################################################
module "consul" {
  source = "git::https://github.com/hashicorp/terraform-aws-consul.git" # https, so no SSH key is needed
}

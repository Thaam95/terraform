terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "mmt-shared-nfw-dev-terraform-state-01"
    key     = "splunk-logging/spoke/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy    = "terraform"
      Project      = "splunk-logging"
      Environment  = var.environment
      SpokeAccount = var.spoke_account_id
    }
  }
}

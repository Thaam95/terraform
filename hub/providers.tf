terraform {
  required_version = ">= 1.7.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "s3-splunk-terraformstate-prd-001"
    key     = "splunklogging/hub/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    # dynamodb_table = "tf-state-lock"
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      ManagedBy   = "terraform"
      Project     = "splunklogging"
      Environment = var.environment
      Account     = "HUB-CTA"
    }
  }
}

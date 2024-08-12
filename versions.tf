terraform {
  cloud {
    organization = "HKT-Projects"

    workspaces {
      name = "aws-abac"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.58.0"
    }
  }
}

provider "aws" {
  region = var.region
}


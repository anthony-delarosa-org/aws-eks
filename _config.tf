terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "YOUR_ORG_HERE"

    workspaces {
      name = "WORKSPACE_NAME"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.6.0"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.9.0"
    }
  }
}

provider "aws" {
  region  = "us-west-2"
  profile = "YOUR_PROFILE_NAME"
}

# Provider aws
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Provider baas us-east-1
provider "aws" {
  region  = "us-west-2"
  profile = "at-baas"
  default_tags {
    tags = {
      Cliente  = "AT"
      Servicio = "LAB-BAAS"
    }
  }
}

## Provider cuenta root de AWS
provider "aws" {
  alias   = "at-root"
  region  = "us-west-2"
  profile = "at-root"
  default_tags {
    tags = {
      Cliente  = "AT"
      Servicio = "LAB-BAAS"
    }
  }
}
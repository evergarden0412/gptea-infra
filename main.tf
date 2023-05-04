terraform {
  backend "s3" {
    bucket  = "gptea-terraform-state"
    key     = "terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.65"
    }
  }
}
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  alias  = "mumbai"
  region = var.primary_region
}

provider "aws" {
  alias  = "hyderabad"
  region = var.dr_region
}

resource "aws_route53_health_check" "mumbai_api" {
  fqdn              = var.primary_api_domain
  port              = 443
  type              = "HTTPS"
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 10
}

resource "aws_kms_key" "paysecure_primary" {
  provider                = aws.mumbai
  description             = "PaySecure primary multi-region KMS key"
  multi_region            = true
  deletion_window_in_days = 30
}

resource "aws_kms_replica_key" "paysecure_dr" {
  provider        = aws.hyderabad
  description     = "PaySecure DR replica KMS key"
  primary_key_arn = aws_kms_key.paysecure_primary.arn
}

resource "aws_dynamodb_table" "idempotency" {
  provider     = aws.mumbai
  name         = "paysecure-idempotency"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "idempotency_key"

  attribute {
    name = "idempotency_key"
    type = "S"
  }

  replica {
    region_name = var.dr_region
  }

  server_side_encryption {
    enabled = true
  }

  point_in_time_recovery {
    enabled = true
  }
}

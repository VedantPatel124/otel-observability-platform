# AWS Provider Configuration
provider "aws" {
  region = "us-east-1"

  default_tags {
    tags = {
      Environment = "Production"
      ManagedBy   = "Terraform"
      Project     = "EKS-Infrastructure"
    }
  }
}

# S3 Bucket for Terraform State
resource "aws_s3_bucket" "terraform_state" {
  bucket = "demo-s3-project-vp"

  lifecycle {
    prevent_destroy = false
  }

  tags = {
    Name = "Terraform State Bucket"
  }
}

# Enable versioning for S3 bucket
resource "aws_s3_bucket_versioning" "terraform_state_versioning" {
  bucket = aws_s3_bucket.terraform_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Enable server-side encryption for S3 bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state_encryption" {
  bucket = aws_s3_bucket.terraform_state.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Block public access to S3 bucket
#resource "aws_s3_bucket_public_access_block" "terraform_state_public_access_block" {
#  bucket = aws_s3_bucket.terraform_state.id

#  block_public_acls       = true
#  block_public_policy     = true
#  ignore_public_acls      = true
#  restrict_public_buckets = true
#}

# DynamoDB Table for Terraform State Locks
resource "aws_dynamodb_table" "terraform_locks" {
  name           = "terraform-eks-state-locks"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "Terraform State Locks"
  }
}

# Data source to get current AWS account ID
#data "aws_caller_identity" "current" {}

# Outputs
#output "s3_bucket_name" {
#  value       = aws_s3_bucket.terraform_state.id
#  description = "Name of the S3 bucket for Terraform state"
#}

#output "dynamodb_table_name" {
#  value       = aws_dynamodb_table.terraform_locks.name
#  description = "Name of the DynamoDB table for state locks"
#}

provider "aws" {
  region = var.aws_region
}

# =========================
# Common Tags
# =========================
locals {
  common_tags = {
    Environment = var.environment
    ManagedBy   = "Terraform"
    Project     = "tripla-sre-assignment"
  }
}

# =========================
# EKS Cluster
# =========================
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.21.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  eks_managed_node_groups = {
    default = {
      desired_size   = var.node_desired_size
      min_size       = var.node_min_size
      max_size       = var.node_max_size
      instance_types = [var.instance_type]
    }
  }

  tags = local.common_tags
}

# =========================
# S3 Bucket
# =========================
resource "aws_s3_bucket" "static_assets" {
  bucket = "${var.environment}-tripla-static-assets"

  tags = local.common_tags
}

resource "aws_s3_bucket_acl" "static_assets_acl" {
  bucket = aws_s3_bucket.static_assets.id
  acl    = "private"
}

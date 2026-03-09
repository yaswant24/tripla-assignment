output "cluster_name" {
  value = module.eks.cluster_name
}

output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "s3_bucket_name" {
  value = aws_s3_bucket.static_assets.bucket
}
